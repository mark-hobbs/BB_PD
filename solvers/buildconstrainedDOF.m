function [constrainedDOF, unconstrainedDOF] = buildconstrainedDOF(CONSTRAINTFLAG)
% buildconstrainedDOF - build nodal constraint boundary conditions into the
% form required for the calculation of the static solution. Return two
% vectors containing row-indices of constrained and unconstrained DOFs
%
% Syntax: [constrainedDOF, unconstrainedDOF] = buildconstrainedDOF(CONSTRAINTFLAG)
%
% Inputs:
%   CONSTRAINTFLAG - boundary condition constraints for every node (nNodes, NOD)
% 
%
% Outputs:
%   constrainedDOF - vector containing all constrained DOFs
%   unconstrainedDOF - vector containing all unconstrained DOFs
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

%% Nodal displacement constraints

% CONSTRAINTFLAG == 1 represents a constrained nodal DOF, 
% CONSTRAINTFLAG == 0 represents an unconstrained nodal DOF

constraints = reshape(CONSTRAINTFLAG',[],1);    % Re-shape rows into a single column (nNodes x NOD, 1)
constrainedDOF = find(constraints == 1);        % Find row-indices of constrained nodal DOFs 
unconstrainedDOF = find(constraints == 0);      % Find row-indices of unconstrained nodal DOFs

% ----------------------------- END CODE ----------------------------------

end

