%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%               Simple Ball Simulation under Constant Gravity and              %
%                              Aerodynamic Drag                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prequisites: Highly suggest going through the 'SimpleBallSimulation' first to
% get familiarized with the simulation tools
%
% Description: In this example, we will take the Simple Ball that we created in
% the 'SimpleBallSimulation' script and add aerodynamic drag to it in order to
% analyze the difference in behavior
%
% We can load up the 'simpleBall' and data by simply running the
% 'SimpleBallSimulation' script
SimpleBallSimulation;
simpleBall_WithAero = Vehicle(Name,init_stateVector,N_Ctrls,{ballGravityModel});

% Next, we will be utilizing the 'addModel' method of the 'Vehicle' class,
% however we need to create the aerodynamic model (AeroModel) first
%
% This can be done using the 'AeroModel_Generator' found in the
% SimulationTools/Models/ directory
% 
% The AeroModel requires 3 things:
%   1. A function delegate that will output the Coefficient of Lift (CL) given 
%   the Angle of Attack (AoA, alpha)
%   2. A function delegate that will output the Coefficient of Drag (CD) given
%   the Angle of Attack (AoA, alpha)
%   3. The reference cross sectional area of the ball (in m^2)

% In order to simplify the model, we are going to assume the ball will generate
% no lift regardless of the AoA, and the coefficient of drag will be
% constant for all AoAs

% Thus we can construct the function delegates as follows
CL_Delegate = @(alpha) 0;
CD_Delegate = @(alpha) 0.47; 
% The CD is found from the Wikipedia article
% example for a sphere: https://en.wikipedia.org/wiki/Drag_coefficient

% Let us assume the ball is around the size of a tennis ball, and thus we can
% calculate the reference surface area using the average radius of a tennis ball
TennisBall_Radius = 0.066; % in meters
A_ref = pi*TennisBall_Radius^2;

% Now, we can create the AeroModel for the ball using the CL_Delegate, the
% CD_Delegate, and the A_Ref parameters
Ball_AeroModel = AeroModel_Generator(CL_Delegate,CD_Delegate,A_ref);

% Using the new AeroModel, we can make a new Ball model using the 'simpleBall'
% model we created in the 'SimpleBallSimulation' script
simpleBall_WithAero = simpleBall_WithAero.addModel(Ball_AeroModel);

% Now we can run the new model through the same simulation for loop
% Initialize a new structure to save the new model's data
newSimData = struct;

newSimData.P_X(1,1) = init_stateVector(SV_I.P_X);
newSimData.P_Y(1,1) = init_stateVector(SV_I.P_Y);
newSimData.V_X(1,1) = init_stateVector(SV_I.V_X);
newSimData.V_Y(1,1) = init_stateVector(SV_I.V_Y);
newSimData.Time(1,1) = 0;

for i=2:100
  % Calculate the next state of the ball
  next_state = RK4_Integrator(simpleBall_WithAero);
  
  % Update the state of the ball
  simpleBall_WithAero = simpleBall_WithAero.setStateVector(next_state);
  
  % Record our desired data
  newSimData.P_X(i,1) = simpleBall_WithAero.getStateVector(SV_I.P_X);
  newSimData.P_Y(i,1) = simpleBall_WithAero.getStateVector(SV_I.P_Y);
  newSimData.V_X(i,1) = simpleBall_WithAero.getStateVector(SV_I.V_X);
  newSimData.V_Y(i,1) = simpleBall_WithAero.getStateVector(SV_I.V_Y);
  newSimData.Time(i,1) = newSimData.Time(i-1,1) + dt;
  
  % We can set up a condition to exit the for loop early if the ball goes below
  % the ground level (Y < 0)
  if simpleBall_WithAero.getStateVector(SV_I.P_Y) < 0;
    disp(["Ball hit the ground at " num2str(newSimData.Time(end)) " seconds"])
    break
  endif
endfor

% The ball should hit later than the first ball did
% Lastly, we can plot the data on top of eachother to see how they compare

figure(1)
hold on
plot(newSimData.P_X,newSimData.P_Y);

%figure(2)
%clf
%title ("Velocity vs Time of the Ball");
%xlabel ("Velocity (m/s)");
%ylabel ("Time (s)");
%plot(SimData.Time,SimData.V_X)
%hold on
%plot(SimData.Time,SimData.V_Y)
%legend ("Velocity X-axis","Velocity, Y-axis");
%axis([0,max(SimData.Time),min(SimData.V_Y)-5,max(SimData.V_Y)+5])