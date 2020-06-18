function [bondSofteningFactor, flagBondSoftening] = calculatebsftrilinear(stretch, s0, s1, sc, bondSofteningFactor, BONDTYPE, flagBondSoftening)
% calculatebsftrilinear - calculate the bond softening factor for a
% trilinear material model
%
% Syntax: 
%
% Inputs:
%   stretch                  - current bond stretch (dimensionless)
%   s0                       - bond stretch at the linear elastic limit (s0)
%   s1                       - bond stretch at the kink point (s1)
%   sc                       - bond stretch at failure (sc)
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
% August 2019

% ---------------------------- BEGIN CODE ---------------------------------
% create a flag to identify concrete-to-concrete bonds (BONDTYPE == 0) and
% concrete-to-steel bonds (BONDTYPE = 1) that have exceeded the linear
% elastic limit. flag == 1 when a bond has exceeded the elastic limit
% (stretch > linearElasticLimit), flag == 0 when a bond remains in the
% elastic range

nBonds = size(BONDTYPE, 1);
beta = 0.25;
eta = s1/s0;
bsf = zeros(nBonds, 1);

for kBond = 1 : nBonds

    if BONDTYPE(kBond, 1) == 0

        if (s0 < stretch(kBond)) && (stretch(kBond) <= s1)

            bsf(kBond,1) = 1 - ( (eta - beta) / (eta - 1) * (s0 / stretch(kBond)) ) + ( (1 - beta) / (eta - 1) ); 
            flagBondSoftening(kBond) = 1;
            
        elseif (s1 < stretch(kBond)) && (stretch(kBond) <= sc)

            bsf(kBond,1) = 1 - ( (s0 * beta) / stretch(kBond) ) * ( (sc - stretch(kBond)) / (sc - s1) );
            
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

