## Author: Aditya Ojha <Aditya Ojha@DESKTOP-CVU5H2C>
## Created: 2020-07-12

function next_state = GetFSMState(SimData)
    height = SimData.StateVector.Position(2);
    v_x = SimData.StateVector.Velocity(1);
    v_y = SimData.StateVector.Velocity(2);

    ground_height = SimData.ground_height;
    last_state    = SimData.Plane.FSM_state;

    % State transition boolean variables
    flying    = (height > ground_height)  && (v_x > 0);
    crashed   = (height <= ground_height) && (v_y <= -5);
    on_ground = (height <= ground_height) && (v_y > -5);

    if last_state == FSMStates.Crashed
      % The plane cannot change states any more
      next_state = FSMStates.Crashed;

      return;
    endif

    if flying
      next_state = FSMStates.Flying;
    elseif crashed
      next_state = FSMStates.Crashed;
    else
      next_state = FSMStates.OnGround;
    endif
endfunction
