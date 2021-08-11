function [dampingEnergy,dampingEnergySum] = calculatedampingenergy(nodalVelocity,DAMPING,cellVolume,dampingEnergySum,nodalDisplacementDT)
% calculateviscousenergy - calculate the total viscous damping energy

dampingEnergy = DAMPING .* nodalDisplacementDT .* nodalVelocity; % DAMPING (kg/m^3s) * cellVolume (m^3) * nodalVelocity (m/s)

dampingEnergy = sum(dampingEnergy,2) * cellVolume;               % sum rows and return a column vector

dampingEnergy = sum(dampingEnergy);                              % sum all elements and return a single value (total damping energy)

dampingEnergySum = dampingEnergySum + dampingEnergy;

end

