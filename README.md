# CSCP_time_varying
This MATLAB code implements Coupled Sensor Configuration and Path Planning (CSCP) in time-varying threat fields.

It consists of three core class definition folders and one main script to execute the simulation.

# Description of each folder
@ACEGridWorld
Defines the grid world with uniform spacing and 4-adjacency connectivity.

Implements Dijkstra’s algorithm to compute minimum-cost paths.

Provides visualizations of the workspace, including:

True and estimated threat fields

Planned paths

Interacts with:

ParametricThreat class to obtain threat-related costs

SensorNetworkV01 class to determine optimal sensor placements

@ParametricThreat: Class defintion of defining the threat filed.
                   Include member functions to implement the UKF and provide plots for true and estimated threats.
                   Linked with ACEGridWorld class to define threats on the workspace.
                   The threat parameters are defined in this class, users can vary the dimensions of the threat parameters as required.

@SensorNetworkV01: Class defintion of sensor network.
                   Include member functions that implement the various sensor placement strategies.
                   Works with a threat model defined by ParametricThreat class.
                   Linked with GridWorld to get grid locations for sensors.

cscp_v03: This is the main file with implementation of a coupled sensor configurationa path planning (CSCP) algorith.
          Initialize all the classes, and perform iteration counter where the parameters of threats and sensor locations are updated iteratively. 
          Users can change the sensor configuration scheme or number of sensors, parameters here as required.
                   
                  

