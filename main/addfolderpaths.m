function addfolderpaths
% Find the full path of the BB_PD root directory and add all sub-directories

findFolder = 'BB_PD';   % Name of main root directory for BB_PD code
currentDirectory = pwd;
startingIndex = strfind(currentDirectory, findFolder);
newDirectory = currentDirectory(1 : (startingIndex(end) - 1) + size(findFolder, 2));
addpath(genpath(newDirectory));     % genpath adds a folder and its subfolders to search path

end

