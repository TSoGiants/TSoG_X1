function StateVector_Dot = Derivatives(StateVector, Object)
  Velocity = P_dot = StateVector(3:4); % Derivative of position is velocity
  Speed    = norm(Velocity);           % Magnitude of velocity vector

  Gravity = [0, -9.81]; % Acceleration due to gravity

  Density = 1.225;                              % Standard air density (kg/m3)
  Q       = 0.5 * Density * Speed^2;            % Dynamic pressure
  Drag    = Object.AeroRefArea * Object.Cd * Q; % Drag force
  Lift    = Object.AeroRefArea * Object.Cl * Q; % Lift force
  
  if Speed == 0
    Drag_dir = [0, 0];
  else
    Drag_dir = -Velocity / Speed; % Drag direction - normalized velocity vector
  endif
  
  Lift_dir = Drag_dir * [0 -1; 1 0];
  
  F = Drag_dir * Drag + Lift_dir * Lift; % Net force on the object
 
  V_dot = Gravity + F / Object.Mass; % Derivative of velocity is acceleration

  Orientation_dot = [0]; % TODO: Need to add proper math here (torque)
  
  StateVector_Dot = [P_dot, V_dot, Orientation_dot];
endfunction