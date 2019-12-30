function [] = savecmdwindowoutput(cmdWindowOuput,inputdatafilename)
% Save command window output in folder BB_PD/output/outputfiles/inputdatafilename/
%
% Syntax: [] = savecmdwindowoutput()
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
% December 2019

% ---------------------------- BEGIN CODE ---------------------------------

if strcmp(cmdWindowOuput ,'on')
    
    fprintf("Command window output log is switched on \n")
    
    inputdatafilename = erase(inputdatafilename,'.mat');    % erase .mat from inputdatafilename
    baseFileName = sprintf('%s.txt', inputdatafilename);    % add .txt file extension
    
    findOutputFolder = what('BB_PD/output/outputfiles');
    outputFolderPath = findOutputFolder.path;
        
    diaryFileName = fullfile(outputFolderPath, baseFileName);
    diary(diaryFileName)
    diary on

elseif strcmp(config.cmdWindowOuput ,'off')
    
    fprintf("Command window output log is switched off \n")
    
end

% ----------------------------- END CODE ----------------------------------

end