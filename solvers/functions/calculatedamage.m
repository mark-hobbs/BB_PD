function [damage] = calculatedamage(bondlist, fail, nFAMILYMEMBERS)
% calculatedamage - Calculate the damage (percentage of bonds broken) for
% every node
%
% Syntax: [damage] = calculatedamage(bondlist,fail,nFAMILYMEMBERS)
%
% Inputs:
%   input1 -
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
% August 2019

% ---------------------------- BEGIN CODE ---------------------------------

% Initialise
nNodes = size(nFAMILYMEMBERS,1);
nBonds = size(bondlist,1);
damage = zeros(nNodes,1);
unbrokenBonds = zeros(nNodes,1);

for kBond = 1 : nBonds
    
    nodei = bondlist(kBond,1);
    nodej = bondlist(kBond,2);
    
    % Calculate the number of unbroken bonds attached to every node
    unbrokenBonds(nodei,1) = unbrokenBonds(nodei,1) + fail(kBond);
    unbrokenBonds(nodej,1) = unbrokenBonds(nodej,1) + fail(kBond);

end

damage(:,1) = 1 - (unbrokenBonds ./ nFAMILYMEMBERS(:,1)); % Calculate percentage of broken bonds attached to node i (1 would indicate that all bonds have broken)

% ----------------------------- END CODE ----------------------------------

end 