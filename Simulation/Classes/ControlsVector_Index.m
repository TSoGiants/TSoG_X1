%% Controls Vector Indices
% This is an enumeration of all Indices of a Vehicle Controls Vector

% Note: enumerations are currently not implemented in Octave
% (https://savannah.gnu.org/bugs/?44582) so constant properties are used instead.

classdef ControlsVector_Index
  properties (Constant)
    Throttle = 1 % Throttle percentage (0 to 1)
  end
end
