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
    %   Inputs:
    %     Name = Name of Vehicle
    %     init_stateVector = Initial State of Vehicle
    %     N_Ctrls = Number of Control Inputs
    %     modelArray = Array of Models that affect the Vehicle
    function Vh = Vehicle(Name,init_stateVector,N_Ctrls,modelArray)
      if init_stateVector(Vh.SV_Index.M) <= 0
        error('Mass property of State Vector cannot be less than or equal to 0')
      endif
      Vh.Name = Name;
      Vh.stateVector = init_stateVector;
      Vh.controlsVector = zeros(N_Ctrls,1);
      Vh.modelArray = modelArray;
    endfunction

    % Method to add a Model to the modelArray
    function Vh = addModel(Vh,model)
      Vh.modelArray{end+1} = model;
    endfunction
    
    % Method to get stateVector or its components
    function Data = getStateVector(Vh,SV_Index)
      % SV_Index must be an integer or integer array
      % Highly recommended to use the StateVector_Index enumeration class to get
      % consistently correct data from the stateVector
      if nargin == 1
        % If no SV_Index is provided, output the whole stateVector
        Data = Vh.stateVector;
      elseif nargin == 2
        % If SV_Index is provided, output the desired components
        Data = Vh.stateVector(SV_Index);
      else
        error('Too Many Arguments for Method')
      endif      
    endfunction
    
    % Method to get controlsVector or its components
    function Data = getControlsVector(Vh,CV_Index)
      % Index must be an integer or integer array
      if nargin == 1
        % If no Index is provided, output the whole controlsVector
        Data = Vh.controlsVector;
      elseif nargin == 2
        % If Index is provided, output the desired components
        Data = Vh.controlsVector(CV_Index);
      else
        error('Too Many Arguments for Method')
      endif      
    endfunction

    % Method to set the stateVector which checks to make sure the size matches
    function Vh = setStateVector(Vh,stateVector_NEW)
      if size_equal(Vh.stateVector,stateVector_NEW)
        Vh.stateVector = stateVector_NEW;
      else
        error(['Size of stateVector does not match size of ' Vh.Name '''s stateVector'])
      endif
    endfunction

    % Method to set the controlsVector which checks to make sure the size matches
    function Vh = setControlsVector(Vh,controlsVector_NEW)
      if size_equal(Vh.controlsVector,controlsVector_NEW)
        Vh.controlsVector = controlsVector_NEW;
      else
        error(['Size of controlsVector does not match size of ' Vh.Name '''s controlsVector'])
      endif
    endfunction
    
    % Method to get the Derivatives of the models with optional input stateVector or controlsVector
    % NOTE: All model's outputs must be the same size
    function Dervs = getDerivatives(Vh,stateVector = Vh.stateVector,controlsVector = Vh.controlsVector)
      Dervs = zeros(length(stateVector),1);
      Dervs(Vh.SV_Index.P) = stateVector(Vh.SV_Index.V);
      for i = 1:length(Vh.modelArray)
        model = Vh.modelArray{i};
        Dervs = Dervs + model(stateVector,controlsVector);
      endfor
    endfunction

  endmethods
endclassdef
