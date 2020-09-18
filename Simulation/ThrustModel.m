%Thrust Model

%This code represents how thrust is caclculated in the x and y directions
%Thrust calculated from RPM and Airspeed. The equation used can be found here:
%https://www.electricrcaircraftguy.com/2014/04/propeller-static-dynamic-thrust-equation-background.html
%This function returns an array of Thrust in the x and y directions

function [Thrust, B_dot] = ThrustModel(SimData)
  %constants we get from propeller
  diameter = 6; % Inches
  pitch = 3; % Inches (how far forward propeller moves in one rotation)
  Kv = 2280; % RPM per volt

  Num_Cells = 3; % Number of battery cells. x meaning xS.
  Max_Volt  = 4.2 * Num_Cells; % Volts
  Min_Volt  = 3.2 * Num_Cells; % Volts
  Avg_Volt  = (Max_Volt + Min_Volt) / 2; % Volts
  Max_Current = 20; % Amps, estimated based on speed controller max (20 Amps)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Note that Kv*Max_Volt = Max Theoretical RPM.
  %To scale down this RPM, we will use the 'Throttle' input, which is a percentage
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  Throttle = SimData.TestCase.GetThrottle(SimData.Time);
  voltage = Avg_Volt*Throttle; % Voltage sent to the motor
  airspeed = norm(SimData.StateVector.Velocity);
  RPM = Kv*voltage;%RPM based on Kv and Voltage

  if SimData.Plane.BatteryCap == 0
    Thrust = 0;
  else
    Thrust = 4.392399*10^(-8)*RPM*diameter^(3.5)*pitch^(-.5)*((4.23333*10^(-4))*RPM*pitch-airspeed);%calculate thrust (based on model in excel file)
  endif

  % Calculations to update battery
  Power = Thrust * Avg_Volt * Max_Current; % Estimated power consumption assuming linear power usage based on Throttle
  if(voltage == 0)
    current = 0;
  else
    current = Power / (voltage); %in amps
  endif
  B_dot = -(current*1000)/3600; % Battery Drain (mAh/s)

  %Calculate X,Y directions
  Pitch = SimData.StateVector.Orientation; %this is an angle in degrees
  Thrust_x = Thrust*cosd(Pitch);
  Thrust_y = Thrust*sind(Pitch);

  %Return value
  Thrust = [Thrust_x,Thrust_y];

endfunction
