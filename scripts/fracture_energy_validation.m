% =========================================================================
%                   Fracture Energy Validation
% =========================================================================

% By determining the energy required to break a single bond, the energy per
% unit fracture area for complete seperation of a peridynamic body can be
% determined. The energy required to break a single bond will increase if
% surface correction factors are applied to a peridynamic body. Therefore
% the calculated critical stretch value for a three-dimensional peridynamic
% material will be wrong and the predicted failure load will be higher than
% that observed experimentally. 

%% Clear workspace 
% close all
clear all
clc

%% Geometry and Discretisation 

member.NOD = 3;          % Number of degrees of freedom
member.LENGTH = 1;       % x-axis (m) 
member.WIDTH = 1;        % y-axis (m) 
member.DEPTH = 1;        % z-axis (m)

DX = 50/1000;                       % Spacing between material points (mm)
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

%% Build node families 

horizon = pi * DX; % 3.90 - 3.95

% Build node families, bond lists, and determine undeformed length of every bond
[nFAMILYMEMBERS, NODEFAMILYPOINTERS, NODEFAMILY, BONDLIST, UNDEFORMEDLENGTH] = buildhorizons(undeformedCoordinates, horizon);

%% Volume correction factors 

% Calculate volume correction factors to improve the accuracy of spatial
% integration
VOLUMECORRECTIONFACTORS = calculatevolumecorrectionfactors(UNDEFORMEDLENGTH, horizon, RADIJ);

%% Material properies 

%----------------------------- Density ------------------------------------

material.concrete.density = 2400;     % Density concrete (kg/m^3)

%------------------------- Young's Modulus --------------------------------

material.concrete.E = 30E9;       % Young's modulus (remember to convert cubic test results to cylindrical equivalent) 

%------------------------- Fracture Energy --------------------------------

material.concrete.fractureEnergy = 100;   % Fracture energy (N/m)

%% Peridynamic parameters 

neighbourhoodVolume = (4/3) * pi * horizon^3;   % Neighbourhood volume for node contained within material bulk

bond.concrete.stiffness = (12 * material.concrete.E) / (pi * horizon^4);    % Bond stiffness 3D

bond.concrete.s0 = sqrt( (5 * material.concrete.fractureEnergy) / (6 * material.concrete.E  * horizon) );  % constitutive law
% bond.concrete.s0 = sqrt( (10 * material.concrete.fractureEnergy) / (pi * bond.concrete.stiffness  * horizon^5) );  % constitutive law

%% Bond stiffness correction (surface effects)

% Calculate bond type and bond stiffness (plus stiffness correction)
[BONDSTIFFNESS, BONDTYPE, BFMULTIPLIER, stiffeningFactor] = buildbonddata(BONDLIST, nFAMILYMEMBERS, MATERIALFLAG, bond.concrete.stiffness, 1, cellVolume, neighbourhoodVolume, VOLUMECORRECTIONFACTORS);

nBonds = size(BONDLIST,1);

for i = 1 : nBonds
   
    s0(i,1) = sqrt( (10 * material.concrete.fractureEnergy) / (pi * bond.concrete.stiffness * stiffeningFactor(i,1)  * horizon^5) );
    
end

%% Determine numerically the energy per unit fracture area for complete seperation of a unit cube

counter = 0;
totalEnergy = 0;
totalEnergySC = 0;
tol = 0;  % tolerance
plane_depth = 0.5 + (DX/2);

% A = [0 0 0.525];
% B = [0 1 0.525];
% C = [0.02501 1 0.525];
% D = [0.02501 0 0.525];

% A = [0.025 0 0.525];
% B = [0.025 1 0.525];
% C = [0.075 1 0.525];
% D = [0.075 0 0.525];

A = [0 0 plane_depth];
B = [0 1 plane_depth];
C = [1 1 plane_depth];
D = [1 0 plane_depth];

% A = [0.5 - tol 0.5 - tol plane_depth];
% B = [0.5 - tol 1.5 + tol plane_depth];
% C = [1.5 + tol 1.5 + tol plane_depth];
% D = [1.5 + tol 0.5 - tol plane_depth];


% Check and flag if a bond intersects with the defined 2D plane

for kBond = 1 : nBonds
    
    nodei = BONDLIST(kBond,1); % Node i
    nodej = BONDLIST(kBond,2); % Node j
    
    [intersection] = determineintersection(A, B, C, D, undeformedCoordinates(nodei,:), undeformedCoordinates(nodej,:));
    
    if intersection == 1
        
        counter = counter + 1;
        
        bondEnergy = ( (bond.concrete.stiffness * bond.concrete.s0^2 * UNDEFORMEDLENGTH(kBond,1)) / 2 ) * cellVolume^2; % * VOLUMECORRECTIONFACTORS(kBond, 1);
        bondEnergySC = ( (BONDSTIFFNESS(kBond,1) * bond.concrete.s0^2 * UNDEFORMEDLENGTH(kBond,1)) / 2 ) * cellVolume^2; % * VOLUMECORRECTIONFACTORS(kBond, 1);
        % bondEnergySC = ( (BONDSTIFFNESS(kBond,1) * s0(kBond,1)^2 * UNDEFORMEDLENGTH(kBond,1)) / 2 ) * cellVolume^2; % * VOLUMECORRECTIONFACTORS(kBond, 1);
        totalEnergy = totalEnergy + bondEnergy;
        totalEnergySC = totalEnergySC + bondEnergySC;
     
        reducedBL(counter,:) = [nodei, nodej];
        reducedUL(counter,:) = UNDEFORMEDLENGTH(kBond,1);
        reducedBS(counter,:) = BONDSTIFFNESS(kBond,1);
        
    end
                
end
   
area = (1 * 1);
fprintf('Fracture energy without surface corrections: %.2f \n', totalEnergy/area)
fprintf('Fracture energy with surface corrections: %.2f \n', totalEnergySC/area)  

%% Plot bonds that cross the defined 2D plane

figure

for kBond = 1 : size(reducedBL,1)

    nodei = reducedBL(kBond,1); % Node i
    nodej = reducedBL(kBond,2); % Node j
     
    
    pt1 = [undeformedCoordinates(nodei,1), undeformedCoordinates(nodei,2), undeformedCoordinates(nodei,3)];
    pt2 = [undeformedCoordinates(nodej,1), undeformedCoordinates(nodej,2), undeformedCoordinates(nodej,3)];
    pts = [pt1; pt2]; % vertial concatenation
    plot3(pts(:,1), pts(:,2), pts(:,3), 'LineWidth', 0.75)
    
    hold on     
    
end

% A = [0.5 - tol 0.5 - tol plane_depth];
% B = [0.5 - tol 1.5 + tol plane_depth];
% C = [1.5 + tol 1.5 + tol plane_depth];
% D = [1.5 + tol 0.5 - tol plane_depth];

plot3( [A(1) B(1) C(1) D(1) A(1)], [A(2) B(2) C(2) D(2) A(2)], [A(3) B(3) C(3) D(3) A(3)], 'Color', 'k', 'LineWidth', 2.5 ) 
% tol = 0.1; plot3( [A(1) B(1) (C(1) + tol) (D(1) + tol) A(1)], [A(2) B(2) C(2) D(2) A(2)], [A(3) B(3) C(3) D(3) A(3)], 'Color', 'k', 'LineWidth', 2.5 ) % for plotting 2D view - view(90,0)
scatter3(undeformedCoordinates(reducedBL(:,1),1), undeformedCoordinates(reducedBL(:,1),2), undeformedCoordinates(reducedBL(:,1),3), 20, 'b', 'filled')
scatter3(undeformedCoordinates(reducedBL(:,2),1), undeformedCoordinates(reducedBL(:,2),2), undeformedCoordinates(reducedBL(:,2),3), 20, 'b', 'filled')

x = max(undeformedCoordinates(:,1));
y = max(undeformedCoordinates(:,2));
z = max(undeformedCoordinates(:,3));
plotcube([x y z],[0 0 0],0,1.5)
set(gca,'XTick',[], 'YTick', [], 'ZTick', [])
set(gca,'XTickLabel',[], 'YTickLabel', [], 'ZTickLabel', [])
set(gca,'visible','off')
% xlabel('x', 'interpreter', 'latex')
% ylabel('y', 'interpreter', 'latex')
% zlabel('z', 'interpreter', 'latex')

axis equal
% view(90,0)
% set(gcf, 'Units', 'centimeters', 'Position', [2, 2, 18, 5], 'PaperUnits', 'centimeters', 'PaperSize', [18, 5])
view(0,0)
set(gcf, 'Units', 'centimeters', 'Position', [2, 2, 8, 8], 'PaperUnits', 'centimeters', 'PaperSize', [8, 8])
    