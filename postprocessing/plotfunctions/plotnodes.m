function [] = plotnodes(undeformedCoordinates, datalabel, markerSize, azimuth, elevation)
% plotnodes - plot nodes
%
% Syntax: [] = plotnodes(undeformedCoordinates, datalabel, markerSize, azimuth, elevation)
%
% Inputs:
%   undeformedCoordinates - orignal underformed coordinates of all nodes (nNodes x NOD)
%   datalabel             - title of output figure
%   markerSize            - size of markers (nodes) in plot
%   azimuth               - specified as an angle in degrees from the negative y-axis
%   elevation             - specified as the angle in degrees between the line of sight and the x-y plane
%
% Outputs:
%   figure                - output 2D/3D figure showing the configuration of
%                           undeformed nodes
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
% July 2019

% ----------------------- BEGIN CODE --------------------------------------

NOD = size(undeformedCoordinates,2);

if NOD == 2
    
    figure
    scatter(undeformedCoordinates(:,1), undeformedCoordinates(:,2), markerSize,'b','filled')
    xlabel('x (1)')
    ylabel('y (2)')
    str = sprintf('%s', datalabel);
    title(str)
    axis equal
    
elseif NOD == 3
    
    figure
    scatter3(undeformedCoordinates(:,1), undeformedCoordinates(:,2), undeformedCoordinates(:,3), markerSize,'b','filled')
    xlabel('x (1)')
    ylabel('y (2)')
    zlabel('z (3)')
    view(azimuth,elevation)
    str = sprintf('%s', datalabel);
    title(str)
    axis equal
    
end

% ----------------------- END CODE --------------------------------------

end