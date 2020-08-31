%% FSM States
% This is an enumeration of all states used by the FSM (finite state machine).

% Note: enumerations are currently not implemented in Octave 
% (https://savannah.gnu.org/bugs/?44582) so constant properties are used instead. 

classdef FSMStates
	properties (Constant)
		OnGround = 0
		Flying = 1
		Cruising = 2
		Crashed = 3
	end
end