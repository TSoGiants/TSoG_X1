%Thrust Model

%This code represents how thrust is caclculated in the x and y directions
%Thrust calculated from RPM and Airspeed. The equation used can be found here:
%https://www.electricrcaircraftguy.com/2014/04/propeller-static-dynamic-thrust-equation-background.html
%This function returns an array of Thrust in the x and y directions

function Thrust = ThrustModel(SimData)
  %constants we get from propeller 
  diameter = 6; %inches
  pitch = 3; %inches (how far forward propeller moves in one rotation
  Kv = 2280; %RPM per volt
  Max_Volt = 11.1; %volts
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Note that Kv*Max_Volt = Max Theoretical RPM.
  %To scale down this RPM, we will use the 'Throttle' input, which is a percentage
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  %calculated values
  airspeed = norm(SimData.StateVector.Velocity);
  Throttle = SimData.TestCase.GetThrottle(SimData.Time);
  RPM = Max_Volt*Kv*Throttle;%use Throttle to scale down the max RPM 
  Thrust = 4.392399*10^(-8)*RPM*diameter^(3.5)*pitch^(-.5)*((4.23333*10^(-4))*RPM*pitch-airspeed);%calculate thrust (based on model in excel file)
  
  %Battery Calculations
  [Drag,Lift] = AerodynamicModel(SimData)
  Pitch = SimData.TestCase.GetPitch(SimData.Time); %this is an angle in degrees
  aoa = SimData.Prop.AoA;
  Torque = Drag*cosd(aoa) + Lift*cosd(90-aoa);
  current = RPM* Torque / Max_Volt
  current_dt = current * SimData.Time/3600 %in mA * hours
  %now I need to get the current current
  
  
  %Calculate X,Y directions
  Pitch = SimData.TestCase.GetPitch(SimData.Time); %this is an angle in degrees
  Thrust_x = Thrust*cosd(Pitch);
  Thrust_y = Thrust*sind(Pitch);
  %Return value
  Thrust = [Thrust_x,Thrust_y];
endfunction