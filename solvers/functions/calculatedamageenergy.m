function [damageEnergy] = calculatedamageenergy(BONDSTIFFNESS, s0, sc, UNDEFORMEDLENGTH, stretch, k, alpha, cellVolume, damageEnergy)
% calculatedamageenergy - calculate the dissipated damage energy for every
% bond
%
% Syntax: 
%
% Inputs:
%   BONDSTIFFNESS            - 
%   s0                       -
%   sc                       -
%   UNDEFORMEDLENGTH         -
%   stretch                  - current bond stretch (dimensionless)
%   k                        -
%   alpha                    -
%   cellVolume               -
%   
%
% Outputs:
%   totalDamageEnergy        - Total damage energy (J) 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none
%
% Mark Hobbs 
% mch61@cam.ac.uk
% Department of Engineering
% Cambridge University
% August 2020

% ---------------------------- BEGIN CODE ---------------------------------

nBonds = size(BONDSTIFFNESS, 1);
de = zeros(nBonds,1);
denominator = 2 * k * (exp(k) - 1) * (1 + alpha);

softeningCounter = 0;
failCounter = 0;

for kBond = 1 : nBonds
    
    if (s0(kBond,1) < stretch(kBond,1)) && (stretch(kBond,1) <= sc(kBond,1))
        
        softeningCounter = softeningCounter + 1;

        numerator = BONDSTIFFNESS(kBond,1) * s0(kBond,1) * UNDEFORMEDLENGTH(kBond,1) * (s0(kBond,1) - stretch(kBond,1)) * ((2 * k) - (2 * exp(k)) + (alpha * k) - (alpha * k * exp(k)) + 2);
        de(kBond,1) = (numerator / denominator) * cellVolume^2;
        
    elseif (stretch(kBond,1) > sc(kBond,1))
        
        failCounter = failCounter + 1;
        
        numerator = BONDSTIFFNESS(kBond,1) * s0(kBond,1) * UNDEFORMEDLENGTH(kBond,1) * (s0(kBond,1) - sc(kBond,1)) * ((2 * k) - (2 * exp(k)) + (alpha * k) - (alpha * k * exp(k)) + 2);
        de(kBond,1) = (numerator ./ denominator) * cellVolume^2;

    end
    
end

damageEnergy = max(damageEnergy, de);    % Damage energy can only increase (dissipated energy can't decrease)

% ----------------------------- END CODE ----------------------------------
end

