%{
SOFTWARE LICENSE
----------------
Copyright (c) 2023 by 
	Raghvendra V Cowlagi
	Bejamin Cooper
	Prakash Poudel

Permission is hereby granted to any person obtaining a copy of this
software and associated documentation files (the "Software"), to deal in
the Software, including the rights to use, copy, modify, merge, copies of
the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:  

* The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.
* The Software, and its copies or modifications, may not be distributed,
published, or sold for profit. 
* The Software, and any substantial portion thereof, may not be copied or
modified for commercial or for-profit use.

The software is provided "as is", without warranty of any kind, express or
implied, including but not limited to the warranties of merchantability,
fitness for a particular purpose and noninfringement. In no event shall the
authors or copyright holders be liable for any claim, damages or other
liability, whether in an action of contract, tort or otherwise, arising
from, out of or in connection with the software or the use or other
dealings in the software.      


PROGRAM DESCRIPTION
-------------------
Reconfiguration function in class definition of sensor network:
	* Grid locations
	* Placement with basis ID matching
	* Works with a threat model defined by ParametricThreat class
%}

function obj = configure_greedy_cost(obj,threat_, grid_, optimalPath, timestep)
    sensorCombination1 = nchoosek(1:obj.gridWorld.nPoints,1);
    numberCombination1 = numel((sensorCombination1(:,1)));
    mutualInformationHistory  = [];
    mutualInformation_array1   = zeros(1,2);                 %[index, MI]
    mutualInformation_array2   = zeros(1,3);
    j     = 1;
    pathLength = length(optimalPath);

    for i = 1:numberCombination1
        possibleConfigurations1	= sensorCombination1(i,:);
        H = threat_.calc_rbf_value(grid_.coordinates(:, possibleConfigurations1));
        pNext = obj.threatModel.pNext;
        pNextHist = obj.threatModel.pNextHist;
        size(pNext);
        size(pNextHist);

        sum  = zeros(threat_.nStates,1);
        sum1 = zeros(1,1);
        sum2 = zeros(1,1);
        obj.truepathCost = 0;
        obj.estimatedpathCost = 0;
        for k    = 1:pathLength
            phi  = threat_.calc_rbf_value(grid_.coordinates(:, optimalPath(:,k)));
            sum  = sum + (pNextHist(:,:,k)) * phi';
            sum1 = sum1 + phi *(pNextHist(:,:,k)) * phi';
            obj.truepathCost = obj.truepathCost  + phi * obj.threatModel.state;
            obj.estimatedpathCost = obj.estimatedpathCost + phi * obj.threatModel.stateEstimate;

            for ii = 1: obj.pathLength-1
                for jj = 2: obj.pathLength
                    phi1 = threat_.calc_rbf_value(grid_.coordinates(:, optimalPath(:,ii)));
                    phi2 = threat_.calc_rbf_value(grid_.coordinates(:, optimalPath(:,jj)));
                    sum2 = sum2 + phi1 *((pNextHist(:,:,ii)) + (pNextHist(:,:,jj)))*phi2';
                end
            end
        end
        
        tau = H * obj.gridWorld.spacing * sum;
        tau = tau';
        obj.varpathCost  = (obj.gridWorld.spacing)^2 * (sum1 + 2* sum2);
        Xi     = H * pNext*H' + obj.noiseVariance * eye(obj.nSensors);
        obj.truepathCost =  pathLength + obj.gridWorld.spacing  *obj.truepathCost; 
        obj.estimatedpathCost =  pathLength + obj.gridWorld.spacing  *obj.estimatedpathCost;  
        obj.pathRisk = obj.estimatedpathCost + sqrt(obj.varpathCost);
        
       % Calculate mutual information between the cost and measurement.
        currentmutualInformation = abs(real(0.5 * log(det(obj.varpathCost)/(det(obj.varpathCost - tau * pinv(Xi) * tau')))));
        
        distance = ones(obj.nSensors, 1) * inf;
        for n = 1:obj.nSensors
            distance(n) = norm(grid_.coordinates(:, sensorCombination1(i)) - grid_.coordinates(:,obj.configuration(n)));   
        end
        min_dist = min(distance);

        C =  norm(grid_.coordinates(:, 1) - grid_.coordinates(:,grid_.nPoints));
        alpha = 0.01;

        % Mi for modified with sensor cost
        modifiedmutualInformation =  currentmutualInformation + alpha * (C - min_dist);
        mutualInformationHistory = cat(2, mutualInformationHistory,  modifiedmutualInformation);
        obj.allConf_MI(j,1) = sensorCombination1(i,:);
        obj.allConf_MI(j,2) = modifiedmutualInformation;
        obj.allConf_MI;
        
         % Mi for current without sensor cost
        obj.allConf_MI1(j,1) = sensorCombination1(i,:);
        obj.allConf_MI1(j,2) = currentmutualInformation;
        obj.allConf_MI1;

        if modifiedmutualInformation > mutualInformation_array1(:,end)
           mutualInformation_array1(:,1) = sensorCombination1(i,:);
           mutualInformation_array1(:,2) = modifiedmutualInformation;
        end
       j = j + 1;
    end


    max_index1 = mutualInformation_array1(:, 1);
    greedy_matrix1 = [max_index1 * ones(size(sensorCombination1)), sensorCombination1];
    index = greedy_matrix1(:, 1) ~= greedy_matrix1(:, 2);
    greedy_matrix1 =  greedy_matrix1(index, :);

    numberCombination2 = numel(( greedy_matrix1(:,1)));

     for i = 1:numberCombination2
        possibleConfigurations2	=  greedy_matrix1(i,:);
        H1 = threat_.calc_rbf_value(grid_.coordinates(:, possibleConfigurations2));
        tau = H1 * obj.gridWorld.spacing * sum;
        tau = tau';     
        Xi     = H1 * pNext*H1' + obj.noiseVariance * eye(2);
       obj.pathRisk = obj.estimatedpathCost + sqrt(obj.varpathCost);
        
       % Calculate mutual information between the cost and measurement.
        currentmutualInformation = abs(real(0.5 * log(det(obj.varpathCost)/(det(obj.varpathCost - tau * pinv(Xi) * tau')))));
        mutualInformationHistory = cat(2, mutualInformationHistory,  currentmutualInformation);
        distance1 = ones(obj.nSensors, 1) * inf;
        for n = 1:1:obj.nSensors
            distance1(n) = norm(grid_.coordinates(:, greedy_matrix1(i, 2)) - grid_.coordinates(:,obj.configuration(n)));   
        end
        size(distance1);
        min_dist1 = min(distance1);

        C =  norm(grid_.coordinates(:, 1) - grid_.coordinates(:,grid_.nPoints));
        alpha = 0.01;

        modifiedmutualInformation =  currentmutualInformation + alpha * (C - min_dist1);
        mutualInformationHistory = cat(2, mutualInformationHistory,  modifiedmutualInformation);

        if modifiedmutualInformation > mutualInformation_array2(:,end)
           mutualInformation_array2(:,1:2) = greedy_matrix1(i,:);
           mutualInformation_array2(:,3) = modifiedmutualInformation;
        end
        j = j + 1;
     end
    dist = 0;
   

   
    obj.configuration = mutualInformation_array2(:, 1:obj.nSensors);
    obj.configHistory = cat(2, obj.configHistory,  obj.configuration');
    for nn = 1:1:obj.nSensors
            dist = dist + norm(grid_.coordinates(:,obj.configHistory(nn,end)) - grid_.coordinates(:,obj.configHistory(nn, end-1))) ;
    end
    
    obj.sensorCost = max(dist);
    obj.MI = mutualInformation_array2(:, 1:obj.nSensors + 1);
    obj.MIHistory = cat(2, obj.MIHistory,  obj.MI');
     obj.sensorCostHistory = [obj.sensorCostHistory		obj.sensorCost];
    obj.truepathCostHistory = [obj.truepathCostHistory		obj.truepathCost];
    obj.estimatedpathCostHistory = [obj.estimatedpathCostHistory		obj.estimatedpathCost];
    obj.varpathCostHistory = [obj.varpathCostHistory		obj.varpathCost];
    obj.pathRiskHistory = [obj.pathRiskHistory		obj.pathRisk];
end
