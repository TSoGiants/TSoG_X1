function StateVector_Dot = Derivatives(StateVector)
  
  P_dot = StateVector(3:4);
  
  V_dot = [0 -9.81];
  
  StateVector_Dot = [P_dot V_dot];
  
endfunction