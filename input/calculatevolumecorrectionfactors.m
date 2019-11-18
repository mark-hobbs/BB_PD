function [VOLUMECORRECTIONFACTORS] = calculatevolumecorrectionfactors(UNDEFORMEDLENGTH,horizon,RADIJ)
% Calculate volume correction factors for every node
% This function is based on the PA - PDLAMMPS algorithm. See 'Improved
% one-point quadrature algorithms for two-dimensional peridynamic models
% based on analytical calculations' - Seleson, 2014 for more details

tic

%% Constants
nBonds = size(UNDEFORMEDLENGTH,1);

%% Main body of volume correction function

VOLUMECORRECTIONFACTORS = zeros(nBonds,1);    % Initialise array

for kBond = 1 : nBonds
    
    UL = UNDEFORMEDLENGTH(kBond);
    
    if (UL <= (horizon - RADIJ))
        
        VOLUMECORRECTIONFACTORS(kBond) = 1;
        
    elseif (UL > (horizon - RADIJ)) &&  (UL <= horizon)
    
        VOLUMECORRECTIONFACTORS(kBond) = (horizon + RADIJ - UL) / (2 * RADIJ);
        
    else
        
        VOLUMECORRECTIONFACTORS(kBond) = 0;
    
    end
 
end

%% Function timing

calculatevolumecorrectionfactorsTiming = toc;
fprintf('Volume correction factors complete in %fs \n', calculatevolumecorrectionfactorsTiming)

end