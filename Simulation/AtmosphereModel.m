% Atmosphere model 

% This code represents how we can approximate the temperature (degrees Celsius),
% pressure (kPa), and density (kg / m ^ 3) as a function of height/altitude (meters).
% Based off the NASA atmospheric model, the atmosphere that planes travel in can be 
% broken up into three sections: troposphere, lower stratosphere, and upper stratosphere.
% For the reality of this RC plane, we will only work on the model regarding the
% troposphere constants. In the troposphere, temperature decreases linearly, while 
% pressure decreases exponentially, and density is based off the values of 
% temperature and pressure.

% Atmosphere model is sourced from NASA at this link:
% https://www.grc.nasa.gov/WWW/K-12/airplane/atmosmet.html

function [Temperature, Pressure, Density] = AtmosphereModel(Alt)
  
  % Calculate temp, based on altitude
  Temperature = 15.04 - .00649 * Alt;
  
  % Calculate pressure, based on altitude
  Pressure = 101.29 * ((Temperature + 273.1) / 288.08) ^ 5.256;
  
  % Calculate density, based on altitude 
  Density = Pressure / (.2869 * (Temperature + 273.1));
  
endfunction
