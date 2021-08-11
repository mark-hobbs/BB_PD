function [] = calculateworkdone(nodalMass,totalSystemMass,deformedCoordinates,nodalVelocity)
% calculateworkdone - calculate the work done on the particle system (J)

% The total work done on the system W_total = W_cm + W_rel
% W_cm is work of the centre of mass relative to the origin
% W_rel is work of every particle relative to the centre of mass

%% Work of Centre of Mass - External forces
% Overall motion of the system, not those of individual particles. Uses
% centre of mass.


weightedPositionVectors = nodalMass .* deformedCoordinates;
centreSystemMassNumerator = sum(weightedPositionVectors(:,:),1);
centreSystemMass = centreSystemMassNumerator ./ totalSystemMass;

weightedVelocityVectors = nodalMass .* nodalVelocity;
velocityCentreSystemMassNumerator = sum(weightedVelocityVectors(:,:),1);
velocityCentreSystemMass = velocityCentreSystemMassNumerator ./ totalSystemMass;


%% Work of Individual Particles - Internal forces
% Internal forces do not affect the motion of the centre of mass. 




%%

% externalWork = ((BODYFORCEFLAG(:,:) * MAXBODYFORCE) .* nodalDisplacement);   % nodalForce (N/m^3) * nodalDisplacement (m)
% 
% externalWork = sum(externalWork,2) * cellVolume;                             % Sum rows and return a column vector then multiply by cellVolume (N/m^2) * (m^3)
% 
% externalWork = sum(externalWork);                                            % Sum all elements and return a single value (total external work)
% 
% externalWorkSum = externalWorkSum + externalWork;

end

