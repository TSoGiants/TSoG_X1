% 4th Order Runge-Kutta (RK4) integration
function StateVector = RK4_Integration(StateVector, Object, deltat)
  k1 = deltat * Derivatives(StateVector, Object);
  k2 = deltat * Derivatives(StateVector + k1/2, Object);
  k3 = deltat * Derivatives(StateVector + k2/2, Object);
  k4 = deltat * Derivatives(StateVector + k3, Object);
fdasdfsdfasdfasda
asdfasdfasd
fasdfasd
asdfZXCacADXCC
asdf

  StateVector = StateVector + (1/6) * (k1 + 2*k2 + 2*k3 + k4);
endfunction