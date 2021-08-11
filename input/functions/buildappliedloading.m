function [BODYFORCEFLAG] = buildappliedloading(BODYFORCEFLAG,appliedForceCentre,X,Y,Z)
% buildappliedloading - directly apply external loads to nodes within the
% main body
%
% Syntax: 
%
% Inputs:
%   BODYFORCEFLAG
%   appliedForceCentre  - Define the start position of the loading plate (define in metres)
%
% Outputs:
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


%% Main body of function

appliedForceCentre = round(appliedForceCentre/DX); % Define the loading plate centre as number of divisions along x-axis

% -------------------------------- 2D -------------------------------------

if NOD == 2
    

% -------------------------------- 3D -------------------------------------
    
elseif NOD == 3
    
    counter = 0;    % Initiate counter

    for k3 = 1 : nDivZ  % depth 

        for k2 = 1 : nDivY  % width

            for k1 = 1 : nDivX  % length

                counter = counter + 1;

                if k3 > (nDivZ - 2) && ((appliedForceCentre - 1) <= k1) && (k1 <= (appliedForceCentre + 1))

                    BODYFORCEFLAG(counter,1) = X;      % Applied force in X direction
                    BODYFORCEFLAG(counter,2) = Y;      % Applied force in Y direction
                    BODYFORCEFLAG(counter,3) = Z;      % Applied force in Z direction

                end

            end

        end

    end
    
        
end
% ----------------------------- END CODE ----------------------------------

end
