function [undeformedCoordinates,CONSTRAINTFLAG,MATERIALFLAG,BODYFORCEFLAG] = buildloadingplate(undeformedCoordinates,loadingPlateCentre,CONSTRAINTFLAG,MATERIALFLAG,BODYFORCEFLAG,X,Y,Z)
% buildloadingplate - build nodal points for a loading plate. The user
% defines the start and end position of the loading plate and the depth.
% The width is set to match the member under analysis.
%
% Syntax: 
%
% Inputs:
%   loadingPlateCentre  - Define the start position of the loading plate (define in metres)
%   CONSTRAINTFLAG
%   MATERIALFLAG
%   BODYFORCEFLAG
%
% Outputs:
%   loadingPlateCoordinates - Coordinates of nodes in the loading plate
%   CONSTRAINTFLAG
%   MATERIALFLAG
%   BODYFORCEFLAG
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

% ---------------------------- BEGIN CODE ---------------------------------

%% Load data
datageometry

constraintFlagCounter = size(CONSTRAINTFLAG,1);
materialFlagCounter = size(MATERIALFLAG,1);
bodyforceFlagCounter = size(BODYFORCEFLAG,1);

%% Main body of function

nDivDepthZ = 1; % Number of divisions in the loading plate along the z-axis (loading plate depth)

loadingPlateCentre = round(loadingPlateCentre/DX); % Define the loading plate centre as number of divisions along x-axis

% nDivSupportX = (loadingPlateEnd - loadingPlateStart)/DX; % Calculate the number of division in the loading plate along the x-axis
% nDivSupportX = round(nDivSupportX);                      % Round to nearest integer
% 
% startPosition = round(loadingPlateStart/DX); % Determine the start position for the x loop
% 
% if startPosition == 0
%     
%     startPosition = 1; % if the start position is 0, set to 1
%     
% end

counter = 0; % Initiate counter

for k3 = (nDivZ + 1) : (nDivZ + nDivDepthZ)
    
    for k2 = 1 : nDivY 
        
        for k1 = (loadingPlateCentre - 1) : (loadingPlateCentre + 1)
            
            coordx = DX * k1;
            coordy = DX * k2;
            coordz = DX * k3;
            
            counter = counter + 1;
            constraintFlagCounter = constraintFlagCounter + 1;
            materialFlagCounter = materialFlagCounter + 1;
            bodyforceFlagCounter = bodyforceFlagCounter + 1;
            
            loadingPlateCoordinates(counter,1) = coordx;
            loadingPlateCoordinates(counter,2) = coordy;  
            loadingPlateCoordinates(counter,3) = coordz;
            
            CONSTRAINTFLAG(constraintFlagCounter,:) = 0;
            MATERIALFLAG(materialFlagCounter,:) = 0;        % Loading plate material = steel
            BODYFORCEFLAG(bodyforceFlagCounter,1) = X;      % Applied force in X direction
            BODYFORCEFLAG(bodyforceFlagCounter,2) = Y;      % Applied force in Y direction
            BODYFORCEFLAG(bodyforceFlagCounter,3) = Z;      % Applied force in Z direction
            
        end
         
    end
    
end

% Append coordinates of loading plate to undeformedCoordinates
undeformedCoordinates((end + 1):(end + 1) + (size(loadingPlateCoordinates,1) - 1),:) = loadingPlateCoordinates;

% ----------------------------- END CODE ----------------------------------

end
