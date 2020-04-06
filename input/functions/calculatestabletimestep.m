function [DT] = calculatestabletimestep(nNodes, BONDLIST, cellVolume, DENSITY , c)
% Calculate stable time step - use stability condition derived by Silling &
% Askari (2005)

denominatorCriticalTimeStep = zeros(nNodes,1);
nBonds = size(BONDLIST,1);

for kBond = 1 : nBonds
    
    nodei = BONDLIST(kBond,1);
    nodej = BONDLIST(kBond,2);
    
    denominatorCriticalTimeStep(nodei) = denominatorCriticalTimeStep(nodei) + (cellVolume * c(kBond));
    denominatorCriticalTimeStep(nodej) = denominatorCriticalTimeStep(nodej) + (cellVolume * c(kBond));
        
end

numeratorCriticalTimeStep = 2 * DENSITY;

% Determine critical time step for every particle
criticalTimeStep = sqrt(numeratorCriticalTimeStep ./ denominatorCriticalTimeStep);

% The critical time step is the minimum value of criticaltimestep vector
DT = min(criticalTimeStep);

% 1.5573e-5 using this function
% 1.1296e-6 using previous equation

end 