function [undeformedCoordinates,CONSTRAINTFLAG,MATERIALFLAG,BODYFORCEFLAG] = buildsupports(supportCentre,DX,nDivX,nDivY,nDivZ,undeformedCoordinates,CONSTRAINTFLAG,MATERIALFLAG,BODYFORCEFLAG,X,Y,Z)
% buildsupports - build supports for simply supported members. Create a
% triangular support with 3 rows of nodes at the top, 2 rows of nodes in
% the middle, and 1 row of nodes at the apex. Define the support centre
% (apex) as number of divisions (DX) along the member length. The width is
% set to match the width of the member under analysis.
%
% Support Top Row:                  O - O - O
% Support Middle Row:                 O - O
% Support Bottom Row:                   O
%
% Syntax: 
%
% Inputs:
%   supportCentre  - Define the centre of the support (apex) (define in metres)
%   CONSTRAINTFLAG
%   MATERIALFLAG
%   BODYFORCEFLAG
%
% Outputs:
%   supportCoordinates - Coordinates of nodes in the supports
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

%% Load and initialise data
constraintFlagCounter = size(CONSTRAINTFLAG,1);
materialFlagCounter = size(MATERIALFLAG,1);
bodyforceFlagCounter = size(BODYFORCEFLAG,1);
NOD = size(CONSTRAINTFLAG, 2);

%% Main body of function

supportCentre = round(supportCentre/DX); % Define the support centre as number of divisions along x-axis

% -------------------------------- 2D -------------------------------------

if NOD == 2
    

% -------------------------------- 3D -------------------------------------   

elseif NOD == 3
    
    nDivDepthZ = 3;             % Number of divisions in the support along the z-axis (support depth)
    counter = 0;                % Initiate counter
    
    reduceRowsCounter = -1;     % Counter used to reduce the number of rows at every level in the support
    xShift = -1;                % Shift middle row and bottom row along the x-axis to create a triangular support
   
    for k3 = 1 : nDivDepthZ     % Support depth

       reduceRowsCounter = reduceRowsCounter + 1; % reduce the number of rows of nodes by 1 at every level in the support 
       xShift = xShift + 1;
       
        for k2 = 1 : nDivY 
            

            for k1 = (supportCentre - 1) : (supportCentre + 1 - reduceRowsCounter) % Support length

                coordx = (DX * k1) + (DX/2 * xShift);  
                coordy = DX * k2; 
                coordz = - DX * (k3 - 1);
                
                counter = counter + 1;
                constraintFlagCounter = constraintFlagCounter + 1;
                materialFlagCounter = materialFlagCounter + 1;
                bodyforceFlagCounter = bodyforceFlagCounter + 1;

                supportCoordinates(counter,1) = coordx;
                supportCoordinates(counter,2) = coordy; 
                supportCoordinates(counter,3) = coordz;

                if k3 == nDivDepthZ   % only constrain nodes in apex of the support

                    CONSTRAINTFLAG(constraintFlagCounter,1) = X;      % Constrained in X direction
                    CONSTRAINTFLAG(constraintFlagCounter,2) = Y;      % Constrained in Y direction
                    CONSTRAINTFLAG(constraintFlagCounter,3) = Z;      % Constrained in Z direction

                else                  % do not constrain

                    CONSTRAINTFLAG(constraintFlagCounter,1) = 0;      % Free to move in X direction
                    CONSTRAINTFLAG(constraintFlagCounter,2) = 0;      % Free to move in Y direction
                    CONSTRAINTFLAG(constraintFlagCounter,3) = 0;      % Free to move in Z direction

                end

                MATERIALFLAG(materialFlagCounter,:) = 1;            % Support material = steel
                BODYFORCEFLAG(bodyforceFlagCounter,:) = 0;          % No applied force

            end

        end

    end
    
    
end

% Append coordinates of support nodes to undeformedCoordinates
undeformedCoordinates((end + 1):(end + 1) + (size(supportCoordinates,1) - 1),:) = supportCoordinates;

% ----------------------------- END CODE ----------------------------------

end
