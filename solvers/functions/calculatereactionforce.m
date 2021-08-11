function [reactionForce] = calculatereactionforce(undeformedCoordinates,stressTensor,probeLocation)
% calculatereactionforce - Calculate the reaction force on a plane. The
% concept of this function is based on force reaction probes in Ansys. 

% Syntax: [reactionForce] = calculatereactionforce(undeformedCoordinates,stressTensor)
%
% Inputs:
%   undeformedCoordinates  - orignal underformed coordinates of all nodes (nNodes, NOD)
%   stressTensor           - stress tensor at every node (nNodes, NOD, NOD)
%   probeLocation          - location of the reaction force probe (specify the number of 
%                            division along the x-axis. probeLocation must be an integer)
%
% Outputs:
%   reactionForce          - reaction force on a plane 
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

% ---------------------------- BEGIN CODE ---------------------------------

% Initialise
nodalCoordinatesX = unique(undeformedCoordinates(:,1)); % find unique nodal coordinates in x-axis
nodalCoordinatesY = unique(undeformedCoordinates(:,2)); % find unique nodal coordinates in y-axis
nodalCoordinatesZ = unique(undeformedCoordinates(:,3)); % find unique nodal coordinates in z-axis
nDivX = size(nodalCoordinatesX,1); % number of division in x-axis
nDivY = size(nodalCoordinatesY,1); % number of division in y-axis
nDivZ = size(nodalCoordinatesZ,1); % number of division in z-axis
   
crossSectionFlag = (undeformedCoordinates(:,1) == nodalCoordinatesX(probeLocation,1)) == 1; % Identify and flag all nodes within cross-sectional plane Y-Z
stressCrossSection = stressTensor(:,:,:);                                                   % initialise stressCrossSection in every iteration
logicCondition1 = crossSectionFlag == 0;                                                    % delete node if it is not located in cross-sectional plane Y-Z (flag == 0)
stressCrossSection(logicCondition1,:) = [];                                                 % this line re-organises the 3 x 3 stress matrix into a 1 x 9 row

% Calculate the shear force over a plane - use trapezoidal numerical
% integration to improve the accuracy
FF = reshape(stressCrossSection(:,3), nDivY, nDivZ);    % Shear force in Y-Z plane (array size: nDivY * nDivZ)
reactionForce = trapz(nodalCoordinatesY, trapz(nodalCoordinatesZ, FF, 2));
    
% --------------------------- END CODE ------------------------------------

end

