function Gen_GravityModel = GravityModel_Generator(Magnitude,Direction)

  Gen_GravityModel = @GravityModel;

  function Dervs = GravityModel(stateVector,controlsVector)
    SV_Index = StateVector_Index;
    Dervs = zeros(11,1);
    Dervs(SV_Index.V) = Magnitude*Direction;
  endfunction
endfunction
