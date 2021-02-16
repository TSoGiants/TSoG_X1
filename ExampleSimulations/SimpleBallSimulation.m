%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%               Simple Ball Simulation under Constant Gravity                  %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Description: This simulation script is an example of how to construct a model
% of a ball in a constant gravity field, with no air resistance. The steps walk
% you through how to set the balls initial state (position and velocity), add
% the gravity model, and finally simulate the ball©s trajectory until it hits
% the ground.
%
% The ball©s model will be created using the ©Vehicle© class (found in the
% Simulation/Classes directory).

% In order to get access to the Simulation Tools and Models we need to set up
% our path to include the files
%
% The startup.m script will do this for us
startup;

% First step is to set the name of the ball

Name = "Simple Ball";

%% State Vector Initialization
%
% Next is to set the initial state of the ball
% This is done by creating a State Vector, which is a column array/vector that
% contains the properties of a the ball that are tracked throughout the
% simulation. For this example we will be dealing with only the Position and
% Velocity of the ball.

% In order to set up the State Vector, we will need to use the StateVector_Index
% class. This contains easily accessible indesies for the states in the State
% Vector. (Saves us from having to memorize the order of the states)
SV_I = StateVector_Index;

% We can create a blank State Vector by creating a column vector of zeros
init_stateVector = zeros(SV_I.numStates,1);

% Using the SV_I variable, we will set the states of the ball
% Starting with the Mass, in Kilograms
init_stateVector(SV_I.M) = 1;

% Now we set the position of the ball (in cartesian coordinates, meters) where Positive X
% is to the right and Positive Y is ©Up©. This will be a 2D simulation so we can
% leave the Z component as zero.
%
% Groundlevel is at Y = 0m

% The Ball will start on the Y axis
init_stateVector(SV_I.P_X) = 0;

% The Ball starts 10m above the ground
init_stateVector(SV_I.P_Y) = 10;

% Next we set the velocity of the ball (again, in cartesian coordinates,
% meters/sec).

% The Ball will start traveling to the right at a speed of 5 m/s
init_stateVector(SV_I.V_X) = 5;

% The Ball will start traveling to up at a speed of 5 m/s
init_stateVector(SV_I.V_Y) = 5;

% We can set the number of control parameters for the Vehicle. Since this is a
% simple ball, it will have no control parameters and thus can be left as zero.
N_Ctrls = 0;

% A gravity model will be acting on the ball, so using the GravityModel_Generator
% (found in the Simulation/Models directory) we will create a gravity model with
% the following properties

% The acceleration due to gravity is constant and equal to 9.81 m/s^2
g = 9.81;

% Gravity will acceleration the ball ©Down© or along the Negative Y axis
g_Dir = [0;-1;0];

% We can then create the Gravity Model using the above properties:
ballGravityModel = GravityModel_Generator(g,g_Dir);

% Now we have all we need to create the Simple Ball Model using the ©Vehicle©
% class constructor. NOTE: The modelArray parameter must be a Cell Array
simpleBall = Vehicle(Name,init_stateVector,N_Ctrls,{ballGravityModel});

% Next, we will set up the integrator for the simulation using the
% RK4_Integrator found in the SimulationTools/Integrator/ Directory
% For this simulation we shall use a time step of 0.1 seconds
dt = 0.1; % seconds
RK4_Integrator = RK4_Integrator_Generator(dt);

% We are now ready to start our simulation. In order to analyze the simulation,
% we shall set up a structure to store our data.
SimData = struct;

SimData.P_X(1,1) = init_stateVector(SV_I.P_X);
SimData.P_Y(1,1) = init_stateVector(SV_I.P_Y);
SimData.V_X(1,1) = init_stateVector(SV_I.V_X);
SimData.V_Y(1,1) = init_stateVector(SV_I.V_Y);
SimData.Time(1,1) = 0;

% The simulation will be run in a for loop where we increment the time forward
% by the time step 'dt'
%
% The iterator for the simulation for loop will start at 2 since we already have
% the first time step data (the initial state of the ball)

for i=2:100
  % Calculate the next state of the ball
  next_state = RK4_Integrator(simpleBall);
  
  % Update the state of the ball
  simpleBall = simpleBall.setStateVector(next_state);
  
  % Record our desired data
  SimData.P_X(i,1) = simpleBall.getStateVector(SV_I.P_X);
  SimData.P_Y(i,1) = simpleBall.getStateVector(SV_I.P_Y);
  SimData.V_X(i,1) = simpleBall.getStateVector(SV_I.V_X);
  SimData.V_Y(i,1) = simpleBall.getStateVector(SV_I.V_Y);
  SimData.Time(i,1) = SimData.Time(i-1,1) + dt;
  
  % We can set up a condition to exit the for loop early if the ball goes below
  % the ground level (Y < 0)
  if simpleBall.getStateVector(SV_I.P_Y) < 0;
    disp(["Ball hit the ground at " num2str(SimData.Time(end)) " seconds"])
    break
  endif
endfor

% You should see a message on your console telling you when the ball hit the
% ground (if you didn't change the data, should be around 2.1 seconds)

% Now we can plot the data to visualizee the results
figure(1)
clf
title ("Postion of the Ball (X vs Y)")
xlabel ("X Position (m)")
ylabel ("Y Position (m)")
grid on
plot(SimData.P_X,SimData.P_Y);

figure(2)
clf
title ("Velocity vs Time of the Ball");
xlabel ("Velocity (m/s)");
ylabel ("Time (s)");
plot(SimData.Time,SimData.V_X)
hold on
plot(SimData.Time,SimData.V_Y)
legend ("Velocity X-axis","Velocity, Y-axis");
axis([0,max(SimData.Time),min(SimData.V_Y)-5,max(SimData.V_Y)+5])