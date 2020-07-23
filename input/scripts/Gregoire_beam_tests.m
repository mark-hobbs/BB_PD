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
supportCentreX = [ (DX * (0.025/DX)) , DX * (0.15/DX) + DX ];
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

%% Build half or fifth-notch

[BONDLIST, UNDEFORMEDLENGTH] = buildnotch(undeformedCoordinates, BONDLIST, UNDEFORMEDLENGTH, DX, 18, 2.1);

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

% G0 = 0.005339846 * 1000; % N/mm -> N/m
 
% for i = 1 : size(BONDLIST, 1)
%     
%     % s0(i,1) = sqrt((10 * G0) / (pi * BONDSTIFFNESS(i,1) * horizon^5));
%     
%     beta = 0.25;
%     gamma = (2 + 2 * beta) / (2 * beta * (1 - beta));
%     s0 = 9.4595E-05;
%     sc(i,1) = (10 * gamma * material.concrete.fractureEnergy) / (pi * horizon^5 * BONDSTIFFNESS(i,1) * s0 * (1 + gamma * beta)) + s0;
%     s1(i,1) = (sc(i,1) - s0) /  gamma + s0;
%         
% end

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
