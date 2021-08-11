% =========================================================================
%       One-point quadrature convergence in a 3D peridynamic model
% =========================================================================

% Clear workspace 
close all
clear all
clc

% =========================================================================
%                       Geometry and Discretisation
% =========================================================================

member.NOD = 3;          % Number of degrees of freedom
member.LENGTH = 1;       % x-axis (m) 
member.WIDTH = 1;        % y-axis (m) 
member.DEPTH = 1;        % z-axis (m)

DX = 50/1000;       % Spacing between material points (mm)
nDivX = round(member.LENGTH/DX);    % Number of divisions in x-direction    
nDivY = round(member.WIDTH/DX);     % Number of divisions in y-direction    
nDivZ = round(member.DEPTH/DX);     % Number of divisions in z-direction   
cellVolume = DX^3;                  % Cell volume
RADIJ = DX/2;                       % Material point radius

memberLength = nDivX * DX;     % Length (m) - x
memberDepth = nDivY * DX;      % Depth (m) - y
memberWidth = nDivZ * DX;      % Width (m) - z

undeformedCoordinates = buildmaterialpointcoordinates(member.NOD, DX, nDivX, nDivY, nDivZ);    % Build regular grid of nodes
nNodes = size(undeformedCoordinates , 1);

fprintf('Length (x) = %.2fm \nDepth (y) = %.2fm \nWidth (z) = %.2fm \n', memberLength, memberDepth, memberWidth)
fprintf('DX = %.4fm \n', DX)
fprintf('nDivX = %.0f \nnDivY = %.0f \nnDivZ = %.0f \n', nDivX, nDivY, nDivZ)

% plotnodes(undeformedCoordinates, 'Undeformed material points: x-y plane ', 10, 0, 0)    % Plot undeformed nodes and check for errors
% plotnodes(undeformedCoordinates, 'Undeformed material points', 10, 30, 30)

MATERIALFLAG = zeros(nNodes, 1);

% =========================================================================
%                                  Loop
% =========================================================================

counter = 0;

for i = 2 : 0.1 : 10
    
    counter = counter + 1;
    horizon = i * DX; 

    % Build node families, bond lists, and determine undeformed length of every bond
    [nFAMILYMEMBERS, NODEFAMILYPOINTERS, NODEFAMILY, BONDLIST, UNDEFORMEDLENGTH] = buildhorizons(undeformedCoordinates, horizon);

    % Volume correction factors to improve the accuracy of spatial integration
    VOLUMECORRECTIONFACTORS = calculatevolumecorrectionfactors(UNDEFORMEDLENGTH, horizon, RADIJ);

    % Calculate the discrete volume of every node horizon
    [DISCRETEVOLUME] = calculatediscretevolume(BONDLIST, VOLUMECORRECTIONFACTORS, cellVolume, nNodes);

    % Material properies 
    material.concrete.density = 2400;           % Density concrete (kg/m^3)
    material.concrete.E = 30E9;                 % Young's modulus (remember to convert cubic test results to cylindrical equivalent) 
    material.concrete.fractureEnergy = 100;     % Fracture energy (N/m)

    % Peridynamic parameters 
    neighbourhoodVolume = (4/3) * pi * horizon^3;                                   % Neighbourhood volume for node contained within material bulk
    % bond.concrete.stiffness = (12 * material.concrete.E) / (pi * horizon^4);        % Bond stiffness 3D
    % bond.concrete.s0 = sqrt( (10 * material.concrete.fractureEnergy) / (pi * bond.concrete.stiffness  * horizon^5) );  % critical stretch
    % W_PD = (pi * bond.concrete.stiffness * bond.concrete.s0^2 * horizon^4) / 4;
    
    % Triangular influence function
    bond.concrete.stiffness = (60 * material.concrete.E) / (pi * horizon^4);    % Bond stiffness 3D
    bond.concrete.s0 = sqrt( (60 * material.concrete.fractureEnergy) / (pi * bond.concrete.stiffness  * horizon^5) );  % critical stretch
    W_PD = (pi * bond.concrete.stiffness * bond.concrete.s0^2 * horizon^4) / 20; 

    % Calculate bond type and bond stiffness (plus stiffness correction)
    [BONDSTIFFNESS,BONDTYPE,BFMULTIPLIER,stiffeningFactor] = buildbonddata(BONDLIST, nFAMILYMEMBERS, MATERIALFLAG, bond.concrete.stiffness, 1, cellVolume, neighbourhoodVolume, VOLUMECORRECTIONFACTORS);

    % Output
    [strainenergydensityFA, strainenergydensityPA] = calculatediscretestrainenergydensity(BONDLIST, nNodes, bond.concrete.stiffness, bond.concrete.s0, cellVolume, UNDEFORMEDLENGTH, VOLUMECORRECTIONFACTORS, horizon);

    m_ratio(counter,1) = horizon / DX;
    
    error(counter,1) = (max(nFAMILYMEMBERS) * cellVolume) / neighbourhoodVolume;  % FA
    error_2(counter,1) = max(DISCRETEVOLUME) / neighbourhoodVolume;               % PA - PDLAMMPS
    
    error_3(counter,1) = max(strainenergydensityFA) / W_PD;                       % FA strain energy density
    error_4(counter,1) = max(strainenergydensityPA) / W_PD;                       % PA - PDLAMMPS strain energy density

end

%% Plot

figure
plot(m_ratio, error, 'k' , 'LineWidth' , 0.75); hold on
plot(m_ratio, error_2, 'b' , 'LineWidth' , 0.75)
yline(1, 'k--', 'LineWidth', 1)

xlabel('\(m = \delta / \Delta x\)' , 'Interpreter' , 'latex', 'FontSize' , 10)
ylabel('discrete approximation / analytical volume' , 'Interpreter' , 'latex' , 'FontSize' , 10)
legend('FA' , 'PA - PDLAMMPS' , 'Interpreter' , 'latex' , 'FontSize' , 8)

set(gca,'TickLabelInterpreter','latex') 
set(gca,'fontsize',8)                  
set(gcf, 'Units', 'centimeters', 'Position', [2, 2, 12, 8.5], 'PaperUnits', 'centimeters', 'PaperSize', [12, 8.5]) 


figure
plot(m_ratio, error_3, 'k' , 'LineWidth' , 0.75); hold on
plot(m_ratio, error_4, 'b' , 'LineWidth' , 0.75)
plot(m_ratio, error, 'k--' , 'LineWidth' , 0.5)
plot(m_ratio, error_2, 'b--' , 'LineWidth' , 0.5)
yline(1, 'k--', 'LineWidth', 1)

xlabel('\(m = \delta / \Delta x\)' , 'Interpreter' , 'latex', 'FontSize' , 10)
ylabel('discrete approximation / analytical value \(W_{PD}\)' , 'Interpreter' , 'latex' , 'FontSize' , 10)
legend('FA' , 'PA - PDLAMMPS' , 'Interpreter' , 'latex' , 'FontSize' , 8)

set(gca,'TickLabelInterpreter','latex') 
set(gca,'fontsize',8)                  
set(gcf, 'Units', 'centimeters', 'Position', [2, 2, 12, 8.5], 'PaperUnits', 'centimeters', 'PaperSize', [12, 8.5]) 



