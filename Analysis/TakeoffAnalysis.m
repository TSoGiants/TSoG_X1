% This is an analysis script used for calculating plane's takeoff (rotation)
% speed and takeoff distance. Takeoff distance is used for checking which 
% runways we can take off based on their length.

% Rotation speed (Vr) is defined as the speed at which the wings are generating 
% lift equal to the planes weight.

g = 9.81;

% Plane structure used for the analysis
Plane.Mass        = 0.3;  % Mass (kg)
Plane.AeroRefArea = 0.05; % Cross sectional area used for calculation of aerodynamic drag and lift (m2)
Plane.Cl          = @(AoA) 2 * pi * deg2rad(AoA);           % Coefficient of lift function (dimensionless)
Plane.Cd          = @(AoA) Plane.Cl(deg2rad(AoA))^2 + 0.05; % Coefficient of drag function (dimensionless)
Plane.AoA         = 0; % Angle of Attack (degrees)

Plane.MaxBatteryCap = 850;                 % Total battery capacity (mAh)
Plane.BatteryCap    = Plane.MaxBatteryCap; % Current battery capacity (mAh)

end_time = 25; % End time of the simulation (seconds). Change this if the plane doesn't take off in time.

[_, _, air_density] = AtmosphereModel(0);

RotationAoA = 15;
RotationSpeed = sqrt((Plane.Mass * g) / (Plane.AeroRefArea * Plane.Cl(RotationAoA) * 0.5 * air_density));

printf('Analytical rotation speed: %.2f m/s (%.2f km/h)\n', RotationSpeed, RotationSpeed * 3.6);

% Establish Initial Conditions of the analysis
P0 = [0, 0]; % Initial position [X, Y] (m)
V0 = [0, 0]; % Initial velocity [Vx, Vy] (m/s)
O0 = [0];    % Initial Orientation [Pitch] (degrees)

StateVector_Initial = [P0 V0 O0];
TestCase.InitialConditions = StateVector_Initial;

% Time (seconds) vs Pitch (degrees)
TestCase.PitchTable =  [       0 0;
                        end_time 0];

% Time (seconds) vs Throttle (percentage)
TestCase.ThrottleTable = [       0 1;
                          end_time 1];

% Calculate the stop time of the test. Simply the largest last input time.
TestCase.StopTime = max([TestCase.ThrottleTable(end, 1), TestCase.PitchTable(end, 1)]);

%% Run the Test Case through the Aircraft Simulation
Results = TSoG_X1_Sim(TestCase, Plane);

speed_reached = false;

for i = 1:length(Results.Vy)
  if Results.Vx(i) >= RotationSpeed
    printf('Minimum takeoff distance is %.2f m (in %.2f s)\n', Results.X(i), Results.Time(i));
    speed_reached = true;

    break;
  endif
endfor

if !speed_reached
  printf('Plane didn''t reach the rotation speed during this simulation. You either have to change some Plane parameters or make the simulation longer.\n');
endif

StandardPlots(Results);