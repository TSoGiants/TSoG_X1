%% Template Test Case Setup
%
% This template will establish the framework for creating test cases

% Create a short name for the test case
TestCase.Name        = 'Template';

% Write a brief description of what the test case is testing
TestCase.Description = 'This test case is a template to edit and create new test cases';

% The pitch table will be linearly interpolated using the simulation time as the independent input
% The first column is time. (Should be monotonically increasing with no repeats)
% The second column is pitch angle in degrees
TestCase.PitchTable =  [0 0;
                        5 0;
                        5.001 5;
                        10 5;
                        10.001 0;
                        15 0];

% The throttle table will be linearly interpolated using the simulation time as the independent input
% The first column is time. (Should be monotonically increasing with no repeats)
% The second column is throttle percentage (1 is 100%)
TestCase.ThrottleTable = [0 0;
                          2 1;
                          15 1];
% Calculate the stop time of the test. Simply the largest last input time.
TestCase.StopTime = max([TestCase.ThrottleTable(end,1),TestCase.PitchTable(end,1)]);

%% Run the Test Case through the Aircraft Simulation

% PLACE HOLDER PLOTS UNTIL SIMULATION INPUT IS ADDED

time = 0:0.1:TestCase.StopTime;

for i=1:length(time)
  FlightInputs = ReadTestCase(time(i),TestCase);
  Pitch(i,1) = FlightInputs.Pitch;
  Throttle(i,1) = FlightInputs.Throttle;
endfor

figure(1)
plot(time,Pitch)
xlabel('Time (sec)')
ylabel('Pitch (deg)')

axis([0 max(time) 1.5*min(Pitch) 1.5*max(Pitch)])

figure(2)
plot(time,Throttle*100)
xlabel('Time (sec)')
ylabel('Throttle (%)')

axis([0 max(time) 0 100])