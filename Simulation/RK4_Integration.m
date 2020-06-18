% 4th Order Runge-Kutta (RK4) integration
function StateVector = RK4_Integration(StateVector, dt)

  k1 = dt * Derivatives(StateVector);
  k2 = dt * Derivatives(StateVector + k1/2);
  k3 = dt * Derivatives(StateVector + k2/2);
  k4 = dt * Derivatives(StateVector + k3);

  StateVector = StateVector + (1/6) * (k1 + 2*k2 + 2*k3 + k4);

endfunction