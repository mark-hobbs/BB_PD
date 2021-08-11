function [MAXBODYFORCE] = calculateappliedbodyforce(BODYFORCEFLAG,appliedLoad,cellVolume)
% calculateappliedbodyforce - determine the applied nodal body force
%
% Syntax: 
%
% Inputs:
%   BODYFORCEFLAG    -
%   appliedLoad      -
%   cellVolume       -
%
% Outputs:
%   MAXBODYFORCE    - 
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

nLoadedCells = find(BODYFORCEFLAG(:,:) == 1); 
nLoadedCells = size(nLoadedCells,1);  % Determine the number of nodes subjected to applied external forces

MAXBODYFORCE = appliedLoad / (cellVolume * nLoadedCells);

% ----------------------------- END CODE ----------------------------------

end

