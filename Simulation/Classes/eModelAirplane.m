classdef eModelAirplane < Vehicle
  
  properties
    AeroModel
    ThrustModel
  endproperties
  
  methods
    % Create Electric Model Aircraft, a Vehicle subclass
    function eMdlA = eModelAirplane(Name,init_stateVector)
      if not(size_equal(zeros(11,1),init_stateVector))
        error('Initial State Vector for an Electric Model Aircraft Vehicle subclass needs to be a 11x1 array')
      endif
      
      eMdlA@Vehicle(Name,init_stateVector);
      
    endfunction
    
    function setAeroModel(eMdlA,CL_Delegate,CD_Delegate,RefSurfArea)
      AeroModel = AeroModel_Generator(CL_Delegate,CD_Delegate,RefSurfArea);
      eMdlA.AeroModel = AeroModel;
    endfunction
    
    function [Lift,Drag] = getAeroForces(eMdlA,input_stateVector)
      stateVector = [];
      if nargin > 1
        stateVector = input_stateVector;
      else
        stateVector = eMdlA.stateVector;
      endif
      Velocity = stateVector([eMdlA.SV_Index.V_X,eMdlA.SV_Index.V_Y]);
      Orientation = stateVector(eMdlA.SV_Index.O);
      Altitude = stateVector(eMdlA.SV_Index.P_Y);
      [Lift, Drag] = eMdlA.AeroModel(Velocity, Orientation, Altitude);      
    endfunction
    
    function setThrustModel(eMldA,ThrustModel)
      eMdlA.ThrustModel = ThrustModel;
    endfunction
  endmethods
endclassdef
