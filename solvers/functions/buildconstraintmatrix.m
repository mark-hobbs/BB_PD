function [C] = buildconstraintmatrix(nNodes, NOD, applieddisplacementDOF, constrainedDOF)
% buildconstraintmatrix - Following Algorithm 58 in Nonlinear Finite
% Element Analysis of Solids and Structures, 2nd Edition René de Borst,
% Mike A. Crisfield, Joris J. C. Remmers, Clemens V. Verhoosel
%
% Syntax: 
%
% Inputs:
%   nodalCoordinates   - undeformed or deformed nodalCoordinates of all nodes (nNodes x NOD)
%
%
% Outputs:
%   C                  - constraint matrix
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
% June 2020

% ----------------------- BEGIN CODE --------------------------------------

%% Initialise arrays and constants

nDOF = nNodes * NOD;                                     % Total number of degrees of freedom
applieddisplacementDOF = [applieddisplacementDOF; constrainedDOF];
C = zeros(nDOF, nDOF - size(applieddisplacementDOF,1));  % Initialise constraint matrix

%% Build the constraint matrix

j = 1;

for i = 1 : nDOF
    
    if ismember(i, applieddisplacementDOF) == 1
        
        continue
        
    end
    
    C(i,j) = 1;
    j = j + 1;
                
end

% ------------------------- END CODE --------------------------------------

end

