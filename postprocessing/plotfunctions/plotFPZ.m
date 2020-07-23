function [] = plotFPZ(undeformedCoordinates,BONDLIST,flag,stretch,linewidth)
% plotFPZ - plot fracture process zone (FPZ)
%
% Syntax: plotFPZ(undeformedCoordinates, nodalDisplacement, nodalData, datalabel, sz, dsf)
%
% Inputs:
%   undeformedCoordinates - orignal underformed coordinates of all nodes (nNodes x NOD)
%   nodalDisplacement     - displacement vector for every node (nNodes x NOD)
%   nodalData             - the 4th dimension (nodal data could be damage, stress, etc)
%   datalabel             - title of output figure
%   sz                    - marker size
%   dsf                   - displacement scale factor
%
% Outputs:
%   figure                - output 4-D figure with nodal data plot on deformed nodes
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none
%
% Mark Hobbs 
% mch61@cam.ac.uk
% Department of Engineering
% Cambridge University
% May 2019

% ----------------------- BEGIN CODE --------------------------------------

nBonds = size(BONDLIST,1);

counter = 0;

for kBond = 1 : nBonds
    
    if flag(kBond, 1) == 1
        
        counter = counter + 1;

        nodei = BONDLIST(kBond,1); % Node i
        nodej = BONDLIST(kBond,2); % Node j


        pt1 = [undeformedCoordinates(nodei,1), undeformedCoordinates(nodei,2), undeformedCoordinates(nodei,3)];
        pt2 = [undeformedCoordinates(nodej,1), undeformedCoordinates(nodej,2), undeformedCoordinates(nodej,3)];
        pts = [pt1; pt2]; % vertial concatenation

        midpt(counter,:) = [(pt1(1) + pt2(1))/2; (pt1(2) + pt2(2))/2; (pt1(3) + pt2(3))/2]; % Mid-point of a bond
        stretchReduced(counter,:) = stretch(kBond,1);

        % plot3(pts(:,1), pts(:,2), pts(:,3), 'LineWidth', linewidth)
        % hold on
    
    end
    
end

scatter3(midpt(:,1), midpt(:,2), midpt(:,3), 20, abs(stretchReduced), 'filled')
x_max = max(undeformedCoordinates(:,1));
y_max = max(undeformedCoordinates(:,2));
z_max = max(undeformedCoordinates(:,3));
x_min = min(undeformedCoordinates(:,1));
y_min = min(undeformedCoordinates(:,2));
z_min = min(undeformedCoordinates(:,3));
plotcube([x_max - x_min y_max - y_min z_max - z_min],[x_min y_min z_min],0,1.5)
set(gca,'XTick',[], 'YTick', [], 'ZTick', [])
set(gca,'XTickLabel',[], 'YTickLabel', [], 'ZTickLabel', [])
set(gca,'visible','off')
% xlabel('x', 'interpreter', 'latex')
% ylabel('y', 'interpreter', 'latex')
% zlabel('z', 'interpreter', 'latex')

axis equal
colormap(jet)

% ----------------------- END CODE --------------------------------------

end