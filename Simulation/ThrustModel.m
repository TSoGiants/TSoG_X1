%Thrust Model

%This code represents how thrust is caclculated in the x and y directions
%Thrust is made up of "MaxThrust", "Throttle", and "airspeed"
%This function returns an array of Thrust in the x and y directions

function Thrust = ThrustModel(StateVector, Throttle)
  airspeed = sqrt(StateVector(3)^2 + StateVector(4)^2);
  MaxThrust = 100;
  Pitch = StateVector(5);
  Thrust = MaxThrust*Throttle*(1-airspeed/50);
  Thrust_x = Thrust*cosd(Pitch);
  Thrust_y = Thrust*sind(Pitch);
  Thrust = [Thrust_x,Thrust_y];
endfunction