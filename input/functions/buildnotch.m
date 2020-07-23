function [BONDLIST, UNDEFORMEDLENGTH] = buildnotch(undeformedCoordinates, BONDLIST, UNDEFORMEDLENGTH, DX, xlocation, depth)

nBonds = size(BONDLIST,1);

x_max = max(undeformedCoordinates(:,1));
y_max = max(undeformedCoordinates(:,2));
z_max = max(undeformedCoordinates(:,3));
x_min = min(undeformedCoordinates(:,1));
y_min = min(undeformedCoordinates(:,2));
z_min = min(undeformedCoordinates(:,3));

A = [xlocation*DX y_min z_min];
B = [xlocation*DX y_max z_min];
C = [xlocation*DX y_max depth*DX];
D = [xlocation*DX y_min depth*DX];

counter = 0;

for kBond = 1 : nBonds  % Determine if a bond intersects with the defined notch
    
    nodei = BONDLIST(kBond,1); % Node i
    nodej = BONDLIST(kBond,2); % Node j
    
    [intersection] = determineintersection(A, B, C, D, undeformedCoordinates(nodei,:), undeformedCoordinates(nodej,:));
    
    if intersection == 1
        
        counter = counter + 1;
        reducedBL(counter,:) = [nodei, nodej];
        delete(counter,:) = kBond;
                
    end
        
        
end


for kBond = 1 : size(reducedBL,1)   % Plot all bonds that intersect with the defined notch

    nodei = reducedBL(kBond,1); % Node i
    nodej = reducedBL(kBond,2); % Node j
    
    % Plot bond
    pt1 = [undeformedCoordinates(nodei,1), undeformedCoordinates(nodei,2), undeformedCoordinates(nodei,3)];
    pt2 = [undeformedCoordinates(nodej,1), undeformedCoordinates(nodej,2), undeformedCoordinates(nodej,3)];
    pts = [pt1; pt2]; % vertial concatenation
    plot3(pts(:,1), pts(:,2), pts(:,3), 'LineWidth', 0.75)
    
    hold on     
    

end


plot3( [A(1) B(1) C(1) D(1) A(1)], [A(2) B(2) C(2) D(2) A(2)], [A(3) B(3) C(3) D(3) A(3)], 'Color', 'k', 'LineWidth', 2 )
plotcube([(x_max - DX) (y_max - DX) (z_max - DX)],[x_min x_min x_min],0,1.5)
set(gca,'XTick',[], 'YTick', [], 'ZTick', [])
set(gca,'XTickLabel',[], 'YTickLabel', [], 'ZTickLabel', [])
% set(gca,'visible','off')
xlabel('x', 'interpreter', 'latex')
ylabel('y', 'interpreter', 'latex')
zlabel('z', 'interpreter', 'latex')
axis equal

BONDLIST(delete,:) = []; % Delete bonds that cross the notch
UNDEFORMEDLENGTH(delete,:) = [];  

end
