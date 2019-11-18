function [kineticEnergy] = calculatekineticenergy(nodalMass,nodalVelocity,deformedCoordinates,totalSystemMass)
% calculatekineticenergy - calculate the total kinetic energy of the
% particle simulation

% The total kinetic energy of the system K_total = K_cm + K_rel
% K_cm is the kinetic energy of the centre of mass relative to the origin
% K_rel is kinetic energy of every particle relative to the centre of mass

%% Kinetic energy of Centre of Mass - External forces

weightedPositionVectors = nodalMass .* deformedCoordinates;
centreSystemMassNumerator = sum(weightedPositionVectors(:,:),1);
centreSystemMass = centreSystemMassNumerator ./ totalSystemMass;

weightedVelocityVectors = nodalMass .* nodalVelocity;
velocityCentreSystemMassNumerator = sum(weightedVelocityVectors(:,:),1);
velocityCentreSystemMass = velocityCentreSystemMassNumerator ./ totalSystemMass;

kineticEnergyCOM = sum(0.5 * centreSystemMass .* velocityCentreSystemMass.^2);


%% Kinetic energy of Individual Particles - Internal forces

kineticEnergyREL = nodalMass .* nodalVelocity.^2;     % Kinetic energy = 0.5 * m * (v * v)

kineticEnergyREL = 0.5 * sum(kineticEnergyREL,2);     % sum rows and return a column vector

kineticEnergyREL = sum(kineticEnergyREL);             % sum all elements and return a single value (total kinetic energy)

%% Total Kinetic Energy of the System

kineticEnergy = kineticEnergyCOM + kineticEnergyREL;

end

