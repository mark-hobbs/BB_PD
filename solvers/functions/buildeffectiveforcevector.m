function [globaleffectiveF] = buildeffectiveforcevector(nNodes, NOD, localeffectiveF, applieddisplacementDOF, constrainedDOF, Fext)
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
% July 2020

% ---------------------------- BEGIN CODE ---------------------------------

globaleffectiveF = Fext; % zeros(nNodes * NOD, 1);
globaleffectiveF(applieddisplacementDOF,:) = localeffectiveF; % Fext(applieddisplacementDOF,:) - localeffectiveF
%globaleffectiveF(constrainedDOF,:) = [];    % Discard rows of constrained nodal DOFs

% ----------------------------- END CODE ----------------------------------

end

