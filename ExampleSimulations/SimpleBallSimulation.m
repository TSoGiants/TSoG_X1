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

% First step is to set the name of the ball

Name = ©Simple Ball©;

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
init_stateVector = zeros(SV_I.TotalState,1);

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

