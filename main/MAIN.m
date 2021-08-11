% -------------------------------------------------------------------------
% MAIN file for Bond Based Peridynamic Analysis (BB_PD) code 
% -------------------------------------------------------------------------

% Mark Hobbs
% Department of Engineering
% University of Cambridge
% mch61@cam.ac.uk

function MAIN(inputdatafilename, nThreads, checkpointfilename, vargin)

% MAIN(inputdatafilename, nThreads)
% MAIN(inputdatafilename, nThreads, checkpointfile)

%% Add folder paths
addfolderpaths

%% Load configuration file
% Edit this file to set up simulation configuration
fprintf('Load configuration file \n')
configuration

%% Log command window output
savecmdwindowoutput(config.cmdWindowOuput, inputdatafilename)

%% Input parser

if nargin == 1 
    
    fprintf('Not enough input arguments: \n')
    fprintf('\t MAIN(inputdatafilename, nThreads) \n')
    fprintf('\t MAIN(inputdatafilename, nThreads, checkpointfilename) \n')
    return
    
elseif nargin == 2
   
    checkpointfileflag = false;
    checkpointfilename = 'empty';
    
elseif nargin == 3
    
    checkpointfileflag = true;
    
end

%% Module 1: Input
% Load input file. Create a new input file using the functions and scripts
% provided in BB_PD/input
if nargin == 2
    
    load(inputdatafilename)

    % Print details of simulation
    % printsimulationsetup(inputdatafilename, config)

end
 
%% Module 2: Solver

if strcmp(config.solver,'dynamic')

    if strcmp(config.loadingMethod ,'loadControlled')
        
        %------------------------------------------------------------------
        % Dynamic Load-Controlled
        % -----------------------------------------------------------------

        fprintf('Start dynamic solver: load-controlled \n\n')
        [deformedCoordinates,fail,stretch,flagBondYield] = dynamicsolverloadcontrolled(inputdatafilename, config);

    elseif strcmp(config.loadingMethod ,'displacementControlled')
        
        %------------------------------------------------------------------
        % Dynamic Displacement-Controlled
        % -----------------------------------------------------------------

        fprintf('Start dynamic solver: displacement-controlled \n\n')
        [deformedCoordinates,fail] = dynamicsolverdisplacementcontrolled(inputdatafilename, config, nThreads, checkpointfileflag, checkpointfilename);

    end
               
elseif strcmp(config.solver,'static')
    
        %------------------------------------------------------------------
        % Static Load-Controlled
        % -----------------------------------------------------------------
    
        fprintf('Start static solver: load-controlled \n\n')
        [deformedCoordinates,fail,stretch] = newtonraphsondisplacementcontrolled(inputdatafilename, config);
    
        %------------------------------------------------------------------
        % Static Displacement-Controlled
        % -----------------------------------------------------------------
        fprintf('Start static solver: displacement-controlled \n\n')
        
end

diary off

%% Module 3: Process Results
% outputFileName = fullfile(outputFolderPath, 'testing.mat');
% save(outputFileName)
processresults

end
