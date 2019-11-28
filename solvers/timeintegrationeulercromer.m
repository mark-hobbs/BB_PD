function [nodalDisplacementForward,nodalVelocityForward,deformedCoordinates,nodalDisplacementDT] = timeintegrationeulercromer(nodalForce,nodalDisplacement,nodalVelocity,DAMPING,DENSITY,CONSTRAINTFLAG,undeformedCoordinates,DT,BODYFORCEFLAG,loadingMethod,displacementIncrement)
% timeintegrationeulercromer - Time integration using Euler-Cromer algorithm
% See https://www.compadre.org/PICUP/resources/Numerical-Integration/ for
% info on the Euler-Cromer algorithm and other methods for integrating
% Newton's second law of motion.
%
%
% Syntax: [nodalDisplacement,nodalVelocity,deformedCoordinates,nodalDisplacementDT] = timeintegrationeulercromer(nodalForce,nodalDisplacement,nodalVelocity,DAMPING,DENSITY,CONSTRAINTFLAG,undeformedCoordinates,DT)
%
% Inputs:
%   nodalForce            - force on every node with units of N/m^3 (nNodes, NOD)
%   nodalDisplacement     - displacement vector for every node at time t (nNodes, NOD)
%   nodalVelocity         - velocity vector for every node at time t (nNodes, NOD)
%   DAMPING               - damping constant (1 , 1)
%   DENSITY               - material density of every node (nNodes , 1)
%   CONSTRAINTFLAG        - boundary condition constraints for every node (nNodes, NOD)
%   undeformedCoordinates - orignal underformed coordinates of all nodes (nNodes, NOD)
%   DT                    - time step size (1, 1)
%   BODYFORCEFLAG         - boundary condition applied load/displacement(nNodes, NOD)
%   loadingMethod         - check if displacement controlled loading is on (string)
%   displacementIncrement - define the applied displacement increment if displacement controlled loading is on
%
% Outputs:
%   nodalDisplacementForward  - displacement vector for every node at time t + 1dt (nNodes, NOD)
%   nodalVelocityForward      - velocity vector for every node at time t + 1dt (nNodes, NOD)
%   deformedCoordinates       - 
%   nodalDisplacementDT       - 
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

% ----------------------- BEGIN CODE --------------------------------------

nodalAcceleration(:,:) = (nodalForce(:,:) - DAMPING * nodalVelocity(:,:)) ./ DENSITY(:,:);         % Acceleration for time:-   tt

nodalAcceleration(CONSTRAINTFLAG == 1) = 0;                                                        % Apply boundary conditions - constraints

nodalVelocityForward(:,:) = nodalVelocity(:,:) + (nodalAcceleration(:,:) * DT);                    % Velocity for time:-       tt + 1dt

nodalDisplacementDT(:,:) = nodalVelocityForward(:,:) * DT;                                         % Nodal displacement during current time step

nodalDisplacementForward(:,:) = nodalDisplacement(:,:) + nodalDisplacementDT(:,:);                 % Displacement for time:-   tt + 1dt

% if strcmp(loadingMethod ,'displacementControlled')                                                 % check if displacement controlled loading is on
% 
%     nodalDisplacementForward(BODYFORCEFLAG == 1) = displacementIncrement;                          % Apply boundary conditions - applied displacement
% 
% end

deformedCoordinates(:,:) = undeformedCoordinates(:,:) + nodalDisplacementForward(:,:);             % Deformed coordinates of all nodes

% --------------
% Optimised Code
% --------------

% nodalAcceleration(:,:) = (nodalForce(:,:) - DAMPING * nodalVelocity(:,:)) ./ DENSITY(:,:);                      % Acceleration for time:-   tt
% 
% nodalAcceleration(CONSTRAINTFLAG == 1) = 0;                                                                     % Apply boundary conditions - constraints
% 
% nodalVelocity(:,:) = nodalVelocity(:,:) + (nodalAcceleration(:,:) * DT);                                        % Velocity for time:-       tt + 1dt
% 
% deformedCoordinates(:,:) = undeformedCoordinates(:,:) + nodalDisplacement(:,:) +  (nodalVelocity(:,:) * DT);    % Deformed coordinates of all nodes

% ------------------------ END CODE ---------------------------------------

end

