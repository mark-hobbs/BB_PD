function [] = plotnodaldata(undeformedCoordinates,nodalDisplacement,nodalData,datalabel,sz,dsf)
% plotnodaldata - plot nodal data on deformed shape. This functions plots a
% 4-D figure. The 4th dimension is color coded to represent the value of a
% variable at a point in 3-D space
%
% Syntax: plotnodaldata(undeformedCoordinates,nodalDisplacement,nodalData,datalabel)
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

NOD = size(undeformedCoordinates,2);

if NOD == 2
    
    % figure
    scatter(undeformedCoordinates(:,1) + (nodalDisplacement(:,1) * dsf), undeformedCoordinates(:,2) + (nodalDisplacement(:,2) * dsf), sz, nodalData, 'filled')
    xlabel('x (1)')
    ylabel('y (2)')
    str = sprintf('%s', datalabel);
    title(str)
    axis equal
    colormap jet 
    colorbar
    
elseif NOD == 3
    
    % figure
    scatter3(undeformedCoordinates(:,1) + (nodalDisplacement(:,1) * dsf), undeformedCoordinates(:,2) + (nodalDisplacement(:,2) * dsf), undeformedCoordinates(:,3) + (nodalDisplacement(:,3) * dsf), sz, nodalData, 'filled')
    xlabel('x (1)')
    ylabel('y (2)')
    zlabel('z (3)')
    str = sprintf('%s', datalabel);
    title(str)
    view(30,30)  % View in 3D
    axis equal
    colormap jet 
    colorbar
    
end

% ----------------------- END CODE --------------------------------------

end