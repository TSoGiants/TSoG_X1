function [Gen_AeroModel] = AeroModel_Generator(CL_Delegate, CD_Delegate, RefSurfArea)
  
  % This function generates a function delegate using the input parameters for
  % an Aerodynamic Model.
  % 
  % Parameters:
  %     CL_Delegate - A function delegate with input angle of attack (degrees) 
  %                   and outputs the Coeficient of Lift
  %     CD_Delegate - A function delegate with input angle of attack (degrees) 
  %                   and outputs the Coeficient of Drag
  %     RefSurfArea - Reference Surface Area (m^2) for aerodynamic calculations
  %
  % Example:
  %     CL_Delegate = @(alpha) 2*pi*deg2rad(alpha);
  %     CD_Delegate = @(alpha) CL_Delegate(alpha)^2 + 0.05;
  %     AeroModel  = AeroModel_Generator(CL_Delegate,CD_Delegate,2);
  
  Gen_AeroModel = @AerodynamicModel;
  
  function [Lift, Drag] = AerodynamicModel(Velocity, Orientation, Altitude)
  
    % Calculate air speed 
    Speed = norm(Velocity); % Magnitude of velocity vector
    
    % Calculate the flight path angle (FPA)
    FPA = atan2d(Velocity(2),Velocity(1));
    
    % Calculate the angle of attack (Alpha)
    Alpha = Orientation(1) - FPA;
  
    % Get the density of the air
    [_, _, air_density] = AtmosphereModel(Altitude);
    
    % Calculate Dynamic Pressure
    Q       = 0.5 * air_density * Speed^2;
    
    % Calculate Lift and Drag forces
    Lift_force = Q*RefSurfArea*CL_Delegate(Alpha);
    Drag_force = Q*RefSurfArea*CD_Delegate(Alpha);
    
    % Calculate the direction of drag force (
    %   Drag always acts opposite of air velocity
    if Speed == 0
      % Logic for determining Drag Direction if speed is 0
      Drag_dir = [0, 0];
    else
      Drag_dir = -Velocity / Speed; % Drag direction = -normalized velocity vector
    endif
    
    % Calculate the direction of the lift force
    %     Lift is 90 deg rotated clockwise from drag
    Lift_dir = Drag_dir * [0 -sind(90); sind(90) 0]; % Lift direction = drag direction rotated 90 deg
    
    % Get the Drag and Lift force in vector form
    Drag = Drag_dir*Drag_force;
    Lift = Lift_dir*Lift_force;
    
  endfunction
endfunction
