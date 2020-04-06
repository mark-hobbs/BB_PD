function [nodalData] = extractcrosssection(undeformedCoordinates, nodalData, XYplane)
% extractcrosssection - This function extracts nodal data at a user
% defined cross section
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

crossSectionFlag = (undeformedCoordinates(:,2) == (XYplane)) == 1;   % Identify and flag nodes located in cross-section (X-Y Plane)
logicCondition1 = crossSectionFlag == 0;                            
nodalData(logicCondition1,:) = [];                                   % Delete node if it is not located in cross-section (flag == 0)

% ------------------------------ END CODE ---------------------------------

end

