## Author: Aditya Ojha <Aditya Ojha@DESKTOP-CVU5H2C>
## Created: 2020-07-12
% States are enumerated as such:
% 0 = Crashed ==> when height is <= ground height
% 1 = Flying  ==> height is > ground height and v_x is positive
% 2 = Cruising ==> Still need to define

function next_state = get_FSM_state (state_vector,ground_height,last_state)
    if last_state == 0 %if the plane has crashed, it cannot fly anymore.
      next_state = 0;
    else
      %only check if we've crashed      
      height = state_vector(2);
      crashed =(height<=ground_height);
      v_x = state_vector(3);
      flying = (height>ground_height) && (v_x>0);
      if flying
        next_state = 1; %plane is flying
      elseif crashed
        next_state = 0; %plane has crashed
      endif
    endif
endfunction
