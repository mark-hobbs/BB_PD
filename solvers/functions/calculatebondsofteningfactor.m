function [bondSofteningFactor, flagBondSoftening] = calculatebondsofteningfactor(stretch, linearElasticLimit, criticalStretchConcrete, flagBondSoftening, bondSofteningFactor, BONDTYPE)
% calculatebondsofteningfactor - calculate the bond softening factor 
%
% Syntax: 
%
% Inputs:
%   stretch                  - current bond stretch (dimensionless)
%   linearElasticLimit       - bond stretch at the linear elastic limit (s0)
%   criticalStretchConcrete  - bond stretch at failure (sc)
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

% Bond softening factor from Eq 10 in 'Examples of applications of the
% peridynamic theory to the solution of static equilibrium problems' -
% Zaccariotto, 2015

flagBondSoftening(BONDTYPE == 0 & stretch > linearElasticLimit) = 1;            % concrete-to-concrete bonds     0.008s

bsf = (((stretch - linearElasticLimit) ./ stretch) .* (criticalStretchConcrete ./ (criticalStretchConcrete - linearElasticLimit)));

bondSofteningFactor = max(bondSofteningFactor,  (bsf .* flagBondSoftening));    % Bond softening factor can only increase (damage is irreversible)
bondSofteningFactor(bondSofteningFactor > 1) = 1;                               % Bond softening factor should not exceed 1 
bondSofteningFactor(isnan(bondSofteningFactor)) = 0;                            % if value is nan, replace with 0

% ----------------------------- END CODE ----------------------------------

end

