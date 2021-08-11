% -------------------------------------------------------------------------
% Module 1 or 2: Simulation Setup
% -------------------------------------------------------------------------

% This script is used to setup simulation parameters such as number of
% timesteps and applied loading 

%% Define new simulation parameters
nTimeSteps = 10000;               % Number of time steps (10,000 for speed testing)
appliedLoad = -48000;            % Applied load in newtons (remember the load direction)
DAMPING = 2.5e6;                    % Damping coefficient (2.5e6 for testing)

%% Define new material properties
% fc = 20;                                      % Compressive strength of concrete (N/mm^2) (MPa)
% Econcrete = (22 * (fc/10) ^ 0.3);             % Elastic Modulus of concrete (GPa)
Econcrete = 22;
Econcrete = Econcrete * 10^9;                   % Convert GPa to N/m^2
% %Gf = (0.073 * fc ^ 0.18);                    % Fracture energy of concrete (N/mm)
% %Gf = Gf * 1000;                              % Convert N/mm to N/m
Gf = 100;
horizonRadius = pi * DX;                      % Peridynamic horizon radius (m)
criticalStretchConcrete = sqrt((5 * Gf) / (6 * Econcrete * horizonRadius)); % Critical stretch - concrete bond
bondStiffnessConcrete = (12 * Econcrete) / (pi * horizonRadius^4);          % Bond stiffness - concrete

%% Calculate applied body force per node (cell)
MAXBODYFORCE = calculateappliedbodyforce(BODYFORCEFLAG,appliedLoad,cellVolume);
