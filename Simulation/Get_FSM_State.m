## Author: Aditya Ojha <Aditya Ojha@DESKTOP-CVU5H2C>
## Created: 2020-07-12
% States are enumerated as such:
% 0 = On the ground safely ==> just the initial state.
%     when height is <= ground height and the vertical velocity is more than -5m/s
% 1 = Flying  ==> height is > ground height and v_x is positive
% 2 = Cruising ==> Still need to define
% 3 = Crashed ==> when height is <= ground height and the vertical speed was less than -5m/s

function next_state = Get_FSM_State (state_vector,ground_height,last_state)
    height = state_vector(2);
    v_x = state_vector(3);
    v_y = state_vector(4);
    
    %state transition boolean variables
    flying = (height > ground_height) && (v_x > 0);
    crashed = (height <= ground_height) && (v_y <= -5);
    on_ground = (height <= ground_height) && (v_y > -5);
    
    %FSM state transition code
    if last_state == 0 %if the plane is on the ground
      %check if the plane is flying then if its crashed
      if flying
        next_state = 1;
      elseif crashed
        next_state = 3;
      else
        next_state = 0;
      endif
    elseif last_state == 1 %if the plane is flying
      %check if the plane has crashed
      if crashed
        next_state = 3;
      elseif on_ground
        next_state = 0;
      else
        next_state = 1;
      endif
    elseif last_state == 3 %if the plane has crashed
      %the plane cannot change states;
      last_state = 3
    endif
endfunction
