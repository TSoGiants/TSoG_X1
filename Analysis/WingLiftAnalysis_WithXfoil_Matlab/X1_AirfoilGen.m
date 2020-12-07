function [airfoilData] = X1_AirfoilGen(chord)
%X1_AIRFOILGEN creates an airfoil using a NACA 4-Digit airfoil generator
%   Input: chord - Length of the desired chord of the airfoil in mm

%% Default parameters for naca4gen()
input.n = 100;
input.HalfCosineSpacing = true;
input.wantFile = false;
input.datFilePath = '';
input.is_finiteTE = true;

%% Calculate the 3 parameters (p,t,m) for NACA 4-Digit system
% We will calculate this by establishing the thickness of the board
% (bThickness)
bThickness = 5; % mm

% The max camber of the airfoil (the 'm' parameter for a NACA 4-Digit
% sytem) will be half the thickness as a percentage of the chord
input.m = (0.5*bThickness)/chord;

% The position of max camber (the 'p' parameter for a NACA 4-Digit
% system) will be constant at 25% of the chord
input.p = 0.25; % percentage

% The max thickness (the 't' parameter for a NACA 4-Digit system) is 3
% times the board thickness as a percentage of the chord
input.t = (3*bThickness)/chord;

airfoilData = naca4gen(input);

end