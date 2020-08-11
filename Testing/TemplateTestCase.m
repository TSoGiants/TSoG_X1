%% Template Test Case Setup
%
% This template will establish the framework for creating test cases

% Run the startup file to set up the `path`
run('./startup.m');

% Create a short name for the test case
TestCase.Name        = 'Template';

% Write a brief description of what the test case is testing
TestCase.Description = 'This test case is a template to edit and create new test cases';

% Establish Initial Conditions of the test
% X - left/right, Y - up/down
P0 = [0, 10]; % Initial position [X, Y] (m)
V0 = [-2, 0]; % Initial velocity [Vx, Vy](m/s)
O0 = [0];     % Initial Orientation [Pitch] (degrees)

StateVector_Initial = [P0 V0 O0];
TestCase.InitialConditions = StateVector_Initial;

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
Results = TSoG_X1_Sim(TestCase);

StandardPlots(Results)

% PLACE HOLDER PLOTS UNTIL SIMULATION INPUT IS ADDED

figure(2)
plot(Results.Time,Results.PitchInput)
xlabel('Time (sec)')
ylabel('Pitch (deg)')

axis([0 max(time) 1.5*min(Results.PitchInput) 1.5*max(Results.PitchInput)])

figure(3)
plot(Results.Time,Results.ThrottleInput*100)
xlabel('Time (sec)')
ylabel('Throttle (%)')

axis([0 max(time) -10 110])
