% Based off of https://github.com/TSoGiants/MECH2103-Computational-Aerodynamics
%  TSoG_X1_Sim is the main function to run the X1 simulation. It can be run with
% or without an input Test Case and custom Plane structure. The simulation will 
% provide defaults for both of those if they're not supplied to the function.

function [ Results ] = TSoG_X1_Sim( TestCase, Plane )
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

    TestCase.ThrottleTable = [0 0;
                              2 1;
                              15 1];
    TestCase.StopTime = 15;
  endif

  if nargin ~= 2
    % Default plane sub-structure
    Plane.Mass        = 1; % Mass (kg)
    Plane.AeroRefArea = 1; % Cross sectional area used for calculation of aerodynamic drag and lift (m2)
    Plane.Cl          = @(AoA) 2 * pi * deg2rad(AoA);           % Coefficient of lift function (dimensionless)
    Plane.Cd          = @(AoA) Plane.Cl(deg2rad(AoA))^2 + 0.05; % Coefficient of drag function (dimensionless)
    
    % Battery Information
    Plane.MaxBatteryCap = 850; % mAh
    Plane.BatteryCap = Plane.MaxBatteryCap; % Current Battery Cap
  endif

  % Set up the master SimData data structure for the simulation
  % Simulation parameters
  SimData.dt = 0.05;                    % Step time (s)
  SimData.end_time = TestCase.StopTime; % Simulation end time (s)
  SimData.ground_height = 0;            % Height of the ground (m)
  SimData.Time = 0;                     % Simulation Time (s)
  
  % Test Case sub-structure
  SimData.TestCase = TestCase;
  % Linear interpolation of Pitch Table
  SimData.TestCase.GetPitch = @(time) interp1(TestCase.PitchTable(:,1),TestCase.PitchTable(:,2),time,TestCase.PitchTable(end,2));
  % Linear interpolation of Throttle Table
  SimData.TestCase.GetThrottle = @(time) interp1(TestCase.ThrottleTable(:,1),TestCase.ThrottleTable(:,2),time,TestCase.ThrottleTable(end,2));

  % State vector initialization
  % Set the initial conditions to the Test Case initial conditions
  SimData.StateVector.Position    = [TestCase.InitialConditions(1), TestCase.InitialConditions(2)];
  SimData.StateVector.Velocity    = [TestCase.InitialConditions(3), TestCase.InitialConditions(4)];
  SimData.StateVector.Orientation = [TestCase.InitialConditions(5)];

  % Plane sub-structure 
  flight_path_angle = atan2d(SimData.StateVector.Velocity(2), SimData.StateVector.Velocity(1));
  Plane.AoA         = SimData.StateVector.Orientation(1) - flight_path_angle;

  SimData.Plane = Plane;
  
  % Get initial state of the Plane
  SimData.Plane.FSM_state = FSMStates.OnGround; % Assume the plane is on the ground before update
  SimData.Plane.FSM_state = GetFSMState(SimData);

  % Results used for plotting
  Results.X     = SimData.StateVector.Position(1);
  Results.Y     = SimData.StateVector.Position(2);
  Results.Vx    = SimData.StateVector.Velocity(1);
  Results.Vy    = SimData.StateVector.Velocity(2);
  Results.Pitch = SimData.StateVector.Orientation(1);
  Results.AoA   = SimData.Plane.AoA;
  Results.Time  = 0;
  Results.FSM_state     = SimData.Plane.FSM_state; % plane starts on the ground (state 0 = on the ground)
  Results.PitchInput    = SimData.TestCase.GetPitch(SimData.Time);
  Results.ThrottleInput = SimData.TestCase.GetThrottle(SimData.Time);
  Results.BatteryCap    = SimData.Plane.BatteryCap;
  Results.MaxBatteryCap = SimData.Plane.MaxBatteryCap;

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
    Results.FSM_state(i)     = SimData.Plane.FSM_state;
    Results.PitchInput(i)    = SimData.TestCase.GetPitch(SimData.Time);
    Results.ThrottleInput(i) = SimData.TestCase.GetThrottle(SimData.Time);
    
    % updates on battery for the next iteration
    Results.BatteryCap(i)    = SimData.Plane.BatteryCap;
    Results.MaxBatteryCap(i) = SimData.Plane.MaxBatteryCap;
    
    % Check if object has crashed
    if SimData.Plane.FSM_state == FSMStates.Crashed
        disp('Ground hit in ', num2str(Results.Time(end)), ' s');
        disp('Plane Crashed');
        break;
    endif
  endfor
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %                        Simulation End
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
endfunction
