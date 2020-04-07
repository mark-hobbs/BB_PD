function [shearForce,averageShearForce] = calculateshearforce(undeformedCoordinates,stressTensor)
% calculateshearforce - Calculate the shear force along the length (x-axis) of the member
%
% Syntax: [shearForce,averageShearForce] = calculateshearforce(undeformedCoordinates,stressTensor)
%
% Inputs:
%   input1  - 
%
% Outputs:
%   output1 - 
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
shearForce = zeros(nDivX,1);

for i = 1 : nDivX % Loop the member length
    
    crossSectionFlag = (undeformedCoordinates(:,1) == nodalCoordinatesX(i,1)) == 1; % Identify and flag all nodes within cross-sectional plane Y-Z
    stressCrossSection = stressTensor(:,:,:);                                       % initialise stressCrossSection in every iteration
    logicCondition1 = crossSectionFlag == 0;                                        % delete node if it is not located in cross-sectional plane Y-Z (flag == 0)
    stressCrossSection(logicCondition1,:) = [];                                     % this line re-organises the 3 x 3 stress matrix into a 1 x 9 row
   
    % Calculate the shear force along the member length - 
    % Shear Force = average shear stress (N/m^2) * cross-sectional area (m^2)
    % shearForce(i,1) = (sum(stressCrossSection(:,3)) / size(coordCrossSection,1)) * (WIDTH * HEIGHT); % This method leads to large errors
    
    % Calculate the shear force along the member length - use trapezoidal
    % numerical integration to improve the accuracy
    FF = reshape(stressCrossSection(:,3), nDivY, nDivZ);    % Shear force at every node in Y-Z plane (array size: nDivY * nDivZ)
    shearForce(i,1) = trapz(nodalCoordinatesY, trapz(nodalCoordinatesZ, FF, 2));
    
end

averageShearForce = mean(-shearForce);

% --------------------------- END CODE ------------------------------------

end

