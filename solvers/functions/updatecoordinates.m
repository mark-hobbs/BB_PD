function [deformedCoordinates,totalDisplacement,totalDisplacementVector] = updatecoordinates(undeformedCoordinates,deformedCoordinates,deltaDisplacementVector,unconstrainedDOF,constrainedDOF)
% updatecoordinates - this function reshapes the deltaDisplacement vector
% (nNodes x NOD, 1) into a matrix (nNodes, NOD). The deltaDisplacement
% vector must be re-shaped to make it compatible with undeformedCoordinates
% and deformedCoordinates (nNodes, NOD). The nodal coordinates are updated
% and output
%
% INPUT:
% COORDINATES(nNodes,NOD):- original underformed coordinates of all nodes
% deltaDisplacement(nNodes x NOD,1):- change in displacement in current iteration 

% OUPUT:
% displacedCoordinates(nNodes,NOD): - current deformed coordinates of all nodes
% totalDisplacement(nNodes,NOD):- total change in displacement
%
%
% Syntax: 
%
% Inputs:
%   undeformedCoordinates   -
%   deformedCoordinates     -
%   unconstrainedDOF        -
%   constrainedDOF          - 
% 
%
% Outputs:
%   deformedCoordinates     -
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
% June 2019

% ---------------------------- BEGIN CODE ---------------------------------

% Initialise constants
nNodes = size(undeformedCoordinates, 1);
NOD = size(undeformedCoordinates, 2);

% Re-shape the deltaDisplacement vector into a matrix
deltaDisplacementTemporary = zeros(nNodes * NOD, 1);
deltaDisplacementTemporary(unconstrainedDOF) = deltaDisplacementVector;    % Assign values in deltaDisplacement vector to correct position (unconstrainedDOF contains the index information)
deltaDisplacement = reshape(deltaDisplacementTemporary,NOD,[])';           % Re-shape (nNodes, NOD)


deformedCoordinates = deformedCoordinates + deltaDisplacement;     % Update coordinates
totalDisplacement = deformedCoordinates - undeformedCoordinates;
totalDisplacementVector = reshape(totalDisplacement',[],1);
totalDisplacementVector(constrainedDOF,:) = [];                    % Discard rows of constrained nodal DOFs

% ----------------------------- END CODE ----------------------------------

end

