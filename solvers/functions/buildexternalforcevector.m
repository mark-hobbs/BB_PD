function [Fext] = buildexternalforcevector(BODYFORCEFLAG,MAXBODYFORCE,cellVolume,constrainedDOF)
% buildexternalforcevector - 
%
% Syntax: 
%
% Inputs:
%   input1  - 
% 
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
% June 2019

% ---------------------------- BEGIN CODE ---------------------------------

% External force vector 
Fext = reshape(BODYFORCEFLAG',[],1);        % Re-shape BODYFORCEFLAG (nNodes, NOD) into a single column (nNodes x NOD, 1)
Fext = Fext * MAXBODYFORCE * cellVolume;    % External force vector (nNodes x NOD, 1)
Fext(constrainedDOF,:) = [];                % Discard rows of constrained nodal DOFs

% ----------------------------- END CODE ----------------------------------

end

