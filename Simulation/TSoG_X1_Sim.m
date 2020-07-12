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
    TestCase.ThrottleTable = [0 0;
                              2 1;
                              15 1];
    TestCase.StopTime = 15;
  endif

  % Object parameters
  Plane.Mass        = 1; % Mass (kg)
  Plane.AeroRefArea = 1; % Cross sectional area used for calculation of aerodynamic drag and lift (m2)
  Plane.Cd          = 1; % Coefficient of drag (dimensionless)
  Plane.Cl          = 0; % Coefficient of lift (dimensionless)
  Plane.AoA         = 0; % Angle of Attack (degrees)

  printf('Terminal velocity: %d m/s\n',
        sqrt((2 * Plane.Mass * 9.81) / (Plane.Cd * 1.225 * Plane.AeroRefArea)));

  % State vector initialization
  % Set the initial conditions to the Test Case initial conditions

  StateVector = TestCase.InitialConditions;

  % Results used for plotting
  Results.X     = StateVector(1);
  Results.Y     = StateVector(2);
  Results.Vx    = StateVector(3);
  Results.Vy    = StateVector(4);
  Results.Pitch = StateVector(5);
  Results.AoA   = Plane.AoA;
  Results.Time  = 0;

  % Simulation parameters
  dt = 0.05;                    % Step time (s)
  end_time = TestCase.StopTime; % Simulation end time (s)
  ground_height = 0;            % Height of the ground (m)
  current_FSM_state = 1;        % Assume plane starts off flying

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %                        Simulation Start
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for i=2:(end_time / dt)
    % Read and Set Flight Inputs from Test Case
    FlightInputs = ReadTestCase(Results.Time(i-1),TestCase);
    StateVector(5) = FlightInputs.Pitch;
    % NOTE: Throttle has no use yet

    % Integrate next step
    StateVector = RK4_Integration(StateVector, Plane, dt);

    Velocity = StateVector(3:4);
    Pitch    = StateVector(5);

    flight_path_angle = atan2d(Velocity(2), Velocity(1));

    Plane.AoA = Pitch - flight_path_angle;

    % Save Results
    Results.X(i)     = StateVector(1);
    Results.Y(i)     = StateVector(2);
    Results.Vx(i)    = StateVector(3);
    Results.Vy(i)    = StateVector(4);
    Results.Pitch(i) = StateVector(5);
    Results.AoA(i)   = Plane.AoA;
    Results.Time(i)  = dt * (i - 1);

    % Check if object has hit the ground
    current_FSM_state = get_FSM_state(StateVector,ground_height,current_FSM_state);
    if current_FSM_state == 0
      printf('Ground hit in %d s\n', Results.Time(end))
      break;
    endif
  endfor
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %                        Simulation End
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Hack that helps with graph scaling
  figure(1, 'position', [0, 0, 1920, 1000]);

  set(groot, 'DefaultLineLineWidth', 5);

  plot(Results.Time, Results.Y);
  hold on;
  plot(Results.Time, Results.Vy);
  hold on;
  plot(Results.Time, Results.AoA);

  xlabel('Time (s)');

  l = legend('Position Y (m)', 'Velocity Y (m/s)', 'AoA (deg)');
  set(l, 'FontSize', 25);
  set(gca, 'FontSize', 25);

  grid on;
endfunction
