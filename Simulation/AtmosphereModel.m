% Atmosphere model 
% <EXPAND ON WHAT THE CODE IS DOING HERE> 

% atmosphere model is sourced from NASA at this link:
% https://www.grc.nasa.gov/WWW/K-12/airplane/atmosmet.html

% Create input altitude

function [Temperature, Pressure, Density] = AtmosphereModel(Alt)
  
  % Calculate temp, based on altitude
  Temperature = 15.04 - .00649 * Alt;
  
  % Calculate pressure, based on altitude
  Pressure = 101.29 * ((Temperature + 273.1) / 288.08) ^ 5.256;
  
  % Calculate density, based on altitude 
  Density = Pressure / (.2869 * (Temperature + 273.1));
  
endfunction
