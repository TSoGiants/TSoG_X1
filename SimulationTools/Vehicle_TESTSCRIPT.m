% Clearing all to be able to re-initialize the Class Definitions
clear all

Name = 'TestVehicle';

% Test creation of a Electric Model Airplane Class
init_stateVector = zeros(11,1);

N_Ctrls = 0;

% Test Generating the AeroModel
CL_Delegate = @(alpha) 2*pi*deg2rad(alpha);
CD_Delegate = @(alpha) CL_Delegate(alpha)^2 + 0.05;
RefSurfArea = 0.5;
AeroModel = AeroModel_Generator(CL_Delegate, CD_Delegate, RefSurfArea);

% Test Generating a Gravity Model
GravityModel = GravityModel_Generator(9.81,[0;-1;0]);

modelArray = {AeroModel,GravityModel};
try
  A = Vehicle(Name,init_stateVector,N_Ctrls,modelArray);
catch err
  disp(err.message)
end_try_catch
SV_Index = StateVector_Index;
init_stateVector(SV_Index.M) = 1;
A = Vehicle(Name,init_stateVector,N_Ctrls,modelArray);

Dervs = A.getDerivatives();

% Test setting of stateVector
B = linspace(1,11,11)';
A = A.setStateVector(B);

Dervs2 = A.getDerivatives();
dt = 0.01;
RK4I = RK4_Integrator_Generator(dt);

disp('RK4 Test for Vehicle A')
RK4I(A)

init_stateVector_B = zeros(11,1);
init_stateVector_B(SV_Index.M) = 1;
init_stateVector_B(SV_Index.P) = [0;10;0];
init_stateVector_B(SV_Index.V) = [10;0;0];

modelArray_B = {GravityModel};
B = Vehicle('TestVehicleB',init_stateVector_B,N_Ctrls,modelArray_B);

P = zeros(100,2);

P(1,:) = init_stateVector_B([SV_Index.P_X,SV_Index.P_Y]);

for i = 2:200
  temp_SV = RK4I(B);
  if temp_SV(SV_Index.P_Y) > 0
    B = B.setStateVector(temp_SV);
    P(i,:) = B.getStateVector([SV_Index.P_X,SV_Index.P_Y]);
  else
    P(i,:) = B.getStateVector([SV_Index.P_X,SV_Index.P_Y]);
  endif
endfor

plot(P(:,1),P(:,2))