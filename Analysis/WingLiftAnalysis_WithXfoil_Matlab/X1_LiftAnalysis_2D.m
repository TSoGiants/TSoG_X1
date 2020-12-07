function [AeroData_2D] = X1_LiftAnalysis_2D(chord)
% Using the chord as the input (in mm), assuming the board thickness is 5
% mm, calculate the aerodynamic properties necessary for 3D analysis of an
% airfoil using Xfoil

%% Get the airfoil geometry data
[airfoilData] = X1_AirfoilGen(chord);
airfoilXY(:,1) = airfoilData.x;
airfoilXY(:,2) = airfoilData.y;
%% Calculate Reynolds Number (Re) and Mach Number at: 15 m/s (33.6 mph), Standard Day, 0 m altitude (sea level)

% Reynolds number calculation
rho = 1.225;        % kg/m^3, Density of Air
mew = 1.81E-5;      % kg/(m*s), Dynamic viscosity of Air
L   = chord/1000;   % m, Characteristic linear dimension
v   = 15;            % m/s, Airspeed

Re = (rho*v*L)/mew;

% Speed of Sound Calculation
gamma = 1.4;        % none, Adiabatic Index
R     = 287;        % m^2/(K*s^2), Gas Constant
T     = 15+273.15;  % K, Absolute Air Temperature

a = sqrt(gamma*R*T); % m/s, Speed of Sound

% Mach Number Calculation
Mach = v/a;    % none, Mach Number

%% Create range of Angle of Attack (AoA,alpha) values

alphas = (-10:0.5:10)';

%% Run Xfoil with Geometry and Air Data
% Default iteration limit is 10 due to when this was made (age when
% computers were much slower), thus increasing to 250 to help with
% converging
[pol,~] = xfoil(airfoilXY,alphas,Re,Mach,'oper iter 200','oper vpar n 15');

AeroData_2D.chord = chord;
AeroData_2D.CL = pol.CL;
AeroData_2D.CD = pol.CD;
AeroData_2D.alpha = pol.alpha;
AeroData_2D.CL_interp = @(alpha) interp1(AeroData_2D.alpha,AeroData_2D.CL,alpha);
AeroData_2D.CD_interp = @(alpha) interp1(AeroData_2D.alpha,AeroData_2D.CD,alpha);

% Calculate the derivative of CL vs Alpha for Degrees
temp_CL_dAlpha = diff(pol.CL)./diff(pol.alpha);
AeroData_2D.CL_dAlpha = @(alpha) interp1(AeroData_2D.alpha(2:end),temp_CL_dAlpha,alpha);

% Calculate the derivative of CL vs Alpha for Radians
temp_CL_dAlpha_rad = diff(pol.CL)./diff(deg2rad(pol.alpha));
AeroData_2D.CL_dAlpha_rad = @(alpha_rad) interp1(deg2rad(AeroData_2D.alpha(2:end)),temp_CL_dAlpha_rad,alpha_rad);
AeroData_2D.alpha_CL0 = getZeroLiftAlpha(AeroData_2D);

end

%% Sub Functions

function [alpha_CL0] = getZeroLiftAlpha(AeroData_2D)
% A function to find the Zero Lift Angle of Attack (AoA for 2D airfoil
% data

% NOTE: This function assumes the airfoil has a positive slope near 0
% and is close to linear when CL = 0

% Create an anonymous function to ease code for interpolating CL vs
% Alpha


% Use an expanding Bi-Section method to find the 0 lift AoA
iter_limit = 100;
testAlpha1 = -1;
testAlpha2 = 1;
testAlpha  = (testAlpha1 + testAlpha2)/2;

% Set tolerance limit for angle
tol = 0.001;

for i=1:iter_limit
    % Check if both points are above CL = 0
    out1 = AeroData_2D.CL_interp(testAlpha1);
    if out1 > 0
        testAlpha1 = testAlpha1-1;
        testAlpha2 = testAlpha2-1;
        testAlpha  = testAlpha-1;
        continue
    end
    
    % Check if both points are below CL = 0
    out2 = AeroData_2D.CL_interp(testAlpha2);
    if out2 < 0
        testAlpha1 = testAlpha1+1;
        testAlpha2 = testAlpha2+1;
        testAlpha  = testAlpha+1;
        continue
    end
    
    % Bisection Algorithm
    out  = AeroData_2D.CL_interp(testAlpha);
    if out < 0
        testAlpha1 = testAlpha;
        testAlpha  = (testAlpha1 + testAlpha2)/2;
    else
        testAlpha2 = testAlpha;
        testAlpha  = (testAlpha1 + testAlpha2)/2;
    end
    
    if abs(testAlpha1 - testAlpha2) <= tol
        break
    end
end

alpha_CL0 = testAlpha;
end
% deg2pi = pi/180;
% Cl_alpha = 2*pi;
% c = 0.1; % m,
% s = 0.5; % m, half span
% AR = 2*s/c; % Aspect ratio
% alpha_inf = 0;
% alpha_geo = 0;
% alpha_zeroLift = -5;
%
%
% theta = linspace(90,0,10)';
%
%
% stations = 3;
%
% LHS = zeros(length(theta)-2,stations);
% RHS = zeros(length(theta)-2,1);
%
% for i=2:length(theta)-1
%     for n=1:stations
%         LHS(i-1,n) = sind(n*theta(i))*(sind(theta(i)) + (n*Cl_alpha*c)/(8*s));
%     end
%     RHS(i-1) = ((Cl_alpha*c)/(8*s))*sind(theta(i))*(alpha_inf + alpha_geo - alpha_zeroLift);
% end
%
% An  = LHS'*RHS;
%
% Cl_halfwing = pi*AR*An(1);


%% Sub Functions

% function [Cl] = Cl_alpha(alpha)
% deg2pi = pi/180;
% Cl = 2*pi*alpha*deg2pi;
%
% end