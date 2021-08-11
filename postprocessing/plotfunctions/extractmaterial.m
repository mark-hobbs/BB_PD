function [nodalData] = extractmaterial(nodalData, MATERIALFLAG, material)
% extractcrosssection - This function extracts nodal data...
%
% Syntax: 
%
% Inputs:
%   undeformedCoordinates   - 
%   nodalData               - Must have format (nNodes, NOD)
%   XYplane                 - Define X-Y plane cross section
%
% Outputs:
%   nodalData    - Output nodes located in cross section
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
% March 2020

% ----------------------------- BEGIN CODE --------------------------------
 
nodalData(MATERIALFLAG == material,:) = [];       % Delete node if it...

% ------------------------------ END CODE ---------------------------------

end

