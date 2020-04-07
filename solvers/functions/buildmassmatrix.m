function [massVector] = buildmassmatrix(nNodes, DX, bondStiffnessConcrete, DT, nFAMILYMEMBERS)
% buildmassmatrix - Determine diagonal coefficients of the fictitious
% density matrix (sometimes referred to as modified density). There are
% many methods avilable for building the density matrix but one of the most
% common methods is based on Greshgorin's theorem.
%
% Syntax: 
%
% Inputs:
%   input1  - 
% 
% Outputs:
%   massMatrix - (nNodes,NOD)
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
% August 2019

% ---------------------------- BEGIN CODE ---------------------------------

% This needs work. The equation for Kij is problem specific. Need to make
% it more general. This function could move to the input module.

for kNode = 1 : nNodes

    Kij = (nFAMILYMEMBERS(kNode,1) * DX^2) * (bondStiffnessConcrete / DX); % neighbourhood volume * bond stiffness / DX

    massMatrixConstant = 0.25 * DT^2 * Kij;

    massVector(kNode,1) = massMatrixConstant;

end

% ----------------------------- END CODE ----------------------------------

end

