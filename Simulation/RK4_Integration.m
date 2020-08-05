% 4th Order Runge-Kutta (RK4) integration
function SimData = RK4_Integration(SimData)

    dt = SimData.dt;

    % Initialize with zeroed delta
    k0.P_delta = [0,0]; % Position Derivative
    k0.V_delta = [0,0]; % Velocity Derivative
    k0.O_delta = [0];   % Orientation Derivative
    k0.Time    = SimData.Time;

    % Calculate the k1 delta
    k1_derivative = Derivatives(k0,SimData);
    k1.P_delta = k1_derivative.P_dot*dt*0.5;
    k1.V_delta = k1_derivative.V_dot*dt*0.5;
    k1.O_delta = k1_derivative.O_dot*dt*0.5;
    k1.Time    = SimData.Time + dt*0.5;

    % Calculate the k2 delta
    k2_derivative = Derivatives(k1, SimData);
    k2.P_delta = k2_derivative.P_dot*dt*0.5;
    k2.V_delta = k2_derivative.V_dot*dt*0.5;
    k2.O_delta = k2_derivative.O_dot*dt*0.5;
    k2.Time    = SimData.Time + dt*0.5;

    % Calculate the k3 delta
    k3_derivative = Derivatives(k2, SimData);
    k3.P_delta = k3_derivative.P_dot*dt;
    k3.V_delta = k3_derivative.V_dot*dt;
    k3.O_delta = k3_derivative.O_dot*dt;
    k3.Time    = SimData.Time + dt;

    % Calculate the k4 delta
    k4_derivative = Derivatives(k3, SimData);
    k4.P_delta = k4_derivative.P_dot*dt;
    k4.V_delta = k4_derivative.V_dot*dt;
    k4.O_delta = k4_derivative.O_dot*dt;

    avg_delta.P_delta = (k1.P_delta + 2*k2.P_delta + 2*k3.P_delta + k4.P_delta)/6;
    avg_delta.V_delta = (k1.V_delta + 2*k2.V_delta + 2*k3.V_delta + k4.V_delta)/6;
    avg_delta.O_delta = (k1.O_delta + 2*k2.O_delta + 2*k3.O_delta + k4.O_delta)/6;

    % Update Simulation Time
    SimData.Time = SimData.Time + dt;

    % Update SimData with averaged k Deltas
    SimData.StateVector.Position    = SimData.StateVector.Position + avg_delta.P_delta;
    SimData.StateVector.Velocity    = SimData.StateVector.Velocity + avg_delta.V_delta;
    % Pitch is controlled here so we just map it from the test case
    SimData.StateVector.Orientation(1) = SimData.TestCase.GetPitch(SimData.Time);

    % Update FSM State of Plane
    SimData.Plane.FSM_state = Get_FSM_State(SimData);
    flight_path_angle = atan2d(SimData.StateVector.Velocity(2), SimData.StateVector.Velocity(1));
    SimData.Plane.AoA = SimData.StateVector.Orientation(1) - flight_path_angle;

endfunction
