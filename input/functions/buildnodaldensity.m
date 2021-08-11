function [DENSITY] = buildnodaldensity(MATERIALFLAG,densityConcrete,densitySteel)
% buildnodaldensity - Assign density values to every material point
%
% Syntax: 
%
% Inputs:
%   supportStart  - Define the start position of the support (define in metres)
%   supportEnd    - Define the end position of the support (define in metres)
%   CONSTRAINTFLAG
%   MATERIALFLAG
%   BODYFORCEFLAG
%
% Outputs:
%   supportCoordinates - Coordinates of nodes in the supports
%   CONSTRAINTFLAG
%   MATERIALFLAG
%   BODYFORCEFLAG
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

nNodes = size(MATERIALFLAG,1);

for i = 1 : nNodes
    
    if MATERIALFLAG(i,1) == 0
        
        DENSITY(i,1) = densityConcrete; % Concrete
        
    elseif MATERIALFLAG(i,1) == 1
        
        DENSITY(i,1) = densitySteel;    % Steel
        
    end
end

% ----------------------------- END CODE ----------------------------------

end
