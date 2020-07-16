function StateVector_dot = Derivatives(StateVector, Object)
  Velocity = StateVector(3:4);

  Gravity = [0, -9.81]; % Acceleration due to gravity

  [Drag, Lift] = AerodynamicModel(StateVector, Object);

  F = Drag + Lift; % Net force on the object

  P_dot = Velocity;

  V_dot = Gravity + F / Object.Mass; % Derivative of velocity is acceleration

  O_dot = [0]; % TODO: Need to add proper math here (torque)

  StateVector_dot = [P_dot, V_dot, O_dot];
endfunction