function [DISCRETEVOLUME] = calculatediscretevolume(BONDLIST, VOLUMECORRECTIONFACTORS, cellVolume, nNodes)
% Calculate approximate discrete volume of every node


%% Constants

nBonds = size(BONDLIST, 1);

%% Main body of volume correction function

DISCRETEVOLUME = zeros(nNodes,1) + cellVolume;    % Initialise array

for kBond = 1 : nBonds
    
    nodei = BONDLIST(kBond,1); % Node i
    nodej = BONDLIST(kBond,2); % Node j
    
    DISCRETEVOLUME(nodei,1) = DISCRETEVOLUME(nodei,1) + (VOLUMECORRECTIONFACTORS(kBond) * cellVolume);
    DISCRETEVOLUME(nodej,1) = DISCRETEVOLUME(nodej,1) + (VOLUMECORRECTIONFACTORS(kBond) * cellVolume);
 
end


end