function [Gen_ElectricPropellerModel] = ElectricPropellerModel_Generator(BladeDiameter, BladePitch, MotorKv, MaxCurrent, BatteryModel)
  % This function generates a function delegate using the input parameters for
  % an Electrically-powered Propeller Thrust Model. The model calculates the thrust force in X and Y directions
  % and applies it to the derivatives vector as an acceleartion.
  %
  % Parameters:
  %     BladeDiameter - Diameter of the propeller blade (inches)
  %     BladePitch    - Pitch of the propeller blade (inches)
  %     MotorKv       - Kv rating (velocity constant) of the motor (RPM/V)
  %     MaxCurrent    - Maximum current consumed by the motor (A)
  %     BatteryModel  - Battery model delegate used to calculate the current battery voltage supplied
  %                     to the motor (Delegate that accepts battery capacity in Ah and returns voltage in V)
  %
  % Example:
  %     PlaneBattery = BatteryModel_Generator(MaxVoltage, MinVoltage, Capacity);
  %     ThrustModel  = ElectricPropellerModel_Generator(..., PlaneBattery);


  Gen_ElectricPropellerModel = @ElectricPropellerModel;

  function [Dervs] = ElectricPropellerModel(stateVector, controlsVector)
    SV_Index = StateVector_Index;
    CV_Index = ControlsVector_Index;
    Dervs = zeros(11, 1);

    throttle = controlsVector(CV_Index.Throttle);
    voltage = BatteryModel(stateVector) * throttle;
    airspeed = norm(stateVector(SV_Index.V));
    RPM = MotorKv * voltage;

    if stateVector(SV_Index.B_Cap) == 0
      thrust = 0;
    else
      inch_to_m = 0.0254;
      min_to_sec = 1 / 60;

      % Thrust calculation based on the following model (Expanded Form): https://www.flitetest.com/articles/propeller-static-dynamic-thrust-calculation
      density = AtmosphereModel(stateVector(SV_Index.P_Y));
      propeller_cross_section = pi * (inch_to_m * BladeDiameter / 2) ** 2;
      static_thrust_term = (RPM * min_to_sec * inch_to_m * BladePitch) ** 2;
      dynamic_thrust_term = (RPM * min_to_sec * inch_to_m * BladePitch) * airspeed;
      empirical_correction_term = (BladeDiameter / (3.29546 * BladePitch)) ** 1.5;

      thrust = density * propeller_cross_section * (static_thrust_term - dynamic_thrust_term) * empirical_correction_term;
    endif

    power = throttle * voltage * MaxCurrent; % Estimated power consumption assuming linear power usage based on Throttle

    if voltage == 0
      current = 0;
    else
      current = power / voltage;
    endif

    B_dot = -(current / 3600); % Battery Drain (Ah/s)

    pitch = stateVector(SV_Index.O_P);
    thrust_x = thrust * cosd(pitch);
    thrust_y = thrust * sind(pitch);

    Dervs(SV_Index.V) = [thrust_x, thrust_y] / stateVector(SV_Index.M);
    Dervs(SV_Index.B_Cap) = B_dot;
  endfunction
endfunction
