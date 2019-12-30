function [] = savedamagefigure(iTimeStep,frequency,inputdatafilename,BONDLIST,fail,nFAMILYMEMBERS,undeformedCoordinates,deformedCoordinates,DX)
% savedamagefigure - Automatically save a figure of member damage. 
% Save figure in folder BB_PD/output/outputfiles/inputdatafilename/
%
% Syntax: [] = savedamagefigure()
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
    
    baseFileName = sprintf('%s_damage_%d.jpg', inputdatafilename, iTimeStep);
    fullFileName = fullfile(outputSubfolderPath , baseFileName);
    
    damage = calculatedamage(BONDLIST, fail, nFAMILYMEMBERS);
    
    f = figure; set(f, 'visible', 'off');
    % plotnodaldata(undeformedCoordinates, nodalDisplacement, damage, 'Damage', 10, 10);
    plotbonddamage(undeformedCoordinates, deformedCoordinates, damage, DX, 10, 10)
    saveas(f, fullFileName);
    close(f)
    
end

% ----------------------------- END CODE ----------------------------------

end

