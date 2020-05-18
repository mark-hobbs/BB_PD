function [] = plotnodaldatacrosssection(undeformedCoordinates,nodalDisplacement,nodalData,DX,datalabel,sz,dsf)
% plotnodaldatacrosssection - plot nodal data on deformed shape. This functions plots a
% 4-D figure. The 4th dimension is color coded to represent the value of a
% variable at a point in 3-D space
%
% Syntax: plotnodaldatacrosssection(undeformedCoordinates,nodalDisplacement,nodalData,DX,datalabel,sz,dsf)
%
% Inputs:
%   undeformedCoordinates - orignal underformed coordinates of all nodes (nNodes x NOD)
%   nodalDisplacement     - displacement vector for every node (nNodes x NOD)
%   nodalData             - the 4th dimension (nodal data could be damage, stress, etc)
%   DX                    - grid spacing
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
% March 2020

% ----------------------- BEGIN CODE --------------------------------------


[coordCrossSection] = extractcrosssection(undeformedCoordinates, undeformedCoordinates, DX*8);
[dispCrossSection] = extractcrosssection(undeformedCoordinates, nodalDisplacement, DX*8);
[dataCrossSection] = extractcrosssection(undeformedCoordinates, nodalData, DX*8);

figure
scatter(coordCrossSection(:,1) + (dispCrossSection(:,1,1) * dsf), coordCrossSection(:,3) + (dispCrossSection(:,3,1) * dsf), sz, dataCrossSection, 'filled')
str = sprintf('%s', datalabel);
title(str)
axis equal
xlabel('x') % length
ylabel('y') % depth
colormap jet 
colorbar

% set(gca,'visible','off')
% set(gca,'xtick',[],'ytick',[])

% ----------------------- END CODE --------------------------------------

end