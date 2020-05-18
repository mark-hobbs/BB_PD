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

%% ------------------------------ Load Data -------------------------------

%% ------------------------------- Part 1 ---------------------------------

datageometry            % Load member geometry data
databoundaryconditions  % Initialise boundary conditions - this should move (currently used to initialise CONSTRAINTFLAG, MATERIALFLAG and BODYFORCEFLAG)
undeformedCoordinates = buildmaterialpointcoordinates();    % Build regular grid of nodes

fprintf('Length (x) = %.2fm \nDepth (y) = %.2fm \nWidth (z) = %.2fm \n', memberLength, memberDepth, memberWidth)
fprintf('DX = %.4fm \n', DX)
fprintf('nDivX = %.0f \nnDivY = %.0f \nnDivZ = %.0f \n', nDivX, nDivY, nDivZ)
plotnodes(undeformedCoordinates, 'Material Points', 10, 30, 30)


% ==========================
%       Build supports
% ==========================

% [undeformedCoordinates,CONSTRAINTFLAG,MATERIALFLAG,BODYFORCEFLAG] = buildsupports(DX*10,undeformedCoordinates,CONSTRAINTFLAG,MATERIALFLAG,BODYFORCEFLAG,0,0,1);           % Build first support
% [undeformedCoordinates,CONSTRAINTFLAG,MATERIALFLAG,BODYFORCEFLAG] = buildsupports((nDivX-9.5)*DX,undeformedCoordinates,CONSTRAINTFLAG,MATERIALFLAG,BODYFORCEFLAG,0,0,1);  % Build second support
% nNodes = size(undeformedCoordinates,1);

supportRadius = 5 * DX;
searchRadius = 10.1 * DX;
supportCentreX = [6 * DX, (nDivX - 5) * DX];
supportCentreZ = - supportRadius + DX;
support1 = buildpenetrator(1, supportCentreX(1,1), supportCentreZ, supportRadius, searchRadius, undeformedCoordinates);
support2 = buildpenetrator(2, supportCentreX(1,2), supportCentreZ, supportRadius, searchRadius, undeformedCoordinates);
clear supportRadius searcRadius supportCentreX supportCentreZ
    

% ==========================
%   Build rigid penetrator
% ==========================
penetratorRadius = 50 * DX;
searchRadius = 55.1 * DX;
penetratorCentreX = (nDivX/2) * DX;
penetratorCentreZ = (nDivZ * DX) + penetratorRadius;  
penetrator = buildpenetrator(1, penetratorCentreX, penetratorCentreZ, penetratorRadius, searchRadius, undeformedCoordinates);
distanceX = undeformedCoordinates(penetrator.family,1) - penetrator.centre(:,1);
distanceZ = undeformedCoordinates(penetrator.family,3) - penetrator.centre(:,2);
distance = sqrt((distanceX .* distanceX) + (distanceZ .* distanceZ));
penetrator.centre(1,2) = penetratorCentreZ - (min(distance) - penetratorRadius);    % correct penetrator centre-point
clear penetratorRadius searchRadius penetratorCentreX penetratorCentreZ

% Plot boundary conditions
% plotflags(undeformedCoordinates,BODYFORCEFLAG)
% plotflags(undeformedCoordinates,CONSTRAINTFLAG)
plotdiscretisedmember(undeformedCoordinates,MATERIALFLAG)

% Plot undeformed nodes and check for errors 
plotnodes(undeformedCoordinates, 'Undeformed material points: x-y plane ', 10, 0, 0)
% plotnodes(undeformedCoordinates, 'Undeformed material points', 10, 30, 30)

%% ------------------------------- Part 2 ---------------------------------

% Improve spatial localtiy of data (space filling curve ordering of particles)
% [] = hilbertCurve();

horizon = pi * DX; % Be consistent - this is also known as the horizonRadius

% Build node families, bond lists, and determine undeformed length of every bond
[nFAMILYMEMBERS,NODEFAMILYPOINTERS,NODEFAMILY,BONDLIST,UNDEFORMEDLENGTH] = buildhorizons(undeformedCoordinates,horizon);

% Calculate volume correction factors
VOLUMECORRECTIONFACTORS = calculatevolumecorrectionfactors(UNDEFORMEDLENGTH,horizon,RADIJ);

%% ------------------------------- Part 3 ---------------------------------

% Load material properties
datamaterialproperties

% Load peridynamic parameters
dataPDparameters

% Calculate bond type and bond stiffness (plus stiffness correction)
[BONDSTIFFNESS,BONDTYPE,BFMULTIPLIER] = buildbonddata(BONDLIST,nFAMILYMEMBERS,MATERIALFLAG,bondStiffnessConcrete,bondStiffnessSteel,cellVolume,neighbourhoodVolume,VOLUMECORRECTIONFACTORS);

% Calculate critical stretch values - should move into module 2
criticalStretchConcrete = calculatecriticalstretch(NOD,fractureEnergyConcrete,Econcrete,horizon);
criticalStretchSteel = calculatecriticalstretch(NOD,fractureEnergySteel,Esteel,horizon);

% Assign density values to all nodes
DENSITY = buildnodaldensity(MATERIALFLAG,densityConcrete,densitySteel);

%% ------------------------------- Part 4 ---------------------------------

% Load simulation parameters
datasimulationparameters

% Calculate applied body force per node (cell)
MAXBODYFORCE = calculateappliedbodyforce(BODYFORCEFLAG,appliedLoad,cellVolume);

%% ------------------------------- Part 5 ---------------------------------

% Clear unwanted variables and arrays
clear userInput;

% Save input file and name
fullFileName = createuniqueinputfilename();   % Generate a unique input data file name
save(fullFileName);                           % Save workspace
