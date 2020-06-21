% Base off of https://github.com/TSoGiants/MECH2103-Computational-Aerodynamics

% Object parameters
Plane.Mass = 1;

% State vector initialization
% X - distance, Y - height
P0 = [0, 10]; % Initial position (m)
V0 = [-2, 0]; % Initial velocity (m/s)

StateVector = [P0 V0];

% Results used for plotting
Results.X  = StateVector(1);
Results.Y  = StateVector(2);
Results.Vx = StateVector(3);
Results.Vy = StateVector(4);
Results.Time = 0;

% Simulation parameters
dt = 0.05;         % Step time (s)
end_time = 10;     % Simulation end time(s)
ground_height = 0; % Height of the ground (m)

for i=2:(end_time / dt)  
  % Integrate next step
  StateVector = RK4_Integration(StateVector,dt);
  
  % Save Results
  Results.X(i)    = StateVector(1);
  Results.Y(i)    = StateVector(2);
  Results.Vx(i)   = StateVector(3);
  Results.Vy(i)   = StateVector(4);
  Results.Time(i) = dt * (i - 1);
  
  % Check if object has hit the ground
  if StateVector(2) < ground_height
    break;
  endif
endfor
plot(Results.X, Results.Y)
xlabel('X position (m)')
ylabel('Y position (m)')
set(legend('Trajectory'), "fontsize", 25)
set(gca, "fontsize", 25)
grid on
Save_Var_to_File(Results,"test1")