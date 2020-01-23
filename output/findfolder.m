function [folderPath] = findfolder(findThisFolder)
% findfolder - this function will find the full path to a specified folder
% in the BB_PD root directory. For example, the user might wish to locate
% the output folder during run time and save checkpoint files. This
% function is compatible with both windows and linux machines.
%
% Syntax: [] = findfolder()
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
% January 2020

% ---------------------------- BEGIN CODE ---------------------------------

% 'what' is a built-in matlab function that will locate any folder on the
% matlab search path and return its contents
folderContentList = what(findThisFolder);
folderPath = folderContentList.path;

% ----------------------------- END CODE ----------------------------------

end