function [criticalStretch] = calculatecriticalstretch(NOD,fractureEnergy,youngsModulus,horizon)
% calculatecriticalstretch - determine the critical stretch value for a
% bond
%
% Syntax: 
%
% Inputs:
%   fractureEnergy  -
%   youngsModulus   -
%   horizon         -
%
% Outputs:
%   criticalStretch - 
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
% July 2019

% ---------------------------- BEGIN CODE ---------------------------------

if NOD == 2 % Plane stress
    
    criticalStretch = sqrt((4 * pi * fractureEnergy)/(9 * youngsModulus * horizon)); 
    
elseif NOD == 3
    
    criticalStretch = sqrt((5 * fractureEnergy) / (6 * youngsModulus * horizon)); 
    
end

% ----------------------------- END CODE ----------------------------------

end

