## Author: Aditya Ojha <Aditya Ojha@DESKTOP-CVU5H2C>
## Created: 2020-07-12

function [flying,crashed] = get_FSM_state (state_vector,ground_height)
    height = state_vector(2);
    v_x = state_vector(3);
    flying = (height>ground_height) && (v_x>0);
    crashed =(height<=ground_height);
endfunction
