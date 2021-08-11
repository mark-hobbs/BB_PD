function [strainEnergy,nodalStrainEnergyDensity] = calculatestrainenergy(nNodes,fail,BONDSTIFFNESS,BFMULTIPLIER,stretch,UNDEFORMEDLENGTH,VOLUMECORRECTIONFACTORS,BONDLIST,cellVolume)
% calculatestrainenergy - calculate the strain energy density at every node

nBonds = size(BONDLIST,1);
nodalStrainEnergyDensity = zeros(nNodes,1); % Initialise for every time step

% Calculate the micropotential (J/m^6) of every bond 
% TODO: think more deeply about the use of volume correction factors in
% this equation
micropotential = 0.5 * fail .* BFMULTIPLIER .* BONDSTIFFNESS .* stretch.^2 .* UNDEFORMEDLENGTH * cellVolume .* VOLUMECORRECTIONFACTORS;

% Calculate the strain energy density (J/m^3) for every node, iterate over the bond list
for kBond = 1:nBonds
    
    nodei = BONDLIST(kBond,1); % Node i
    nodej = BONDLIST(kBond,2); % Node j

    nodalStrainEnergyDensity(nodei,1) = nodalStrainEnergyDensity(nodei,1)  + micropotential(kBond,1);
    nodalStrainEnergyDensity(nodej,1) = nodalStrainEnergyDensity(nodej,1)  + micropotential(kBond,1);

end

nodalStrainEnergyDensity = 0.5 * nodalStrainEnergyDensity;

% Calculate the total strain energy (J) by summing the strain energy
% density at every node and multiplying by the total volume
strainEnergy = sum(nodalStrainEnergyDensity) * nNodes * cellVolume;

end

