function [Gen_LinearBatteryModel] = LinearBatteryModel_Generator(MinVoltage, MaxVoltage, MaxCapacity)
  % This function generates a function delegate using the input parameters for a Linear Battery
  % Model meaning that voltage is directly proportional to the remaining capacity.
  % The model calculates the voltage by linearly interpolating it between Min and Max voltage based
  % on the provided Capacity.
  %
  % Parameters:
  %     MinVoltage  - Minimum voltage of the battery at the lowest (safe) capacity (V)
  %     MaxVoltage  - Maximum voltage of the battery at full capacity (V)
  %     MaxCapacity - Maximum capacity at the battery (Ah)
  %
  % Example:
  %     PlaneBattery = BatteryModel_Generator(MaxVoltage, MinVoltage, Capacity);
  %     ThrustModel = ElectricPropellerModel_Generator(..., PlaneBattery);
  %     ServoModel  = ServoModel_Generator(..., PlaneBattery);


  Gen_LinearBatteryModel = @LinearBatteryModel;

  function Voltage = LinearBatteryModel(Capacity)
    SV_Index = StateVector_Index;

    Voltage = interp1([0, MaxCapacity], [MinVoltage, MaxVoltage], Capacity);
  endfunction
endfunction