% -------------------------------------------------------------------------
% Module 1: Create Input Data File - Member Geometry, Discretisation and
% Boundary Conditions
% -------------------------------------------------------------------------

% This script is used to create input files for BB_PD. The output is saved
% and loaded by Module 2: Solution

% This module lacks robustness and the generation of unique geometries and
% boundary conditions will require some thought from the user. It is
% important that the user checks the geometry and boundary conditions to
% ensure that everything is as expected. 

% In future work, a graphical user interface will be implemented. This will
% significantly increase the speed of generating input files and will allow
% for the creation of increasingly complex input files.

% Part 1: Discretise the member and apply boundary conditions
% (CONSTRAINTFLAG, BODYFORCEFLAG, MATERIALFLAG)

% Part 2: Build node families, bond lists, determine underformed length of
% every bond, calculate volume correction factors. The code could be
% speeded up by ordering the bond list to prevent cache misses.

% Part 3: Build bond data, calculate bond stiffness and apply stiffness
% correction factors for every bond, calculate critical stretch, create a
% density vector

% Part 4: Specify simulation parameters, calculate applied body force per
% cell

% Part 5: Clear unwanted variables and save with a unique file name

% Outputs:
%   appliedLoad ? move to simulation setup
%   BFMULTIPLIER
%   BODYFORCEFLAG
%   BONDLIST
%   BONDSTIFFNESS ?
%   bondStiffnessConcrete ?
%   bondStiffnessSteel ?
%   BONDTYPE
%   BUILDUP ? delete
%   cellVolume
%   CONSTRAINTFLAG
%   criticalStretchConcrete ?
%   criticalStretchSteel ?
%   DAMPING ? needs moved to simulation setup
%   densityConcrete ?
%   densitySteel    ?
%   DT ?
%   DX
%   DY ? delete
%   DZ ? delete
%   Econcrete ?
%   Esteel    ?
%   effectiveModulusConcrete ?
%   effectiveModulusSteel    ?
%   equilibriumTolerance     ?
%   fractureEnergyConcrete   ?
%   fractureEnergySteel      ?
%   fullFileName ?
%   Gconcrete ?
%   Gsteel    ?
%   horizon
%   MATERIALFLAG
%   MAXBODYFORCE ?
%   memberHeight
%   memberLength
%   memberWidth
%   nDivX
%   nDivY
%   nDivZ
%   neighbourhoodVolume
%   nFAMILYMEMBERS
%   nNodes
%   NOD
%   NODEFAMILY
%   NODEFAMILYPOINTERS
%   nTimeSteps  ? needs moved to simulation setup
%   RADIJ
%   SAFETYFACTOR ?
%   supportCoordinates      ? tidy up
%   supportCoordinates2     ? tidy up
%   timeStepTracker         ? needs moved to simulation setup
%   undeformedCoordinates
%   undeformedLength
%   Vconcrete   ?
%   Vsteel      ?
%   VOLUMECORRECTIONFACTORS

% =========================================================================
% Create input files
% Failure and size effect for notched and unnotched concrete beams -
% Gregoire et al., 2013
% =========================================================================

%% Clear workspace 
close all
clear all
clc
fprintf('Module 1: Create input data file \n')

%% Geometry and Discretisation 

member.NOD = 3;             % Number of degrees of freedom
member.LENGTH = 0.175;      % x-axis (m) 
member.WIDTH = 0.05;        % y-axis (m) 
member.DEPTH = 0.05;        % z-axis (m)

DX = 5/1000;                        % Spacing between material points (mm)
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

plotnodes(undeformedCoordinates, 'Undeformed material points: x-y plane', 10, 0, 0)    % Plot undeformed nodes and check for errors
plotnodes(undeformedCoordinates, 'Undeformed material points', 10, 30, 30)

%% FLAGS 

MATERIALFLAG = zeros(nNodes, 1);              % Create flag to identify steel and concrete nodes Concrete = 0 Steel = 1
BODYFORCEFLAG = zeros(nNodes, member.NOD);    % Create flag to identify applied forces  = 0 constrained = 1
CONSTRAINTFLAG = zeros(nNodes, member.NOD);   % Create flag to identify constrained nodes unconstrained = 0 constrained = 1

%% Build supports 

supportRadius = 5 * DX;
searchRadius = 10.1 * DX;
supportCentreX = [ (DX * (0.025/DX)) , DX * (0.15/DX) ];
supportCentreZ = - supportRadius + DX;
supports(1) = buildpenetrator(1, supportCentreX(1,1), supportCentreZ, supportRadius, searchRadius, undeformedCoordinates);
supports(2) = buildpenetrator(2, supportCentreX(1,2), supportCentreZ, supportRadius, searchRadius, undeformedCoordinates);

% [undeformedCoordinates,CONSTRAINTFLAG,MATERIALFLAG,BODYFORCEFLAG] = buildsupports(supportCentreX(1,1),DX,nDivX,nDivY,nDivZ,undeformedCoordinates,CONSTRAINTFLAG,MATERIALFLAG,BODYFORCEFLAG,0,0,1);  % Build first support
% [undeformedCoordinates,CONSTRAINTFLAG,MATERIALFLAG,BODYFORCEFLAG] = buildsupports(supportCentreX(1,2),DX,nDivX,nDivY,nDivZ,undeformedCoordinates,CONSTRAINTFLAG,MATERIALFLAG,BODYFORCEFLAG,0,0,1);  % Build second support
% plotdiscretisedmember(undeformedCoordinates,MATERIALFLAG)

clear supportRadius searchRadius supportCentreX supportCentreZ 

%% Build rigid penetrator 

penetratorRadius = 10 * DX;
searchRadius = 15.1 * DX;
penetratorCentreX = (nDivX/2) * DX;
penetratorCentreZ = (nDivZ * DX) + penetratorRadius;  
penetrator = buildpenetrator(1, penetratorCentreX, penetratorCentreZ, penetratorRadius, searchRadius, undeformedCoordinates);
distanceX = undeformedCoordinates(penetrator.family,1) - penetrator.centre(:,1);
distanceZ = undeformedCoordinates(penetrator.family,3) - penetrator.centre(:,2);
distance = sqrt((distanceX .* distanceX) + (distanceZ .* distanceZ));
penetrator.centre(1,2) = penetratorCentreZ - (min(distance) - penetratorRadius);    % correct penetrator centre-point

for i = 1 : size(penetrator.family, 1)
    
    j = penetrator.family(i);
    
    BODYFORCEFLAG(j,3) = 1;
        
end

clear penetratorRadius searchRadius penetratorCentreX penetratorCentreZ distanceX distanceZ distance i j

%% Build node families 

% Improve spatial localtiy of data (space filling curve ordering of particles)

horizon = pi * DX; % Be consistent - this is also known as the horizonRadius

% Build node families, bond lists, and determine undeformed length of every bond
[nFAMILYMEMBERS,NODEFAMILYPOINTERS,NODEFAMILY,BONDLIST,UNDEFORMEDLENGTH] = buildhorizons(undeformedCoordinates,horizon);

%% Volume correction factors 

% Calculate volume correction factors to improve the accuracy of spatial
% integration
VOLUMECORRECTIONFACTORS = calculatevolumecorrectionfactors(UNDEFORMEDLENGTH,horizon,RADIJ);

%% Material properies 

datamaterialproperties      % Load material properties

[DENSITY] = buildnodaldensity(MATERIALFLAG,material.concrete.density,material.steel.density);

%% Peridynamic parameters 

neighbourhoodVolume = (4/3) * pi * horizon^3;   % Neighbourhood volume for node contained within material bulk

bond.concrete.stiffness = (12 * material.concrete.E) / (pi * horizon^4);    % Bond stiffness 3D
bond.steel.stiffness = (12 * material.steel.E) / (pi * horizon^4);          % Bond stiffness 3D

bond.concrete.s0 = 8.75009856494892E-05;  % constitutive law
bond.concrete.sc = 2.18752464123723E-03;
bond.steel.sc = 1;

%% Bond stiffness correction (surface effects)

% Calculate bond type and bond stiffness (plus stiffness correction)
[BONDSTIFFNESS,BONDTYPE,BFMULTIPLIER] = buildbonddata(BONDLIST,nFAMILYMEMBERS,MATERIALFLAG,bond.concrete.stiffness,bond.steel.stiffness,cellVolume,neighbourhoodVolume,VOLUMECORRECTIONFACTORS);

G0 = 0.005339846 * 1000; % N/mm -> N/m

for i = 1 : size(BONDLIST, 1)
    
    s0(i,1) = sqrt((10 * G0) / (pi * BONDSTIFFNESS(i,1) * horizon^5));
        
end

%% Build half or fifth-notch

nBonds = size(BONDLIST,1);

x_max = max(undeformedCoordinates(:,1));
y_max = max(undeformedCoordinates(:,2));
z_max = max(undeformedCoordinates(:,3));
x_min = min(undeformedCoordinates(:,1));
y_min = min(undeformedCoordinates(:,2));
z_min = min(undeformedCoordinates(:,3));

A = [18*DX y_min z_min];
B = [18*DX y_max z_min];
C = [18*DX y_max 2.1*DX];
D = [18*DX y_min 2.1*DX];
counter = 0;

% Calculate the nodal force (N/m^3) for every node, iterate over the bond list
for kBond = 1 : nBonds
    
    nodei = BONDLIST(kBond,1); % Node i
    nodej = BONDLIST(kBond,2); % Node j
    
    [checkcheck] = determineintersection(A, B, C, D, undeformedCoordinates(nodei,:), undeformedCoordinates(nodej,:));
    
    if checkcheck == 1
        
        counter = counter + 1;
        newBL(counter,:) = [nodei, nodej];
        newUL(counter,:) = UNDEFORMEDLENGTH(kBond,1);
        BONDSTIFFNESS(kBond,1) = 0;
        
    end
        
        
end


for kBond = 1 : size(newBL,1)

    nodei = newBL(kBond,1); % Node i
    nodej = newBL(kBond,2); % Node j
    
    % Plot bond
    pt1 = [undeformedCoordinates(nodei,1), undeformedCoordinates(nodei,2), undeformedCoordinates(nodei,3)];
    pt2 = [undeformedCoordinates(nodej,1), undeformedCoordinates(nodej,2), undeformedCoordinates(nodej,3)];
    pts = [pt1; pt2]; % vertial concatenation
    plot3(pts(:,1), pts(:,2), pts(:,3), 'LineWidth', 0.75)
    
    hold on     
    

end


plot3( [A(1) B(1) C(1) D(1) A(1)], [A(2) B(2) C(2) D(2) A(2)], [A(3) B(3) C(3) D(3) A(3)], 'Color', 'k', 'LineWidth', 2 )
% scatter3(undeformedCoordinates(newBL(:,1),1), undeformedCoordinates(newBL(:,1),2), undeformedCoordinates(newBL(:,1),3), 20, 'b', 'filled')
% scatter3(undeformedCoordinates(newBL(:,2),1), undeformedCoordinates(newBL(:,2),2), undeformedCoordinates(newBL(:,2),3), 20, 'b', 'filled')

plotcube([(x_max - DX) (y_max - DX) (z_max - DX)],[x_min x_min x_min],0,1.5)
set(gca,'XTick',[], 'YTick', [], 'ZTick', [])
set(gca,'XTickLabel',[], 'YTickLabel', [], 'ZTickLabel', [])
% set(gca,'visible','off')
xlabel('x', 'interpreter', 'latex')
ylabel('y', 'interpreter', 'latex')
zlabel('z', 'interpreter', 'latex')
axis equal

%% Simulation Parameters

SAFETYFACTOR = 1;                                                                                                          % Time step safety factor - to reduce time step size and ensure stable simulation
DT = (0.8 * sqrt(2 * material.concrete.density * DX / (pi * horizon^2 * DX * bond.concrete.stiffness))) / SAFETYFACTOR;     % Minimum stable time step

nTimeSteps = 200000;              % Number of time steps
DAMPING = 0;                      % Damping coefficient
appliedDisplacement = -0.5E-3;    % Applied displacement (m)
referenceNode = 18;               % Define a reference point/node for measuring deflections
timeStepTracker = 1;              % Tracker for determining previous time step when restarting simulations


% Calculate applied body force per node (cell)
% MAXBODYFORCE = calculateappliedbodyforce(BODYFORCEFLAG,appliedLoad,cellVolume);

%% Save input file

% Clear unwanted variables and arrays
clear userInput;

% Save input file and name
fullFileName = createuniqueinputfilename();   % Generate a unique input data file name
save(fullFileName);                           % Save workspace
