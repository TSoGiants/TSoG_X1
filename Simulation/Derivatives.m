function StateVector_dot = Derivatives(kn, SimData)
    % Add k Deltas to the current SimData
    SimData.StateVector.Position    = SimData.StateVector.Position + kn.P_delta;
    SimData.StateVector.Velocity    = SimData.StateVector.Velocity + kn.V_delta;
    SimData.StateVector.Orientation = SimData.StateVector.Orientation + kn.O_delta;

    % Acceleration due to gravity

  Gravity = [0, -9.81];

  % Calculate Angle of Attack for Aerodynamic Model
  Pitch    = SimData.TestCase.GetPitch(kn.Time);

  flight_path_angle = atan2d(Velocity(2), Velocity(1));

  SimData.Plane.AoA = Pitch - flight_path_angle;

  [Drag, Lift] = AerodynamicModel(SimData);

  F = Drag + Lift; % Net force on the object

  kOut.P_dot = SimData.StateVector.Velocity;

  kOut.V_dot = Gravity + F / SimData.Plane.Mass; % Derivative of velocity is acceleration

  kOut.O_dot = [0]; % TODO: Need to add proper math here (torque)

endfunction
