%% Configuration file

% This file allows the user to configure code settings for running PD
% simulations

% -------------------------------------------------------------------------
% Input - select input file
% -------------------------------------------------------------------------

% Create new input file (on/off)
config.newInputFile = 'off';

% Load existing input file - specify the file name containing the input
% data (input file must be in a .mat form)
config.loadInputDataFile = 'StuttgartBeam5.mat';

% -------------------------------------------------------------------------
% Material Model
% -------------------------------------------------------------------------

% Material model (linear / bilinear / trilinear)
% config.materialModel = 'linear';

% -------------------------------------------------------------------------
% Solver - select dynamic or static solver
% -------------------------------------------------------------------------

% Solver (dynamic/static)
config.solver = 'dynamic';

% -------------------------------------------------------------------------
% General Solver Configuration
% -------------------------------------------------------------------------

% Failure functionality (on/off)
config.failureFunctionality = 'off';

% Loading method (loadControlled/displacementControlled)
config.loadingMethod = 'displacementControlled';

% -------------------------------------------------------------------------
% Dynamic Solver Configuration
% -------------------------------------------------------------------------

% Dynamic simulation time integration method

% Dynaming simulation damping method (local damping coefficient / Adaptive Dynamic Relaxation)

% Simulation type (single iteration/binary search failure
% load/high-throughput job)

% Dynamic solver input list     
config.dynamicsolverinputlist = {'undeformedCoordinates'...    % (nNodes , NOD)
                                'CONSTRAINTFLAG'...            % (nNodes , NOD)
                                'MATERIALFLAG'...              % (nNodes , NOD)
                                'BODYFORCEFLAG'...             % (nNodes , NOD)
                                'DENSITY'...                   % (nNodes , 1)
                                'nFAMILYMEMBERS'...            % (nNodes , 1) - not essential
                                'BONDLIST'...                  % (nBonds , 2)
                                'UNDEFORMEDLENGTH'...          % (nBonds , 1)
                                'BFMULTIPLIER'...              % (nBonds , 1)
                                'BONDSTIFFNESS'...             % (nBonds , 1)
                                'BONDTYPE'...                  % (nBonds , 1)
                                'VOLUMECORRECTIONFACTORS'...   % (nBonds , 1)
                                'linearElasticLimit'...        % (1 , 1)
                                'criticalStretchConcrete'...   % (1 , 1)
                                'criticalStretchSteel'...      % (1 , 1)
                                'bondStiffnessConcrete'...     % (1 , 1)
                                'cellVolume'...                % (1 , 1)
                                'DX'...                        % (1 , 1)
                                'MAXBODYFORCE'...              % (1 , 1)
                                'DAMPING'...                   % (1 , 1)
                                'nTimeSteps'...                % (1 , 1)
                                'DT'...                        % (1 , 1)
                                'timeStepTracker'...           % (1 , 1)
                                'equilibriumTolerance'};       % (1 , 1)
                            
% Dynamic termination method (on/off)
config.dynamicSimulationTermination = 'off';

% -------------------------------------------------------------------------
% Static Solver Configuration
% -------------------------------------------------------------------------

% Static simulation solver (non linear solver (newton-raphson))

% Static solver input list
config.staticsolverinputlist = {'undeformedCoordinates'...     % (nNodes , NOD)
                                'CONSTRAINTFLAG'...            % (nNodes , NOD)
                                'MATERIALFLAG'...              % (nNodes , NOD)
                                'BODYFORCEFLAG'...             % (nNodes , NOD)
                                'DENSITY'...                   % (nNodes , 1)
                                'nFAMILYMEMBERS'...            % (nNodes , 1) - not essential
                                'BONDLIST'...                  % (nBonds , 2)
                                'UNDEFORMEDLENGTH'...          % (nBonds , 1)
                                'BFMULTIPLIER'...              % (nBonds , 1)
                                'BONDSTIFFNESS'...             % (nBonds , 1)
                                'BONDTYPE'...                  % (nBonds , 1)
                                'VOLUMECORRECTIONFACTORS'...   % (nBonds , 1)
                                'linearElasticLimit'...        % (1 , 1)
                                'criticalStretchConcrete'...   % (1 , 1)
                                'criticalStretchSteel'...      % (1 , 1)
                                'cellVolume'...                % (1 , 1)
                                'DX'...                        % (1 , 1)
                                'finalDisplacement'...         % (1 , 1)
                                'DAMPING'...                   % (1 , 1)
                                'nTimeSteps'...                % (1 , 1)
                                'DT'...                        % (1 , 1)
                                'timeStepTracker'...           % (1 , 1)
                                'equilibriumTolerance'};       % (1 , 1)

% Static termination method

% -------------------------------------------------------------------------
% Output
% -------------------------------------------------------------------------

% Save command window output to text file (on/off)
config.cmdWindowOuput = 'on';

% -------------------------------------------------------------------------
% Post-processing
% -------------------------------------------------------------------------

% Post-processing of simulation output (on/off)

