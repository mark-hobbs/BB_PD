function [coordCrossSection, stretchCrossSection] = plotFPZ(undeformedCoordinates, BONDLIST, flag, stretch, sz, DX)
% plotFPZ - plot fracture process zone (FPZ)
%
% Syntax: plotFPZ(undeformedCoordinates, nodalDisplacement, nodalData, datalabel, sz, dsf)
%
% Inputs:
%   undeformedCoordinates - orignal underformed coordinates of all nodes (nNodes x NOD)
%   BONDLIST              -
%   flag                  - flag to indicate that softening damage has occured
%   stretch               -
%   sz                    - marker size
%
% Outputs:
%   figure                - output figure illustrating the FPZ
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

figure

for kBond = 1 : nBonds
    
    if flag(kBond, 1) == 1      

        nodei = BONDLIST(kBond,1); % Node i
        nodej = BONDLIST(kBond,2); % Node j

        pt1 = [undeformedCoordinates(nodei,1), undeformedCoordinates(nodei,2), undeformedCoordinates(nodei,3)];
        pt2 = [undeformedCoordinates(nodej,1), undeformedCoordinates(nodej,2), undeformedCoordinates(nodej,3)];
        pts = [pt1; pt2]; % vertical concatenation
                
        %if (0.03 < pt1(:,1) && pt1(:,1) < 0.14) && (0.03 < pt2(:,1) && pt2(:,1) < 0.14)  % remove damaged points at supports
            
        %   if pt1(:,3) < 0.04 && pt2(:,3) < 0.04                                         % remove damaged points at point of load application

                counter = counter + 1;
                midpt(counter,:) = [(pt1(1) + pt2(1))/2; (pt1(2) + pt2(2))/2; (pt1(3) + pt2(3))/2]; % Mid-point of a bond
                stretchReduced(counter,:) = stretch(kBond,1);

        %   end
            
        %end
        
        % plot3(pts(:,1), pts(:,2), pts(:,3), 'LineWidth', linewidth)
        % hold on
    
    end
    
end

crossSectionFlag = (midpt(:,2) > (DX * 2)) & (midpt(:,2) < (DX * 8)) == 1;   % Identify and flag nodes located in cross-section (X-Y Plane) (fine mesh (1.25 mm) - 15 < DX < 25) 
coordCrossSection = midpt(:,:);
stretchCrossSection = stretchReduced(:,:);

logicCondition1 = crossSectionFlag == 0;    % Delete node if it is not located in cross-section (flag == 0)
coordCrossSection(logicCondition1,:) = [];
stretchCrossSection(logicCondition1,:) = [];

scatter3(coordCrossSection(:,1), coordCrossSection(:,2), coordCrossSection(:,3), sz, stretchCrossSection, 'filled')

% scatter3(midpt(:,1), midpt(:,2), midpt(:,3), sz, stretchReduced, 'filled')
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

view(0,0)
axis equal
axis tight
colormap jet
caxis([min(stretchReduced) max(stretchReduced)])
set(gcf, 'Units', 'centimeters', 'Position', [2, 2, 12, 5], 'PaperUnits', 'centimeters', 'PaperSize', [12, 5])

% ----------------------- END CODE --------------------------------------

end