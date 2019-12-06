function [BODYFORCEFLAG] = buildappliedloadingcantilever(undeformedCoordinates,BODYFORCEFLAG,bodyForceLayer)
% buildappliedloading - directly apply external loads to nodes within the
% main body of a cantilever
%
% Syntax: 
%
% Inputs:
%   undeformedCoordinates -
%   BODYFORCEFLAG         -
%   bodyForceLayer        - apply a body force over a defined layer of points
%
% Outputs:
%   BODYFORCEFLAG - 
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

bodyForceLayer = bodyForceLayer - 1;

flagAppliedLoading = undeformedCoordinates(:,1) >= ((nDivX - bodyForceLayer) * DX);

BODYFORCEFLAG(flagAppliedLoading, 2) = 1; % Apply loading vertically 

% ----------------------------- END CODE ----------------------------------

end
