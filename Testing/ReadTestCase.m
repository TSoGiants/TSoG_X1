% This function reads in a Test Case and the time from the State Vector and outputs
% the Flight Inputs

function [FlightInputs] = ReadTestCase(Time, TestCase)
  
  % Default Flight Inputs
  FlightInputs.Pitch = 0;
  FlightInputs.Throttle = 0;
  
  % Interpolate the TestCase Pitch Table for the pitch input
  PitchTableX = TestCase.PitchTable(:,1);
  PitchTableY = TestCase.PitchTable(:,2);
  FlightInputs.Pitch = interp1(PitchTableX,PitchTableY,Time);
  
  % Interpolate the TestCase Pitch Table for the pitch input
  ThrottleTableX = TestCase.ThrottleTable(:,1);
  ThrottleTableY = TestCase.ThrottleTable(:,2);
  FlightInputs.Throttle = interp1(ThrottleTableX,ThrottleTableY,Time);
  
  
endfunction