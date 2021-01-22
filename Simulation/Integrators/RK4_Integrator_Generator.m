function Gen_RK4_Integrator = RK4_Integrator_Generator(dt)
  
  Gen_RK4_Integrator = @RK4_Integration;
  
  % 4th Order Runge-Kutta (RK4) integration
  function next_state = RK4_Integration(Vh,stateVector = Vh.getStateVector(),controlsVector = Vh.getControlsVector)
    % Calculate the k1 delta
    k1 = Vh.getDerivatives(stateVector,controlsVector);
    
    % Calculate the k2 delta
    k2 = Vh.getDerivatives(stateVector + dt*k1/2,controlsVector);
    
    % Calculate the k3 delta
    k3 = Vh.getDerivatives(stateVector + dt*k2/2,controlsVector);
    
    % Calculate the k4 delta
    k4 = Vh.getDerivatives(stateVector + dt*k3,controlsVector);
    
    % The next state will be the weighted average of the 4 calculated deltas
    next_state = stateVector + (1/6)*dt*(k1 + 2*k2 + 2*k3 + k4);
  endfunction
  
endfunction