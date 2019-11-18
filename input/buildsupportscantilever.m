function [CONSTRAINTFLAG] = buildsupportscantilever(undeformedCoordinates,CONSTRAINTFLAG)
% buildsupports - build constraints for cantilevers. Fully constrain all
% nodes within the horizon of the fixed end.
%
% Syntax: [CONSTRAINTFLAG] = buildsupportscantilever(undeformedCoordinates,CONSTRAINTFLAG)
%
% Inputs:
%   undeformedCoordinates
%   CONSTRAINTFLAG
%
% Outputs:
%   CONSTRAINTFLAG
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

%% Load data
datageometry

%% Main body of function

flagConstrained = undeformedCoordinates(:,1) <= (pi * DX); 

CONSTRAINTFLAG(flagConstrained,:) = 0;
        
% ----------------------------- END CODE ----------------------------------

end
