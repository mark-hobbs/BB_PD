function [] = printsimulationsetup(inputdatafilename, config)
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

load(inputdatafilename)
m_mm = 1000; % Convert metres to millimetres
nBonds = size(BONDLIST,1);

fprintf('\n===============================================================================\n')
fprintf('                             Simulation Parameters                             \n')
fprintf('===============================================================================\n')

% =========================================================================
%                              Input File
% =========================================================================

fprintf('\nInput file: \t %s \n\n', inputdatafilename)

% =========================================================================
%                       Geometry and Discretisation
% =========================================================================

fprintf('Length (x-axis): \t %8.3f m \t Discretisation: \t %6d nodes \n', memberLength, nDivX)   % Length (x-axis)
fprintf('Width (y-axis): \t %8.3f m \t Discretisation: \t %6d nodes \n', memberWidth, nDivY)     % Width (y-axis)
fprintf('Depth (z-axis): \t %8.3f m \t Discretisation: \t %6d nodes \n\n', memberHeight, nDivZ)  % Depth (z-axis)

fprintf('Number of nodes: \t %10d \t %10d \t %10d \n', nNodes, sum(MATERIALFLAG == 0), sum(MATERIALFLAG == 1))                        % total | concrete | steel
fprintf('Number of bonds: \t %10d \t %10d \t %10d \t %10d \n\n', nBonds, sum(BONDTYPE == 0), sum(BONDTYPE == 1), sum(BONDTYPE == 2))  % total | concrete | steel | interface

fprintf('DX:%37.3f mm \n', DX * m_mm)                                           % DX
fprintf('Cell Volume:%28.3f mm^3 \n', cellVolume * m_mm^3)                      % Cell Volume 
fprintf('Horizon Radius:%25.3f mm \n', horizonRadius * m_mm)                    % Horizon 
fprintf('Neigbourhood Volume:%20.3f mm^3 \n\n', neighbourhoodVolume * m_mm^3)   % Neighbourhood Volume (Field width = 40)

fprintf('Family Size Max/Min: \t %d \t / \t %d \n\n', max(nFAMILYMEMBERS), min(nFAMILYMEMBERS))  % Nodal family size

% Radius

% Supports

% Penetrators

% =========================================================================
%                               Solver
% =========================================================================

% Solver: Dynamic / Static
fprintf('Solver:%43s\n', config.solver) 

% Loading Method: Load Controlled / Displacement Controlled
fprintf('Loading method:%35s\n', config.loadingMethod) 

% Failure Functionality: on / off
fprintf('Failure functionality:%28s\n\n', config.failureFunctionality) % (Field Width = 50)

% =========================================================================
%                         Material Properties
% =========================================================================

% fprintf('Concrete\n')
% fprintf('\t - Cubic Compressive Strength (N/mm^2): \t \n')           % Compressive strength (cubic)
% fprintf('\t - Cylindrical Compressive Strength (N/mm^2): \t \n')     % Compressive strength (cylindrical)
% fprintf('\t - Tensile Strength (N/mm^2): \t \n\n')                   % Tensile strength

fprintf('Modulus of Elasticity (N/mm^2):%15.3E\t%10.3E\n', Econcrete, Esteel)                      % Modulus of Elasticity (Young's Modulus) (N/mm^2)
fprintf('Fracture Energy (N/m):%24.2f\t%10.2f \n', fractureEnergyConcrete, fractureEnergySteel)    % Fracture Energy (N/m)
fprintf('Density (kg/m^3):%29.2f\t%10.2f \n\n', densityConcrete, densitySteel)                     % Density (kg/m^3)

% Poisson's Ratio
% Shear Modulus
% Effective Modulus

fprintf('Bond Stiffness (no correction):%15.3E\t%10.3E \n\n', bondStiffnessConcrete, bondStiffnessSteel)  % Bond stiffness (no correction)

% Material Model: Concrete | Steel | Interface
% fprintf('Concrete: %s \t Steel: %s \t Interface: %s \n\n', config.materialModel.concrete, config.materialModel.steel, config.materialModel.interface)
% Critical Stretch
% Linear Elastic Limit
% Yielding Stretch Steel

% =========================================================================
%                        Simulation Paramaters
% =========================================================================

fprintf('Time Step Size DT:%20.5E s \n', DT)                                % Time Step Size (Field width = 38)
fprintf('Number of Time Steps:%17d \n', nTimeSteps)                         % Number of Time Steps 
fprintf('Simulation Time:%22.5f s \n', (DT * nTimeSteps))                   % Total Simulation Time
fprintf('Damping:%30d \n', DAMPING)                                         % Damping
fprintf('Applied Displacement:%17.2f mm \n\n', appliedDisplacement * m_mm)  % Applied displacement

% =========================================================================
%                        Output Configuration
% =========================================================================

% Reference point/node for measuring deflections
fprintf('Reference point: \t node %d (%.4f m, %.4f m, %.4f m) \n\n', referenceNode, undeformedCoordinates(referenceNode,1), undeformedCoordinates(referenceNode,2), undeformedCoordinates(referenceNode,3))  

% =========================================================================
%                        Additional Details
% =========================================================================

fprintf('Time Integration Scheme: \t Euler - Cromer \n')                              % Time integration
fprintf('Volume Correction Scheme: \t PA - PDLAMMPS algorithm (Seleson, 2014) \n')    % Volume correction scheme
fprintf('Surface Correction Scheme: \t Volume method (Bobaru et al, 2017) \n\n')      % Surface correction scheme

fprintf('===============================================================================\n\n\n\n')

% ----------------------------- END CODE ----------------------------------

end

