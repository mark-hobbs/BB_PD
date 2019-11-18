function plotflags(undeformedCoordinates,flag)
% plotflags - plot all material points and highlight
% applied boundary conditions (location and direction of boundary condition
% flags)

NOD = size(undeformedCoordinates,2);
sz = 5;

%% Seperate material points into sub sets

% Sub Sets:
% constrained and unconstrained in x direction 
% constrained and unconstrained in y direction 
% constrained and unconstrained in z direction

% If CONSTRAINTFLAG = 1, node is constrained, if CONSTRAINTFLAG = 0, node is unconstrained 

flagOnX = find(flag(:,1) == 1);
flagOnY = find(flag(:,2) == 1);

coordinatesFlagOnX = undeformedCoordinates(flagOnX,:);
coordinatesFlagOnY = undeformedCoordinates(flagOnY,:);

flagOffX = find(flag(:,1) == 0);
flagOffY = find(flag(:,2) == 0);

coordinatesFlagOffX = undeformedCoordinates(flagOffX,:);
coordinatesFlagOffY = undeformedCoordinates(flagOffY,:);

if NOD == 3
    
    flagOnZ = find(flag(:,3) == 1);
    coordinatesFlagOnZ = undeformedCoordinates(flagOnZ,:);
    
    flagOffZ = find(flag(:,3) == 0);
    coordinatesFlagOffZ = undeformedCoordinates(flagOffZ,:);
    
end 

if NOD == 2
    
    % Plot figure highlighting boundary conditions in X direction
    figure
    scatter(coordinatesFlagOnX(:,1), coordinatesFlagOnX(:,2), sz, 'r', 'filled');
    hold on
    scatter(coordinatesFlagOffX(:,1), coordinatesFlagOffX(:,2), sz, 'b', 'filled');
    axis equal
    xlabel('x')
    ylabel('y')
    grid off
    title('Applied boundary conditions in X direction')

    % Plot figure highlighting boundary conditions in Y direction
    figure
    scatter(coordinatesFlagOnY(:,1), coordinatesFlagOnY(:,2), sz, 'r', 'filled');
    hold on
    scatter(coordinatesFlagOffY(:,1), coordinatesFlagOffY(:,2), sz, 'b', 'filled');
    axis equal
    xlabel('x')
    ylabel('y')
    grid off
    title('Applied boundary conditions in Y direction')

elseif NOD == 3 
    
    % Plot figure highlighting boundary conditions in X direction
    figure
    scatter3(coordinatesFlagOnX(:,1), coordinatesFlagOnX(:,2), coordinatesFlagOnX(:,3), sz, 'r', 'filled');
    hold on
    figX = scatter3(coordinatesFlagOffX(:,1), coordinatesFlagOffX(:,2), coordinatesFlagOffX(:,3), sz, 'b', 'filled');
    figX.MarkerFaceAlpha = 0.2;
    axis equal
    xlabel('x')
    ylabel('y')
    zlabel('z')
    view(30,30)
    grid off
    title('Applied boundary conditions in X direction')

    % Plot figure highlighting boundary conditions in Y direction
    figure
    scatter3(coordinatesFlagOnY(:,1), coordinatesFlagOnY(:,2), coordinatesFlagOnY(:,3), sz, 'r', 'filled');
    hold on
    figY = scatter3(coordinatesFlagOffY(:,1), coordinatesFlagOffY(:,2), coordinatesFlagOffY(:,3), sz, 'b', 'filled');
    figY.MarkerFaceAlpha = 0.2;
    axis equal
    xlabel('x')
    ylabel('y')
    zlabel('z')
    view(30,30)
    grid off
    title('Applied boundary conditions in Y direction')

    % Plot figure highlighting boundary conditions in Z direction
    figure
    scatter3(coordinatesFlagOnZ(:,1), coordinatesFlagOnZ(:,2), coordinatesFlagOnZ(:,3), sz, 'r', 'filled');
    hold on
    figZ = scatter3(coordinatesFlagOffZ(:,1), coordinatesFlagOffZ(:,2), coordinatesFlagOffZ(:,3), sz, 'b', 'filled');
    figZ.MarkerFaceAlpha = 0.2;
    axis equal
    xlabel('x')
    ylabel('y')
    zlabel('z')
    view(30,30)
    grid off
    title('Applied boundary conditions in Z direction')
    
end

end 