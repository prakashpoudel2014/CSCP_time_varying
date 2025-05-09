function plot_grid_elements(obj, threat_, grid_, sensor_, flags_)

if flags_.SHOW_TRUE && flags_.SHOW_ESTIMATE
	if flags_.JUXTAPOSE
		figure('Name', 'True', 'Units','normalized', 'Position', [0.3 0.1 0.3*[1.8 1.6]]);
		axisTrue= subplot(1,2,1);
		axisEst	= subplot(1,2,2);
	else
		figure('Name', 'True', 'Units','normalized', 'Position', [0.7 0.1 0.25*[0.9 1.6]]);
		axisTrue= gca;
		figure('Name', 'Estimate', 'Units','normalized', 'Position', [0.7 0.4 0.25*[0.9 1.6]]);
		axisEst	= gca;
	end
else
	figure('Name', 'True', 'Units','normalized', 'Position', [0.6 0.1 0.25*[0.9 1.6]]);
	if flags_.SHOW_TRUE
		axisTrue= gca;
	elseif flags_.SHOW_ESTIMATE
		axisEst	= gca;
	end
end

nPlotPts		= 200;
xGridPlot		= linspace(-obj.halfWorkspaceSize, obj.halfWorkspaceSize, nPlotPts);
yGridPlot		= linspace(-obj.halfWorkspaceSize, obj.halfWorkspaceSize, nPlotPts);
[xMesh, yMesh]	= meshgrid(xGridPlot, yGridPlot);
locationsMesh(:, :, 1) = xMesh;
locationsMesh(:, :, 2) = yMesh;


if flags_.SHOW_TRUE
	threatMesh	= threat_.calculate_at_locations(...
		locationsMesh,threat_.stateHistory(:, 1));
	imageMax	= max(threatMesh(:));
	imageMin	= min(threatMesh(:));
	imageClims	= [0.8*imageMin 1.5*imageMax];
	
	grHdlSurf	= surf(axisTrue, xMesh, yMesh, threatMesh,'LineStyle','none');
	clim(imageClims); colorbar('eastoutside'); view(2);
	axis equal; axis tight; hold on;
	xlim(1*[-obj.halfWorkspaceSize, obj.halfWorkspaceSize]); 
	ylim(1*[-obj.halfWorkspaceSize, 1*obj.halfWorkspaceSize]);
	zlim(imageClims);

%----- Plot grid
	plot3(...
		obj.coordinates(1, :), obj.coordinates(2, :), ...
		imageMax*ones(1, size(obj.coordinates, 2)), ...
		'.', 'Color', 'w', 'MarkerSize', 10);
 
%----- Plot centers of basis functions
	plot3(...
		threat_.basisCenter(1, :), threat_.basisCenter(2, :), ...
		imageMax*ones(1, size(threat_.basisCenter, 2)), ...
		'.', 'Color', 'k', 'MarkerSize', 15);
	for m2 = 1:threat_.nStates
		text(axisTrue, ...
			(threat_.basisCenter(1, m2)- 0.05), (threat_.basisCenter(2, m2) + 0.10), ...
			2*imageMax, num2str(m2), 'Color', 'k', 'FontName', 'Times New Roman', ...
			'FontSize', 12, 'Interpreter','latex')
	end
	drawnow();

     for m1 = 1:length(threat_.timeStampState)
      
% Delete previous plot if exists
    if exist('grHdlSurf', 'var')
        delete(grHdlSurf);
    end  
      
		threatMesh	= threat_.calculate_at_locations(...
			locationsMesh);
        threatMesh1	= threat_.calculate_at_locations(...
 			locationsMesh,threat_.stateEstimateHistory(:, end));
        newthreatMesh = (threatMesh - threatMesh1);
		surf(axisTrue, xMesh, yMesh, newthreatMesh,'LineStyle','none');
	    view(2);
        clim([1, 7]); 
        cb = colorbar; 
        
	    axis equal; axis tight; hold on;
	    set(gca, 'Color', '#D0D0D0')

	    xlim(1.2*[-obj.halfWorkspaceSize, obj.halfWorkspaceSize]); 
	    ylim(1.2*[-obj.halfWorkspaceSize, obj.halfWorkspaceSize]);
        xlabel('$x$', 'FontSize', 18, 'Interpreter', 'latex', 'FontName', 'Times New Roman');
        ylabel('$y$', 'FontSize', 18, 'Interpreter', 'latex', 'FontName', 'Times New Roman');
        ylabel(cb, '$c - \widehat{c}$', 'FontSize', 18, 'Interpreter', 'latex', 'FontName', 'Times New Roman');


	    drawnow();
     end
