function [equilibriumState,equilibriumStateAverage] = calculateequilibriumstate(iTimeStep,nodeID,nodalForce,BODYFORCE,MAXBODYFORCE,equilibriumState,equilibriumStateAverage)
% Determine if the system has reached equilibrium (steady-state): Implement
% Eq 36 from 'An improved peridynamic approach for quasi-static elastic
% deformation and brittle fracture analysis' - Huang et al, 2015

numeratorEquilibriumState = sum(nodalForce(nodeID,:));
denominatorEquilibriumState = sum(BODYFORCE(nodeID,:)) * MAXBODYFORCE;
equilibriumState(iTimeStep,1) = sqrt(numeratorEquilibriumState ^ 2) / sqrt(denominatorEquilibriumState ^ 2);

[~,~,equilibriumStateNonZero] = find(equilibriumState); % equilbriumStateNonZero contains the non-zero elements of equilibriumState
equilibriumStateAverage(iTimeStep,1) = mean(equilibriumStateNonZero);

    
end