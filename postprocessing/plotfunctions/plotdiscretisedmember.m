function plotdiscretisedmember(undeformedCoordinates, MATERIALFLAG)

% Seperate scatter data into sub sets: Concrete / Steel / Supports

% Concrete Nodes
COORDINATESCONCRETE = undeformedCoordinates(:,:);
LogicCondition1 = MATERIALFLAG(:,1) == 1; % If node is steel, delete from concrete sub set
COORDINATESCONCRETE(LogicCondition1,:) = [];

% Steel Nodes
COORDINATESSTEEL = undeformedCoordinates(:,:);
LogicCondition2 = MATERIALFLAG(:,1) == 0; % If node is concrete, delete from steel sub set
COORDINATESSTEEL(LogicCondition2,:) = [];

% Remove nodes in supports
% LogicCondition3 = COORDINATESSTEEL(:,2) <= 0;
% COORDINATESSTEEL(LogicCondition3,:) = [];

%% Plot figure

NOD = size(undeformedCoordinates,2);
sz1 = 5;
figure    

if NOD == 2
    
    % Plot concrete nodes
    scatter(COORDINATESCONCRETE(:,1), COORDINATESCONCRETE(:,2), sz1, 'b', 'filled');
    hold on

    % Plot steel nodes
    scatter(COORDINATESSTEEL(:,1), COORDINATESSTEEL(:,2), sz1, 'r', 'filled')
    axis equal
    xlabel('x')
    ylabel('y')
    grid off
    
elseif NOD == 3
    
    % Plot concrete nodes
    conc = scatter3(COORDINATESCONCRETE(:,1), COORDINATESCONCRETE(:,2), COORDINATESCONCRETE(:,3), sz1, 'b', 'filled');
    conc.MarkerFaceAlpha = 0.2;
    hold on

    % Plot steel nodes
    scatter3(COORDINATESSTEEL(:,1), COORDINATESSTEEL(:,2), COORDINATESSTEEL(:,3), sz1, 'r', 'filled')
    axis equal
    xlabel('x')
    ylabel('y')
    zlabel('z')
    view(30,30)
    grid off

    % Plot cross-section of beam in z-y plane
    sz2 = 100;
    figure;
    scatter(COORDINATESCONCRETE(:,2),COORDINATESCONCRETE(:,3),sz2,'b','filled');
    hold on
    scatter(COORDINATESSTEEL(:,2),COORDINATESSTEEL(:,3),sz2,'g','filled')
    hold off
    axis equal tight   

end


end 