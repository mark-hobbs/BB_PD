function [nBondsBrokenTotal,nBondsBrokenCurrentIteration] = trackbondfailure(nBonds,fail,nBondsBrokenTotalPreviousIteration)
% trackbondfailure - 
%
% Syntax: 
%
% Inputs:
%   input1  - 
% 
%
% Outputs:
%   output1 -
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
% June 2019

% ---------------------------- BEGIN CODE ---------------------------------

nBondsBrokenTotal = nBonds - sum(fail);
nBondsBrokenCurrentIteration = nBondsBrokenTotal - nBondsBrokenTotalPreviousIteration;
fprintf('Total number of bonds broken = %d, bonds broken in current iteration = %d \n', nBondsBrokenTotal, nBondsBrokenCurrentIteration) % Print total number of bonds broken and number of bonds broken in each iteration

% ----------------------------- END CODE ----------------------------------
    
end

