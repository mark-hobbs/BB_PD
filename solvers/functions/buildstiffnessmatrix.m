function [Kglobal] = buildstiffnessmatrix(nodalCoordinates,BONDLIST,VOLUMECORRECTIONFACTORS,cellVolume,BONDSTIFFNESS,BFMULTIPLIER,fail,bondSofteningFactor,constrainedDOF,UNDEFORMEDLENGTH)
% buildstiffnessmatrix - This code is based on Algorithm A.2 from
% 'Structural Material Damage: Novel Methods of Analysis' and David
% Miranda's code for calculation of the stiffness/tangent matrix for BB PD
% via assemblage technique (direct stiffness method). 
% 
% Could be achieved by central finite difference Based on Section 4 from
% 'Roadmap for Peridynamic Software Implementation' and Algorithm 3 from
% 'Implementation of Peridynamics utilizing HPX- the C++ standard library
% for parallelism and concurrency'
%
% The tangent stiffness matrix for a nonlocal model contains nonzero
% entries for each pair of nodes that interact directly, and is inherently
% more dense than that of a local model. 
%
% Syntax: [Kglobal] = buildstiffnessmatrix(nodalCoordinates,BONDLIST,VOLUMECORRECTIONFACTORS,cellVolume,BONDSTIFFNESS,BFMULTIPLIER,fail,bondSofteningFactor,constrainedDOF,UNDEFORMEDLENGTH)
% [Kglobal,Kuu,Kuc] = buildstiffnessmatrix(nodalCoordinates,BONDLIST,VOLUMECORRECTIONFACTORS,cellVolume,BONDSTIFFNESS,BFMULTIPLIER,fail,bondSofteningFactor,constrainedDOF,noapplieddisplacementDOF,UNDEFORMEDLENGTH,DISPLACEMENTFLAG)
% Inputs:
%   nodalCoordinates            - undeformed or deformed nodalCoordinates of all nodes (nNodes x NOD)
%   BONDLIST
%   VOLUMECORRECTIONFACTORS
%   VOLUME
%   BONDSTIFFNESS
%   BFMULTIPLIER
%   CONSTRAINTFLAG              - boundary condition constraints for every node (nNodes x NOD)
%   BODYFORCEFLAG               - boundary condition applied load/displacement(nNodes x NOD)
%   MAXBODYFORCE
%   fail

%
% Outputs:
%   Kglobal                     - global stiffness matrix (nNodes x NOD, nNodes x NOD)
%   Fext                        - applied external force vector (nNodes x NOD, 1)
%   unconstrainedDOF            - unconstrained nodal degrees of freedom
%   constrainedDOF              - constrained nodal degrees of freedom
%   appliedExternalForceIndex   - 
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

%% Initialise arrays and constants

nNodes = size(nodalCoordinates, 1);
NOD = size(nodalCoordinates, 2);

%% Build the stiffness matrix using the compressed sparse column (CSC) format

[globalRowIndex, globalColumnIndex, globalNonZeroValues, ~] = buildstiffnessmatrixCSCformat(nodalCoordinates,BONDLIST,VOLUMECORRECTIONFACTORS,cellVolume,BONDSTIFFNESS,BFMULTIPLIER,fail,bondSofteningFactor,UNDEFORMEDLENGTH);

%% Create sparse global stiffness matrix

Kglobal = sparse(globalRowIndex, globalColumnIndex, globalNonZeroValues, nNodes * NOD, nNodes * NOD); % This function accumulates values that have identical subscripts

%% Reduce the stiffness matrix (application of boundary conditions)
% Remove columns and rows corresponding to known values (constrained DOFs)

Kglobal(constrainedDOF,:) = [];     % Discard rows of constrained nodal DOFs
Kglobal(:,constrainedDOF) = [];     % Discard columns of constrained nodal DOFs

% Kuu = Kglobal;
% Kuc = Kglobal;
% 
% Kuu(constrainedDOF,:) = [];     % Discard rows of constrained nodal DOFs
% Kuu(:,constrainedDOF) = [];     % Discard columns of constrained nodal DOFs
% 
% Kuc(noapplieddisplacementDOF,:) = [];     % Discard rows of unconstrained nodal DOFs
% Kuc(:,noapplieddisplacementDOF) = [];     % Discard columns of unconstrained nodal DOFs

% ------------------------- END CODE --------------------------------------

end

