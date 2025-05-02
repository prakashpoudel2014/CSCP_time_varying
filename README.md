# CSCP_time_varying
This MATLAB code implements Coupled Sensor Configuration and Path Planning (CSCP) in time-varying threat fields.

It consists of three core class definition folders and one main script to execute the simulation.

# Description of each folder
**@ACEGridWorld**

Defines the grid world with uniform spacing and 4-adjacency connectivity.

Implements Dijkstra’s algorithm to compute minimum-cost paths.

Provides visualizations of the workspace, including true and estimated threat fields, planned paths.

Interacts with: ParametricThreat class to obtain threat-related costs, SensorNetworkV01 class to determine optimal sensor placements


**@ParametricThreat**

Defines the parametric threat field.

Implements an Unscented Kalman Filter (UKF) to estimate the evolving threat.

Provides plotting tools for true and estimated threats.

Allows customization of threat parameters, including dimensionality and dynamics.

Interacts with: ACEGridWorld to define threat cost at grid locations.


**@SensorNetworkV01**

Defines the sensor network model.

Implements sensor placement strategies, including greedy selection based on Mutual Information (MI).

Interacts with: ParametricThreat to receive threat estimate, ACEGridWorld to access sensor placement coordinates on the grid.


**cscp_v03**

Main driver script to run the CSCP algorithm.

Initializes: Grid world, Threat field, Sensor network

Performs iterative updates of: Threat parameters (via UKF), Sensor locations (via MI-based greedy algorithm).

Executes path planning using updated threat estimates.

Allows user customization of: Sensor configuration schemes, Number of sensors, Threat parameters.
                   
                  

