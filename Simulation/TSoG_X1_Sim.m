% Based off of https://github.com/TSoGiants/MECH2103-Computational-Aerodynamics
%  TSoG_X1_Sim is the main function to run the X1 simulation. It can be run with
% or without an input Test Case (the sim will run with default inputs if no Test
% Case is provided)

function [ Results ] = TSoG_X1_Sim( TestCase )
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %                        Simulation Setup
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if nargin == 0
    TestCase.Name        = 'Default';
    TestCase.Description = 'Default Test Case for X1 Simulation';
    % X - left/right, Y - up/down
    P0 = [0, 10]; % Initial position [X, Y] (m)
    V0 = [2, 0];  % Initial velocity [Vx, Vy] (m/s)
    O0 = [0];     % Initial orientation [Pitch] (degrees)

    TestCase.InitialConditions = [P0 V0 O0];

    TestCase.PitchTable =  [0 0;
                            5 0;
                            5.001 5;
                            10 5;
                            10.001 0;
                            15 0];
    % Linear interpolation of Pitch Table
    TestCase.GetPitch = @(time) interp1(TestCase.PitchTable(:,1),TestCase.PitchTable(:,2),time,TestCase.PitchTable(end,2));

    TestCase.ThrottleTable = [0 0;
                              2 1;
                              15 1];
    % Linear interpolation of Throttle Table
    TestCase.GetThrottle = @(time) interp1(TestCase.ThrottleTable(:,1),TestCase.ThrottleTable(:,2),time,TestCase.ThrottleTable(end,2));
    TestCase.StopTime = 15;
  endif
  % Set up the master SimData data structure for the simulation
  % Simulation parameters
  SimData.dt = 0.05;                    % Step time (s)
  SimData.end_time = TestCase.StopTime; % Simulation end time (s)
  SimData.ground_height = 0;            % Height of the ground (m)
  SimData.Time = 0;                     % Simulation Time (s)
  
  % Test Case sub-structure
  SimData.TestCase = TestCase;
  
  % State vector initialization
  % Set the initial conditions to the Test Case initial conditions
  SimData.StateVector.Position    = [TestCase.InitialConditions(1), TestCase.InitialConditions(2)];
  SimData.StateVector.Velocity    = [TestCase.InitialConditions(3), TestCase.InitialConditions(4)];
  SimData.StateVector.Orientation = [TestCase.InitialConditions(5)];

  % Plane sub-structure
  SimData.Plane.Mass        = 1; % Mass (kg)
  SimData.Plane.AeroRefArea = 1; % Cross sectional area used for calculation of aerodynamic drag and lift (m2)
  flight_path_angle = atan2d(SimData.StateVector.Velocity(2), SimData.StateVector.Velocity(1));
  SimData.Plane.AoA = SimData.StateVector.Orientation(1) - flight_path_angle;
  SimData.Plane.Cl          = @(AoA) 2 * pi * deg2rad(AoA);           % Coefficient of lift function (dimensionless)
  SimData.Plane.Cd          = @(AoA) SimData.Plane.Cl(deg2rad(AoA))^2 + 0.05; % Coefficient of drag function (dimensionless)



  % Get initial state of the Plane
  SimData.Plane.FSM_state = 0; % Assume the plane is on the ground before update
  SimData.Plane.FSM_state = Get_FSM_State(SimData);
  
  % Results used for plotting
  Results.X     = SimData.StateVector.Position(1);
  Results.Y     = SimData.StateVector.Position(2);
  Results.Vx    = SimData.StateVector.Velocity(1);
  Results.Vy    = SimData.StateVector.Velocity(2);
  Results.Pitch = SimData.StateVector.Orientation(1);
  Results.AoA   = SimData.Plane.AoA;
  Results.Time  = 0;
  Results.FSM_state = SimData.Plane.FSM_state; #plane starts on the ground (state 0 = on the ground)
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %                        Simulation Start
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for i=2:(SimData.end_time / SimData.dt)

    % Integrate next step
    SimData = RK4_Integration(SimData);


    % Save Results
    Results.X(i)     = SimData.StateVector.Position(1);
    Results.Y(i)     = SimData.StateVector.Position(2);
    Results.Vx(i)    = SimData.StateVector.Velocity(1);
    Results.Vy(i)    = SimData.StateVector.Velocity(2);
    Results.Pitch(i) = SimData.StateVector.Orientation(1);
    Results.AoA(i)   = SimData.Plane.AoA;
    Results.Time(i)  = SimData.Time;
    Results.FSM_state(i) = SimData.Plane.FSM_state;

    % Check if object has crashed
    if SimData.Plane.FSM_state == 3
        disp('Ground hit in ', num2str(Results.Time(end)), ' s');
        disp('Plane Crashed');
        break;
    endif
  endfor
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %                        Simulation End
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
endfunction