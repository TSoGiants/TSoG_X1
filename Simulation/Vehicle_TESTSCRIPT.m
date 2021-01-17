% Clearing all to be able to re-initialize the Class Definitions
clear all

% Test creation of a Electric Model Airplane Class
B = zeros(11,1);
A = eModelAirplane('TestVehicle',B);

% Test setting of stateVector
B = linspace(1,11,11)';
A = A.setStateVector(B);

% Test setting the AeroModel
CL_Delegate = @(alpha) 2*pi*deg2rad(alpha);
CD_Delegate = @(alpha) CL_Delegate(alpha)^2 + 0.05;
RefSurfArea = 2;
A = A.setAeroModel(CL_Delegate,CD_Delegate,RefSurfArea);

% Test getting the AeroModel
[Lift,Drag] = A.getAeroForces();