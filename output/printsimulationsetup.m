function [] = printsimulationsetup(config)
% printsimulationsetup - print simulation setup to text file
%
% Syntax: [] = printsimulationsetup()
%
% Inputs:
%   config - configuration file
%   
% 
% Outputs:
%
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

% =========================================================================
%                              Input File
% =========================================================================

fprintf('Input file: \t %s \n', config.loadInputDataFile)

% =========================================================================
%                       Geometry and Discretisation
% =========================================================================

fprintf('DX: \t %d mm \n', DX)                                      % DX
fprintf('Cell Volume: \t %d mm^3 \n', cellVolume)                   % Cell Volume
fprintf('Horizon Radius: \t %d mm \n', horizonRadius)               % Horizon
fprintf('Neigbourhood Volume: \t %d mm^3 \n', neighbourhoodVolume)  % Neighbourhood Volume
% Radius

fprintf('Length (x-axis): \t %d (m) \t Discretisation: %d nodes \n', length, nDivX) % Length (x-axis)
fprintf('Width (y-axis): \t %d (m) \t Discretisation: %d nodes \n', width, nDivY)   % Width (y-axis)
fprintf('Depth (z-axis): \t %d (m) \t Discretisation: %d nodes \n', depth, nDivZ)   % Depth (z-axis)

% Number of Nodes 
% total | concrete | steel
% Number of Bonds 
% total | concrete | steel | interface

% Maximum family size
% Minimum family size

% Supports

% Penetrators

% =========================================================================
%                               Solver
% =========================================================================

% Solver: Dynamic / Static
fprintf('Solver: \t %s \n', config.solver) 

% Loading Method: Load Controlled / Displacement Controlled
fprintf('Loading method: \t %s \n', config.loadingMethod) 

% Failure Functionality: on / off
fprintf('Failure functionality: \t %s \n', config.failureFunctionality) 

% =========================================================================
%                         Material Properties
% =========================================================================

% Material Model: Concrete | Steel | Interface
fprintf('Concrete: %s \t Steel: %s \t Interface: %s \n', config.materialModel.concrete, config.materialModel.steel, config.materialModel.interface)

% Critical Stretch
% Linear Elastic Limit
% Bond Stiffness - No Correction

fprintf('Density (kg/m^3): \t %d \t %d \n', densityConcrete, densitySteel)                    % Density (kg/m^3)
fprintf('E (N/mm^2): \t %d \t %d \n', Econcrete, Esteel)                                      % Young's Modulus (N/mm^2)
fprintf('Fracture Energy (N/m): \t % \t % \n', fractureEnergyConcrete, fractureEnergySteel)   % Fracture Energy (N/m)
% Poisson's Ratio
% Shear Modulus
% Effective Modulus

% =========================================================================
%                        Simulation Paramaters
% =========================================================================

fprintf('Time Step Size DT: \t %d s \n', DT)                % Time Step Size
fprintf('Number of Time Steps: \t %d \n', nTimeSteps)       % Number of Time Steps
fprintf('Simulation Time: \t %d s \n', (DT * nTimeSteps))   % Total Simulation Time
fprintf('Damping: \t %d \n', DAMPING)                       % Damping

% =========================================================================
%                        Additional Details
% =========================================================================

fprintf('Time Integration Scheme: \t Euler - Cromer \n')                              % Time integration
fprintf('Volume Correction Scheme: \t PA - PDLAMMPS algorithm (Seleson, 2014) \n')    % Volume correction scheme
fprintf('Surface Correction Scheme: \t Volume method (Bobaru et al, 2017) \n')        % Surface correction scheme

% ----------------------------- END CODE ----------------------------------

end

