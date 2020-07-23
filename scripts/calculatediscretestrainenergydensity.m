function [strainenergydensityFA, strainenergydensityPA] = calculatediscretestrainenergydensity(BONDLIST, nNodes, c, s0, cellVolume, UNDEFORMEDLENGTH, VOLUMECORRECTIONFACTORS, horizon)


%% Constants

nBonds = size(BONDLIST, 1);

%% Main body 

strainenergydensityFA = zeros(nNodes,1); % Initialise array
strainenergydensityPA = zeros(nNodes,1);

for kBond = 1 : nBonds
    
    nodei = BONDLIST(kBond,1); % Node i
    nodej = BONDLIST(kBond,2); % Node j
    
    omega = 1 - (UNDEFORMEDLENGTH(kBond,1) / horizon);
    
    % =================================
    %               FA
    % =================================
    
    strainenergydensityFA(nodei,1) = strainenergydensityFA(nodei,1) + (((c * s0^2 * UNDEFORMEDLENGTH(kBond,1)) / 2 ) * cellVolume * 0.5 * omega);    % Half of the bond energy is associated with node i and half with node j 
    strainenergydensityFA(nodej,1) = strainenergydensityFA(nodej,1) + (((c * s0^2 * UNDEFORMEDLENGTH(kBond,1)) / 2 ) * cellVolume * 0.5 * omega);    
    
    % =================================
    %          PA - PDLAMMPS
    % =================================
    
    strainenergydensityPA(nodei,1) = strainenergydensityPA(nodei,1) + (((c * s0^2 * UNDEFORMEDLENGTH(kBond,1)) / 2 ) * cellVolume * VOLUMECORRECTIONFACTORS(kBond,1) * 0.5 * omega);   % Half of the bond energy is associated with node i and half with node j 
    strainenergydensityPA(nodej,1) = strainenergydensityPA(nodej,1) + (((c * s0^2 * UNDEFORMEDLENGTH(kBond,1)) / 2 ) * cellVolume * VOLUMECORRECTIONFACTORS(kBond,1) * 0.5 * omega); 
       
end

end

