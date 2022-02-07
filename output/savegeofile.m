function [] = savegeofile(filename, coordinates)
% Save .geo file for gmsh
%
% Syntax: [] = savegeofile(filename, coordinates)
%
% Inputs:
%   input1 -
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
% September 2021

% ---------------------------- BEGIN CODE ---------------------------------

baseFileName = sprintf('%s.geo', filename);    % add .geo file extension
findOutputFolder = what('BB_PD');
outputFolderPath = findOutputFolder.path;

diaryFileName = fullfile(outputFolderPath, baseFileName);
diary(diaryFileName)
diary on

nNodes = size(coordinates, 1);

for i = 1 : nNodes
    
    fprintf('Point(%.0f) = {%.5f, %.5f, %.5f};\n', i, coordinates(i,1), coordinates(i,2), coordinates(i,3))

end

% ----------------------------- END CODE ----------------------------------

end