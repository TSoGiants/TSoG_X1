% Based off of https://github.com/TSoGiants/MECH2103-Computational-Aerodynamics

% Object parameters
Plane.Mass        = 1; % Mass (kg)
Plane.AeroRefArea = 1; % Cross sectional area used for calculation of aerodynamic drag and lift (m2)
Plane.Cd          = 1; % Coefficient of drag (dimensionless)
Plane.Cl          = 0; % Coefficient of lift (dimensionless)

printf('Terminal velocity: %d m/s\n', sqrt((2 * Plane.Mass * 9.81) / (Plane.Cd * 1.225 * Plane.AeroRefArea)));

% State vector initialization
% X - distance, Y - height
P0 = [0, 10]; % Initial position (m)
V0 = [0, 0]; % Initial velocity (m/s)

StateVector = [P0, V0];

% Results used for plotting
Results.X    = StateVector(1);
Results.Y    = StateVector(2);
Results.Vx   = StateVector(3);
Results.Vy   = StateVector(4);
Results.Time = 0;

% Simulation parameters
dt = 0.05;         % Step time (s)
end_time = 10;     % Simulation end time (s)
ground_height = 0; % Height of the ground (m)

for i=2:(end_time / dt)
  % Integrate next step
  StateVector = RK4_Integration(StateVector, Plane, dt);
  
  % Save Results
  Results.X(i)    = StateVector(1);
  Results.Y(i)    = StateVector(2);
  Results.Vx(i)   = StateVector(3);
  Results.Vy(i)   = StateVector(4);
  Results.Time(i) = dt * (i - 1);
  
  % Check if object has hit the ground
  if StateVector(2) < ground_height
    printf('Ground hit in %d s\n', Results.Time(end))
    break;
  endif
endfor

plot(Results.Time, Results.Y)
hold on
plot(Results.Time, Results.Vy)
xlabel('Time (s)')
%ylabel('Y position (m)')
set(legend('Trajectory (m)', 'Velocity (m/s)'), "fontsize", 25)
set(gca, "fontsize", 25)
grid on