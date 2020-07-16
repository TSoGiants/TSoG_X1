function [ Drag, Lift ] = AerodynamicModel(StateVector, Object)
  Altitude = StateVector(2);
  Velocity = StateVector(3:4);

  Speed = norm(Velocity); % Magnitude of velocity vector
  
  [_, _, air_density] = AtmosphereModel(Altitude);

  Q       = 0.5 * air_density * Speed^2;                    % Dynamic pressure
  Drag    = Object.AeroRefArea * Object.Cd(Object.AoA) * Q; % Drag force
  Lift    = Object.AeroRefArea * Object.Cl(Object.AoA) * Q; % Lift force

  if Speed == 0
    Drag_dir = [0, 0];
  else
    Drag_dir = -Velocity / Speed; % Drag direction = -normalized velocity vector
  endif

  Lift_dir = Drag_dir * [0 -sind(90); sind(90) 0]; % Lift direction = drag direction rotated 90 deg

  Drag *= Drag_dir;
  Lift *= Lift_dir;
endfunction