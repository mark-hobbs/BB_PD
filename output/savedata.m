function [] = savedata(iTimeStep,frequency,inputdatafilename,deformedCoordinates,fail,flagBondSoftening)
% savedata - Save variables for postprocessing (deformedCoordinates, fail, flagBondSoftening)
% in folder BB_PD/output/outputfiles/inputdatafilename/
%
% Syntax: [] = savedata(iTimeStep,frequency,inputdatafilename,deformedCoordinates,fail,,flagBondSoftening)
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
% November 2019

% ---------------------------- BEGIN CODE ---------------------------------

if mod(iTimeStep, frequency) == 0
    
    inputdatafilename = erase(inputdatafilename,'.mat'); % erase .mat from inputdatafilename
    
    % Find the full path of the output folder located within the BB_PD root
    % directory. 'what' is a built-in matlab function that will locate any
    % folder on the matlab search path and return its contents.
    outputFolderContentList = what('BB_PD/output/outputfiles');
    outputFolderPath = outputFolderContentList.path;
    outputSubfolderPath = fullfile(outputFolderPath , inputdatafilename); % BB_PD/output/outputfiles/inputdatafilename/
    
    % Determine if the output subfolder exists 
    if ~exist(outputSubfolderPath, 'dir')
        mkdir(outputSubfolderPath);
    end
    
    baseFileName = sprintf('%s_%d.mat', inputdatafilename, iTimeStep);
    fullFileName = fullfile(outputSubfolderPath , baseFileName);
      
    % Save variables for postprocessing (deformedCoordinates, fail, flagBondSoftening)
    save(fullFileName, 'deformedCoordinates', 'fail', 'flagBondSoftening')

end

% ----------------------------- END CODE ----------------------------------

%     jobNumberSuffix = 2; % Start at 2. First file is saved above
%     
%     if isfile(fullFileName)  % if file name already exists
%         
%         baseFileName = sprintf('Output_JobID_%s_%d_%.0fN.mat' , datestr(now , dateFormat) , jobNumberSuffix , pointLoad);
%         fullFileName = fullfile(outputFolderPath , baseFileName);
%         
%         % Prepare for next time, in case this name also exists
%         jobNumberSuffix = jobNumberSuffix + 1;
%         
%     end % File does not exist

end