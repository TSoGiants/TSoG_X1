% This function reads in a Test Case and the time from the State Vector and outputs
% the Flight Inputs

function [FlightInputs] = ReadTestCase(Time, TestCase)
  
  % Default Flight Inputs
  FlightInputs.Pitch = 0;
  FlightInputs.Throttle = 0;
  
  % Interpolate the TestCase Pitch Table for the pitch input
  PitchTableTime = TestCase.PitchTable(:,1);
  PitchTableValue = TestCase.PitchTable(:,2);
  FlightInputs.Pitch = interp1(PitchTableTime,PitchTableValue,Time);
  
  % Interpolate the TestCase Pitch Table for the pitch input
  ThrottleTableTime = TestCase.ThrottleTable(:,1);
  ThrottleTableValue = TestCase.ThrottleTable(:,2);
  FlightInputs.Throttle = interp1(ThrottleTableTime,ThrottleTableValue,Time);
  
  
endfunction