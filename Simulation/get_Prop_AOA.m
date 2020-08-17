## Author: Aditya Ojha <Aditya Ojha@DESKTOP-CVU5H2C>
## Created: 2020-08-17
#Function Name: get_Prop_AOA
#Inputs: SimData
#Outputs: The angle of attack of the propeller

function AoA = get_Prop_AOA (SimData)
  
  Pitch = SimData.TestCase.GetPitch(SimData.Time);# in degrees
  Airspeed = norm(SimData.StateVector.Velocity);
  Throttle = SimData.TestCase.GetThrottle(SimData.Time);
  RPM = SimData.Prop.RPM(Throttle);
  if RPM == 0: #if the prop is not rotating, then the angle of attack is zero
    AoA = 0;
  Diameter = SimData.Prop.Diameter*0.0254; #in inches
  Rotational_Speed = RPM*Diameter/2; #we assume that using the speed at 1/2 the diameter is a good approximation
  #The pitch minus that angle of the next airspeed vector (arctan(airspeed/rotating speed of the propellor) is AoA 
  AoA = Pitch - atand(Airspeed/Rotational_Speed);
endfunction
