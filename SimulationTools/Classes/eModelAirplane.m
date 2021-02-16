classdef eModelAirplane < Vehicle

  properties (Access = protected)
    AeroModel
    ThrustModel
    GravityModel
  endproperties



  methods
    % Create Electric Model Aircraft, a Vehicle subclass
    function eMdlA = eModelAirplane(Name,init_stateVector,N_Ctrls, AeroModel, ThrustModel, GravityModel)
      if not(size_equal(zeros(11,1),init_stateVector))
        error('Initial State Vector for an Electric Model Aircraft Vehicle subclass needs to be a 11x1 array')
      endif

      % Create a Vehicle class for this Subclass
      eMdlA@Vehicle(Name,init_stateVector,N_Ctrls);

      % Set the Aerodynamic Model of the Aircraft
      eMdlA.AeroModel = AeroModel;

      % Set the Electric Propeller Thrust Model of the Aircraft
      eMdlA.ThrustModel = ThrustModel;

      % Set the Gravity Model of the Aircraft
      eMdlA.GravityModel = GravityModel;

      eMdlA.modelArray = {AeroModel,ThrustModel,GravityModel};

    endfunction

    % Method to grab the Aerodynamic forces broken down into Lift and Drag
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

    % Method to grab the Aerodynamic forces broken down into Lift and Drag
    function [Lift,Drag] = getThrustForce(eMdlA,input_stateVector)
      Thrust = [0;0];
    endfunction

  endmethods
endclassdef
