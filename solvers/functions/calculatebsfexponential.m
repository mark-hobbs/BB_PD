function [bondSofteningFactor, flagBondSoftening] = calculatebsfexponential(stretch, s0, sc, k, alpha, bondSofteningFactor, BONDTYPE, flagBondSoftening)
% calculatebsfexponential - calculate the bond softening factor for a
% decaying exponential material model
%
% Syntax: 
%
% Inputs:
%   stretch                  - current bond stretch (dimensionless)
%   s0                       - bond stretch at the linear elastic limit (s0)
%   sc                       - bond stretch at failure (sc)
%   k                        - rate of decay
%   flagBondSoftening        - flag to identify bonds that have reached the linear elastic limit 
%   BONDTYPE                 - flag to identify the bond material type
% 
%
% Outputs:
%   bondSofteningFactor      - softening factor (a softening factor of 1
%   would indicate that a bond has exceeded the critical stretch)
%   flagBondSoftening        - flag to identify bonds that have reached the linear elastic limit 
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
% July 2020

% ---------------------------- BEGIN CODE ---------------------------------
% create a flag to identify concrete-to-concrete bonds (BONDTYPE == 0) and
% concrete-to-steel bonds (BONDTYPE = 1) that have exceeded the linear
% elastic limit. flag == 1 when a bond has exceeded the elastic limit
% (stretch > linearElasticLimit), flag == 0 when a bond remains in the
% elastic range

nBonds = size(BONDTYPE, 1);

bsf = zeros(nBonds, 1);

for kBond = 1 : nBonds
    
    
    if BONDTYPE(kBond, 1) == 0

        if (s0 < stretch(kBond)) && (stretch(kBond) <= sc)
            
            numerator = 1 - exp(-k * (stretch(kBond) - s0) / (sc - s0));
            denominator = 1 - exp(-k);
            residual = (alpha * (1 - (stretch(kBond) - s0) / (sc - s0)));
            bsf(kBond,1) = 1 - (s0 / stretch(kBond)) * ((1 - (numerator / denominator)) + residual) / (1 + alpha);
                        
            flagBondSoftening(kBond) = 1; 
            
                
        elseif (stretch(kBond) > sc)
                        
            bsf(kBond,1) = 1;

        end

        if bsf(kBond,1) > bondSofteningFactor(kBond,1)      % Bond softening factor can only increase (damage is irreversible)

            bondSofteningFactor(kBond,1) = bsf(kBond,1);

        end
        
        
    end

end


bondSofteningFactor(isnan(bondSofteningFactor)) = 0;                            % if value is nan, replace with 0

% ----------------------------- END CODE ----------------------------------

end

