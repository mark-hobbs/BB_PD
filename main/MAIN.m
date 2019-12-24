% -------------------------------------------------------------------------
% MAIN file for Bond Based Peridynamic Analysis (BB_PD) code 
% -------------------------------------------------------------------------

% Mark Hobbs
% Department of Engineering
% University of Cambridge
% mch61@cam.ac.uk

% function MAIN(varagin)

%% Clear the workspace
clear variables
close all
clc

%% Add folder paths
addfolderpaths

%% Load configuration file
% Edit this file to set up simulation configuration
fprintf('Load configuration file \n')
configuration

%% Log command window output
if strcmp(config.cmdWindowOuput ,'on')
    
    fprintf("Command window output log is switched on \n")
    findOutputFolder = what('BB_PD/output');
    outputFolderPath = findOutputFolder.path;
    diaryFileName = fullfile(outputFolderPath, 'commandwindowoutput.txt');
    diary(diaryFileName)
    diary on

elseif strcmp(config.cmdWindowOuput ,'off')
    
    fprintf("Command window output log is switched off \n")
    
end

%% Input parser

% p = inputParser; % Create an input parser object
% addParameter(p, 'inputDataFileName', defaultInputDataFileName, @isstring);
% addParameter(p, 'jobType', defaultJobType, @isstring);
% addParameter(p, 'appliedLoad', defaultAppliedLoad, @isnumeric); 

%% Module 1: Input
% Create input file or load existing input file

if strcmp(config.newInputFile ,'on')
  
    createinputdatafile;              % Create new input file
    fprintf('Created a new input data file \n')
    
else
    
    inputdatafilename = config.loadInputDataFile;     % Load existing file (specify file name in config file)
    fprintf('Load existing input data file %s \n', inputdatafilename)
    
end

 printsimulationsetup(config)
 
%% Module 2: Solver

if strcmp(config.solver,'dynamic')

    if strcmp(config.loadingMethod ,'loadControlled')
        
        %------------------------------------------------------------------
        % Dynamic Load-Controlled
        % -----------------------------------------------------------------

        fprintf('Start dynamic solver: load-controlled \n')
        [deformedCoordinates,fail,stretch,flagBondYield] = dynamicsolverloadcontrolled(inputdatafilename,config);

    elseif strcmp(config.loadingMethod ,'displacementControlled')
        
        %------------------------------------------------------------------
        % Dynamic Displacement-Controlled
        % -----------------------------------------------------------------

        fprintf('Start dynamic solver: displacement-controlled \n')
        [deformedCoordinates,fail] = dynamicsolverdisplacementcontrolled(inputdatafilename,config);

    end
               
elseif strcmp(config.solver,'static')
    
        %------------------------------------------------------------------
        % Static Load-Controlled
        % -----------------------------------------------------------------
    
        fprintf('Start static solver \n')
        [deformedCoordinates,fail,stretch] = newtonraphsonloadcontrolled(inputdatafilename,config);
    
        %------------------------------------------------------------------
        % Static Displacement-Controlled
        % -----------------------------------------------------------------
end

diary off

%% Module 3: Process Results
% outputFileName = fullfile(outputFolderPath, 'testing.mat');
% save(outputFileName)
processresults

% end