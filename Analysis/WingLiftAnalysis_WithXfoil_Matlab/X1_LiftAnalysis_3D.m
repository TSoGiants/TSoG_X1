function [AeroData_3D] = X1_LiftAnalysis_3D(chord,span)
% Using aerodynamic data from X1_LiftAnalysis_2D and Lifting-Line theory,
% get the Aerodynamic Data of the 3D wing of the X1 Aircraft given a Chord
% and Span length (mm)

% Get the 2D aerodynamic data for the airfoil given the chord
[AeroData_2D] = X1_LiftAnalysis_2D(chord);

AeroData_3D.AeroData_2D = AeroData_2D;
AeroData_3D.span = span;
AeroData_3D.AR   = span/chord; % Aspect Ratio for rectangular wing

[AeroData_3D.CL_wing,AeroData_3D.CD_wing] = LifingLineAnalysis(AeroData_3D,0);

end

%% Sub Functions

function [CL_wing, CD_wing] = LifingLineAnalysis(AeroData_3D,alpha_inf)
% Function is created from the Lifting-Line Theory algorithm described
% here: https://en.wikipedia.org/wiki/Lifting-line_theory

% alpha_inf: Angle of Attack of the airfoil

% Get Airfoil Data at specified Alpha
chord = AeroData_3D.AeroData_2D.chord;
span  = AeroData_3D.span/2; % only need half span
AR    = AeroData_3D.AR;

% This analysis needs the AoA to be in radians
alpha_inf_rad = deg2rad(alpha_inf);
Cl_alpha = AeroData_3D.AeroData_2D.CL_dAlpha_rad(alpha_inf_rad); % need to use rad2deg since it's 1/Angle
alpha_zeroLift = deg2rad(AeroData_3D.AeroData_2D.alpha_CL0);

% Number of sections to split up the wing
N = 100;
theta = linspace(90,0,N)';

% Number of terms to solve for
stations = ceil(N/10);

LHS = zeros(length(theta)-2,stations);
RHS = zeros(length(theta)-2,1);

% Calculate LHS and RHS matricies of simultaneous equations
for i=2:length(theta)-1
    for n=1:stations
        LHS(i-1,n) = sind(n*theta(i))*(sind(theta(i)) + (n*Cl_alpha*chord)/(8*span));
    end
    RHS(i-1) = ((Cl_alpha*chord)/(8*span))*sind(theta(i))*(alpha_inf_rad - alpha_zeroLift);
end

% Solve the simultaneous equations
An  = LHS'*RHS;

% Cacluate Full Wing Lift Coefficient
CL_wing = 2*pi*AR*An(1);

% Calculate the span efficiency factor
delta_sum = 0;
for n=2:length(An)
    delta_sum = delta_sum + n*(An(n)^2);
end
delta = delta_sum/(An(1)^2);

e = 1/(1+delta); % span efficiency factor

% Calculate the Full Wing Drag Coefficient
CD_induced = (CL_wing^2)/(pi*AR*e);
CD_2D = AeroData_3D.AeroData_2D.CD_interp(alpha_inf);

CD_wing = CD_2D + CD_induced;

end