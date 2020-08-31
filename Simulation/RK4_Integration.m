% 4th Order Runge-Kutta (RK4) integration
function SimData = RK4_Integration(SimData)

    dt = SimData.dt;

    % Initialize with zeroed delta
    k0.P_dot = [0,0]; % Position Derivative
    k0.V_dot = [0,0]; % Velocity Derivative
    k0.O_dot = [0];   % Orientation Derivative
    k0.Time    = SimData.Time;

    % Calculate the k1 delta
    k1 = Derivatives(k0,SimData,0.5);

    % Calculate the k2 delta
    k2 = Derivatives(k1, SimData,0.5);

    % Calculate the k3 delta
    k3 = Derivatives(k2, SimData,1);

    % Calculate the k4 delta
    k4 = Derivatives(k3, SimData,1);

    avg_delta.P_delta = dt*(k1.P_dot + 2*k2.P_dot + 2*k3.P_dot + k4.P_dot)/6;
    avg_delta.V_delta = dt*(k1.V_dot + 2*k2.V_dot + 2*k3.V_dot + k4.V_dot)/6;
    avg_delta.O_delta = dt*(k1.O_dot + 2*k2.O_dot + 2*k3.O_dot + k4.O_dot)/6;

    % Update Simulation Time
    SimData.Time = SimData.Time + dt;

    % Reset the altitude when we are on the ground to prevent the plane from 
    % going very slightly below the ground due to the discreteness of the simulation
    if SimData.Plane.FSM_state == FSMStates.OnGround
        SimData.StateVector.Position(2) = SimData.ground_height;
    endif

    % Update SimData with averaged k Deltas
    SimData.StateVector.Position    = SimData.StateVector.Position + avg_delta.P_delta;
    SimData.StateVector.Velocity    = SimData.StateVector.Velocity + avg_delta.V_delta;
    % Pitch is controlled here so we just map it from the test case
    SimData.StateVector.Orientation(1) = SimData.TestCase.GetPitch(SimData.Time);

    % Update FSM State of Plane
    SimData.Plane.FSM_state = GetFSMState(SimData);
    flight_path_angle = atan2d(SimData.StateVector.Velocity(2), SimData.StateVector.Velocity(1));
    SimData.Plane.AoA = SimData.StateVector.Orientation(1) - flight_path_angle;

endfunction
