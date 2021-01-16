clear all
B = linspace(1,11,11)';
A = eModelAirplane('TestVehicle',B);

CL_Delegate = @(alpha) 2*pi*deg2rad(alpha);
CD_Delegate = @(alpha) CL_Delegate(alpha)^2 + 0.05;
A.setAeroModel(CL_Delegate,CD_Delegate,2);
[Lift,Drag] = A.getAeroForces();