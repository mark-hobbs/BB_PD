% -------------------------------------------------------------------------
% Define simulation parameters
% -------------------------------------------------------------------------

SAFETYFACTOR = 1;                                                                                             % Time step safety factor - to reduce time step size and ensure stable simulation
DT = (0.8 * sqrt(2 * densityConcrete * DX / (pi * horizon^2 * DX * bondStiffnessConcrete))) / SAFETYFACTOR;   % Minimum stable time step
                                                                                 
% DT = calculatestabletimestep(TOTALNODES,bondlist,VOLUME,DENSITY,c);         % Minimum stable time step (this value is not always stable and a safety factor must be applied) 
% DT = DT / SAFETYFACTOR;                                                     % Apply safety factor
nTimeSteps = 100000;                                                          % Number of time steps (10,000 for speed testing)

appliedLoad = -100000;            % Applied load in newtons (remember the load direction)
appliedDisplacement = -3e-3;      % Applied displacement in mm 
BUILDUP = 0;                      % Build load up over defined number of time steps
DAMPING = 1.2e6;                  % Damping coefficient (2.5e6 for testing)

timeStepTracker = 1;             % Tracker for determining previous time step when restarting simulations

equilibriumTolerance = 0.04;     % Equlibrium state tolerance. If this value is met the simulation will terminate

referenceNode = 85;              % Define a reference point/node for measuring deflections