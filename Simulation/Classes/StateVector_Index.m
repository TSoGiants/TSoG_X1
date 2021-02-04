%% State Vector Indices
% This is an enumeration of all Indices of a Vehicle State Vector

% Note: enumerations are currently not implemented in Octave
% (https://savannah.gnu.org/bugs/?44582) so constant properties are used instead.

classdef StateVector_Index
  properties (Constant)
    P_X = 1 % Position, X
    P_Y = 2 % Position, Y
    P_Z = 3 % Position, Z
    P   = [1,2,3] % Position, Vector [X,Y,Z]
    V_X = 4 % Velocity, X
    V_Y = 5 % Velocity, X
    V_Z = 6 % Velocity, X
    V   = [4,5,6] % Velocity, Vector [X,Y,Z]
    O_P = 7 % Orientation, Pitch
    O_R = 8 % Orientation, Roll
    O_Y = 9 % Orientation, Yaw
    O   = [7,8,9] % Orientation, Vector [Pitch,Roll,Yaw]
    M   = 10 % Mass
    B_Cap = 11 % Battery Capacity
  end
end
