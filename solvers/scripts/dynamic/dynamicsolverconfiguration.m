% -------------------------------------------------------------------------
% Dynamic Solver Configuration
% -------------------------------------------------------------------------
% Read in the main configuration file and set up dynamic solver

%% Loading method


%% Failure functionality

if strcmp(config.failureFunctionality ,'on')
    
    failureFunctionality = 0;
    
elseif strcmp(config.failureFunctionality ,'off')
    
    failureFunctionality = 1;
        
end

