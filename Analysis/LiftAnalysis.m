deg2pi = pi/180;
Cl_alpha = 2*pi;
c = 0.1; % m, 
s = 0.5; % m, half span
AR = 2*s/c; % Aspect ratio
alpha_inf = 0;
alpha_geo = 0;
alpha_zeroLift = -5;


theta = linspace(90,0,10)';


stations = 3;

LHS = zeros(length(theta)-2,stations);
RHS = zeros(length(theta)-2,1);

for i=2:length(theta)-1
    for n=1:stations
        LHS(i-1,n) = sind(n*theta(i))*(sind(theta(i)) + (n*Cl_alpha*c)/(8*s));
    end
    RHS(i-1) = ((Cl_alpha*c)/(8*s))*sind(theta(i))*(alpha_inf + alpha_geo - alpha_zeroLift);
end

An  = LHS'*RHS;

Cl_halfwing = pi*AR*An(1);


%% Sub Functions

% function [Cl] = Cl_alpha(alpha)
% deg2pi = pi/180;
% Cl = 2*pi*alpha*deg2pi;
% 
% end