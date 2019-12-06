function [fullFileName] = createuniqueinputfilename()

%--------------------------------------------------------------------------
% Save Input File
% -------------------------------------------------------------------------

% This script saves an input data file with a unique name. The user is
% asked to provide a unique file name and the script checks if the file
% name already exists. If the file name is unique, the input data file is
% saved into a defined folder.

%% Find the root directory path

findRootDirectory = 'BB_PD';   % Name of main root directory for BB_PD code
currentDirectory = pwd;
startingIndex   = strfind(currentDirectory,findRootDirectory);
fullRootDirectoryPath = currentDirectory(1:(startingIndex(end)-1) + size(findRootDirectory,2));

%% Specify the input data file path and file name and check if the file name is unique

inputFolderPath = '/Input/InputDataFiles';                                % Save files to this folder
prompt = 'Enter a unique name for the newly created input data file: ';   % Ask user for unique name for newly created input data file
baseFileName = input(prompt , 's');
baseFileName = strcat(baseFileName,'.mat');                               % Specify file extension type
fullFileName = fullfile(fullRootDirectoryPath, inputFolderPath , baseFileName);
checkFileNameUniqueness = isfile(fullFileName);

while checkFileNameUniqueness == 1  % Check if file name already exists. Use a 'while loop' to prevent users from entering an existing file name. 

    prompt = 'This file already exists. Please enter a unique name for the newly created input data file: ';   % Ask user for unique name for newly created input data file
    baseFileName = input(prompt , 's');
    baseFileName = strcat(baseFileName,'.mat');                               
    fullFileName = fullfile(fullRootDirectoryPath, inputFolderPath , baseFileName);
    checkFileNameUniqueness = isfile(fullFileName);
       
end

% %% Save the input file and clear redundant variables
% 
% % File has a unique file name
% save(fullFileName); % Save workspace
