function [bondSofteningFactor, flagBondSoftening] = calculatebsfexponential(stretch, s0, sc, k, alpha, bondSofteningFactor, BONDTYPE, flagBondSoftening)
% calculatebsfexponential - calculate the bond softening factor for a
% decaying exponential material model. The model is similar to the
% non-linear tension softening model (Hordijk, 1991) available in DIANA FEA
% (https://dianafea.com/manuals/d943/MatLib/node305.html)
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
% create a flag to identify concrete-to-concrete bonds (BONDTYPE == 0) that
% have exceeded the linear elastic limit. flag == 1 when a bond has
% exceeded the elastic limit (stretch > linearElasticLimit), flag == 0 when
% a bond remains in the elastic range

nBonds = size(BONDTYPE, 1);

bsf = zeros(nBonds, 1);
numerator = zeros(nBonds, 1);
residual = zeros(nBonds, 1);

% for kBond = 1 : nBonds
%     
%     
%     if BONDTYPE(kBond, 1) == 0
% 
%         if (s0 < stretch(kBond)) && (stretch(kBond) <= sc)
%             
%             numerator = 1 - exp(-k * (stretch(kBond) - s0) / (sc - s0));
%             denominator = 1 - exp(-k);
%             residual = (alpha * (1 - (stretch(kBond) - s0) / (sc - s0)));
%             bsf(kBond, 1) = 1 - (s0 / stretch(kBond)) * ((1 - (numerator / denominator)) + residual) / (1 + alpha);
%                         
%             flagBondSoftening(kBond) = 1; 
%             
%                 
%         elseif (stretch(kBond) > sc)
%                         
%             bsf(kBond,1) = 1;
% 
%         end
% 
%         if bsf(kBond,1) > bondSofteningFactor(kBond,1)      % Bond softening factor can only increase (damage is irreversible)
% 
%             bondSofteningFactor(kBond,1) = bsf(kBond,1);
% 
%         end
%         
%         
%     end
% 
% end


for kBond = 1 : nBonds
    
    
    if BONDTYPE(kBond, 1) == 0

        if (s0(kBond) < stretch(kBond)) && (stretch(kBond) <= sc(kBond))
            
            numerator(kBond, 1) = 1 - exp(-k * (stretch(kBond) - s0(kBond)) / (sc(kBond) - s0(kBond)));
            denominator = 1 - exp(-k);
            residual(kBond, 1) = alpha * (1 - (stretch(kBond) - s0(kBond)) / (sc(kBond) - s0(kBond)));
            bsf(kBond, 1) = 1 - (s0(kBond) / stretch(kBond)) * ((1 - (numerator(kBond) / denominator)) + residual(kBond)) / (1 + alpha);
                        
            flagBondSoftening(kBond) = 1; 
            
                
        elseif (stretch(kBond) > sc(kBond))
                        
            bsf(kBond,1) = 1;

        end        
        
    end

end

bondSofteningFactor = max(bondSofteningFactor,  (bsf .* flagBondSoftening));    % Bond softening factor can only increase (damage is irreversible)
bondSofteningFactor(bondSofteningFactor > 1) = 1;                               % Bond softening factor should not exceed 1 
bondSofteningFactor(isnan(bondSofteningFactor)) = 0;                            % if value is nan, replace with 0

% ----------------------------- END CODE ----------------------------------

end

