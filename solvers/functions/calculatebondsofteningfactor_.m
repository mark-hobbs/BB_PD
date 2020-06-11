function [bondSofteningFactor, flagBondSoftening] = calculatebondsofteningfactor_(stretch, linearElasticLimit, criticalStretchConcrete, flagBondSoftening, bondSofteningFactor, BONDTYPE)
% calculatebondsofteningfactor - calculate the bond softening factor 
%
% Syntax: 
%
% Inputs:
%   stretch                  - current bond stretch (dimensionless)
%   linearElasticLimit       - bond stretch at the linear elastic limit
%   criticalStretchConcrete  - bond stretch at failure
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

% nBonds = size(stretch,1);
% bsf = zeros(nBonds,1);
% 
% linearElasticLimitInterface = 2 * linearElasticLimit;
% criticalStretchInterface = 1000 * criticalStretchConcrete;

flagBondSoftening(BONDTYPE == 0 & stretch > linearElasticLimit) = 1;           % concrete-to-concrete bonds     0.008s
% flagBondSoftening(BONDTYPE == 1 & stretch > linearElasticLimitInterface) = 1;  % concrete-to-steel bonds        0.007s

bsf = (((stretch - linearElasticLimit) ./ stretch) * (criticalStretchConcrete / (criticalStretchConcrete - linearElasticLimit)));                      % 0.01s
% bsf2 = (((stretch - linearElasticLimitInterface) ./ stretch) * (criticalStretchInterface / (criticalStretchInterface - linearElasticLimitInterface)));  % 0.01s

% bsf(BONDTYPE == 0) = bsf1(BONDTYPE == 0);   % 0.1s
% bsf(BONDTYPE == 1) = bsf2(BONDTYPE == 1);   % 0.023s

% bondSofteningFactorCurrent = bsf .* flagBondSoftening;                        % if a bond remains in the elastic range, bondSofteningFactor = 0
bondSofteningFactor = max(bondSofteningFactor,  (bsf .* flagBondSoftening));    % Bond softening factor can only increase (damage is irreversible)
bondSofteningFactor(bondSofteningFactor > 1) = 1;                               % Bond softening factor should not exceed 1 
bondSofteningFactor(isnan(bondSofteningFactor)) = 0;                            % if value is nan, replace with 0

% ----------------------------- END CODE ----------------------------------

end

