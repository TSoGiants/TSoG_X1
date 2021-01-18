classdef Vehicle
  properties(Access = protected)
    stateVector = [];
    controlsVector = [];
    modelArray = {};
  endproperties

  properties (Constant)
    SV_Index = StateVector_Index;
	endproperties

  properties(Access = public)
    Name = '';
  endproperties

  methods
    % Create Vehicle Object
    function Vh = Vehicle(Name,init_stateVector,N_Ctrls,modelArray)
      if (nargin != 4)
        error('Vehicle must have at least a Name and initial State Vector')
      else
        Vh.Name = Name;
        Vh.stateVector = init_stateVector;
        Vh.controlsVector = zeros(N_Ctrls,1);
        Vh.modelArray = modelArray;
      endif
    endfunction

    % Method to add a Model to the modelArray
    function Vh = addModel(Vh,model)
      Vh.modelArray{end+1} = model;
    endfunction

    % Get functions for the stateVector components
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

    % Method to set the stateVector which checks to make sure the size matches
    function Vh = setStateVector(Vh,stateVector_NEW)
      if size_equal(Vh.stateVector,stateVector_NEW)
        Vh.stateVector = stateVector_NEW
      else
        error(['Size of stateVector does not match size of ' Vh.Name '''s stateVector'])
      endif
    endfunction

    % Method to set the controlsVector which checks to make sure the size matches
    function Vh = setControlsVector(Vh,controlsVector_NEW)
      if size_equal(Vh.controlsVector,controlsVector_NEW)
        Vh.controlsVector = controlsVector_NEW
      else
        error(['Size of controlsVector does not match size of ' Vh.Name '''s controlsVector'])
      endif
    endfunction
%
    function Dervs = getDerivatives(Vh,stateVector = Vh.stateVector,controlsVector = Vh.controlsVector)
      Dervs = zeros(length(stateVector),1);
      for i = 1:length(Vh.modelArray)
        model = Vh.modelArray{i};
        Dervs = Dervs + model(stateVector,controlsVector);
      endfor
    endfunction

  endmethods
endclassdef
