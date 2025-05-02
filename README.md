# CSCP_time_varying
This code solves the coupled sensing and path planning in time varying threat fields.
This repo consists of 3 subfolders of class. 

# Description of each folder
@ACEGridWorld: Class defintion of grid world with uniform spacing and 4-adjacency.
               Includes member functions to implement Dijkastra algorithm and provide CSCP visualizations, true and estimated threat images on the workspace.
               Linked with ParametricThreat class to get threat costs.
               Linked with SensorNetworkV01 class for identifying the optimal sensor locations.

@ParametricThreat: Class defintion of defining the threat filed.
                   Include member functions to implement the UKF and provide plots for true and estimated threats.
                   Linked with ACEGridWorld class to define threats on the workspace.
                   The threat parameters are defined in this class, users can vary the dimensions of the threat parameters as required.

@SensorNetworkV01: Class defintion of sensor network.
                   Include member functions that implement the various sensor placement strategies.
                   Works with a threat model defined by ParametricThreat class.
                   Linked with GridWorld to get grid locations for sensors.
                   
                  

