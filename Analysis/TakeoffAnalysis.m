% This is an analysis script used for calculating plane's takeoff (rotation)
% speed and takeoff distance. Takeoff distance is used for checking which 
% runways we can take off based on their length.

g = 9.81;

Plane.Mass = 1;

Weight = Plane.Mass * g;

AoI = 2;         % Angle of Incidence (degrees)
Plane.AoA = AoI; % Angle of Attack (degrees)
Plane.AeroRefArea = 0.1; % Cross sectional area used for calculation of aerodynamic drag and lift (m2)

Plane.Cl = @(AoA) 2 * pi * deg2rad(AoA); % Coefficient of lift function (dimensionless)

[_, _, air_density] = AtmosphereModel(0);

TakeoffSpeed = sqrt(Weight / (Plane.AeroRefArea * Plane.Cl(Plane.AoA) * 0.5 * air_density));

% TODO: Calculate takeoff distance using the simulation.

printf('Takeoff speed: %.2f m/s (%.2f kmh)\n', TakeoffSpeed, TakeoffSpeed * 3.6);