classdef Vehicle
  properties(Access = protected)
    stateVector = [];
  endproperties
  
  properties (Constant)
    SV_Index = StateVector_Index;
	endproperties
  
  properties(Access = public)
    Name = '';
  endproperties
  
  methods
    % Create Vehicle Object
    function Vh = Vehicle(Name,init_stateVector)
      if (nargin != 2)
        error('Vehicle must have at least a Name and initial State Vector')
      else
        Vh.Name = Name;
        Vh.stateVector = init_stateVector;
      endif
    endfunction
    
    % 
    function P = getPosition(Vh)
      P = Vh.stateVector(Vh.SV_Index.P);
    endfunction
    
    function V = getVelocity(Vh)
      V = Vh.stateVector(Vh.SV_Index.V);
    endfunction
    
    function M = getMass(Vh)
      M = Vh.stateVector(Vh.SV_Index.M);
    endfunction
    
    function SV = getStateVector(Vh)
      SV = Vh.stateVector;
    endfunction
    
    function setStateVector(Vh,stateVector_NEW)
      if size_equal(Vh.stateVector,stateVector_NEW)
        Vh.stateVector = stateVector_NEW
      else
        error(['Size of stateVector does not match size of ' Vh.Name '''s stateVector'])
      endif
    endfunction
    
  endmethods
endclassdef
