function [bForceX,bForceY] = calculatebondforces2D(fail,deformedX,deformedY,deformedLength,stretch,stretchPlastic,nBonds,BFMULTIPLIER,BONDSTIFFNESS,cellVolume,VOLUMECORRECTIONFACTORS,bondSofteningFactor)

% Initialise bond force to zero for every time step
bForceX = zeros(nBonds,1); 
bForceY = zeros(nBonds,1);

% Calculate X,Y,Z component of bond force 
bForceX = BFMULTIPLIER .* fail .* BONDSTIFFNESS .* (1 - bondSofteningFactor) .* (stretch - stretchPlastic) * cellVolume .* VOLUMECORRECTIONFACTORS .* (deformedX ./ deformedLength);
bForceY = BFMULTIPLIER .* fail .* BONDSTIFFNESS .* (1 - bondSofteningFactor) .* (stretch - stretchPlastic) * cellVolume .* VOLUMECORRECTIONFACTORS .* (deformedY ./ deformedLength);

% deformedLength will be 0 intially and divison leads to 'Not-a-Number'. If Bforce = 'NaN', set to 0 
bForceX(isnan(bForceX)) = 0; 
bForceY(isnan(bForceY)) = 0;

end
