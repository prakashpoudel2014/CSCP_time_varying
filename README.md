# CSCP_time_varying
This code solves the coupled sensing and path planning in time varying threat fields.
This repo consists of 3 subfolders of class. 
# Description of each folder
@ACEGridWorld: Class defintion of grid world with uniform spacing and 4-adjacency.
               Includes member functions to implement Dijkastra algorithm and provide CSCP visualizations plots on the workspace.
               Linked with ParametricThreat class to get threat costs.
               Linked with SensorNetworkV01 class for identifying the optimal sensor locations.

@ParametricThreat: Class defintion of defining the threat filed.
                   Based on the parametric representation of Gaussian basis functions
                   Linked with ParametricThreat class to get threat costs.
                   Linked with SensorNetworkV01 class for identifying the optimal sensor locations.

