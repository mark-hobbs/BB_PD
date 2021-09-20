
% =========================================================================
% Create input files
% Failure and size effect for notched and unnotched concrete beams -
% Gregoire et al., 2013
% =========================================================================

%% Clear workspace 
close all

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

%% FLAGS 

MATERIALFLAG = zeros(nNodes, 1);              % Create flag to identify steel and concrete nodes Concrete = 0 Steel = 1
BODYFORCEFLAG = zeros(nNodes, member.NOD);    % Create flag to identify applied forces  = 0 constrained = 1
CONSTRAINTFLAG = zeros(nNodes, member.NOD);   % Create flag to identify constrained nodes unconstrained = 0 constrained = 1

%% Build supports 

supportRadius = 5 * DX;     % (5 * DX = 25mm)
searchRadius = 10.1 * DX;   % (10.1 * DX = 50.5mm)
supportCentreX = [ (DX * ((0.5 * member.DEPTH)/DX)) , DX * ((3 * member.DEPTH)/DX) + DX ];
supportCentreZ = - supportRadius + DX;
supports(1) = buildpenetrator(1, supportCentreX(1,1), supportCentreZ, supportRadius, searchRadius, undeformedCoordinates);
supports(2) = buildpenetrator(2, supportCentreX(1,2), supportCentreZ, supportRadius, searchRadius, undeformedCoordinates);

clear supportRadius searchRadius supportCentreX supportCentreZ 

%% Build rigid penetrator 

penetratorRadius = 10 * DX;     % (10 * DX = 50mm) (60 * DX = 300mm)
searchRadius = 15.1 * DX;       % (15.1 * DX = 75.5mm) (62.1 * DX = 310.5mm)
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

[BONDLIST, UNDEFORMEDLENGTH, nFAMILYMEMBERS, NODEFAMILYPOINTERS, NODEFAMILY] = buildnotch(undeformedCoordinates, BONDLIST, UNDEFORMEDLENGTH, DX, 17.5, 5.1);

%% Volume correction factors 

% Calculate volume correction factors to improve the accuracy of spatial
% integration
VOLUMECORRECTIONFACTORS = calculatevolumecorrectionfactors(UNDEFORMEDLENGTH,horizon,RADIJ);

%% Material properies 

datamaterialproperties      % Load material properties

[DENSITY] = buildnodaldensity(MATERIALFLAG,material.concrete.density,material.steel.density);

%% Build random field

% Build a random field of compressive strength. Relate material parameters
% to compressive strength using empirical formulas from fib model code.
% fc -> E, ft, Gf

addpath('/Users/mark/Documents/Fellowship/2_Code/RandomField/')

mean_fc = 42.3;    % Mean value of the random field (compressive strength MPa)
std_dev = 5;       % Standard deviation of the random field TODO: rename (this is an existing function)
c1 = 0;            % Threshold value for the correlation function
lc = 1;            % Robin van der Have (2015) recommends that the correlation length is set to 1m

CRV = correlatedRandomVariables(undeformedCoordinates, c1, lc, mean_fc, std_dev);

figure
scatter3(undeformedCoordinates(:,1), undeformedCoordinates(:,2), undeformedCoordinates(:,3), 60, CRV, 'filled')
axis equal
axis tight
colormap jet

set(gca,'visible','off')
set(gca,'xtick',[],'ytick',[])

for i = 1: size(BONDLIST, 1)
   
    nodei = BONDLIST(i,1);
    nodej = BONDLIST(i,2);
    
    fc_nodei = CRV(nodei);
    fc_nodej = CRV(nodej);
    
    fc_bond(i, 1) = (fc_nodei + fc_nodej) / 2;
    
end

% --------------------------------------------
% Empirical formulas from fib model code 2010
% --------------------------------------------

E_bond = 21.5E3 * (fc_bond / 10).^(1/3) * 10^6;    % Eq. (5.1-21)
ft_bond = 0.3 * (fc_bond - 8).^(2/3) * 10^6;       % Eq. (5.1-3a)
GF_bond = 73 * fc_bond.^0.18;                      % Eq. (5.1-9)

%% Peridynamic parameters 

neighbourhoodVolume = (4/3) * pi * horizon^3;   % Neighbourhood volume for node contained within material bulk

%% Bond stiffness correction (surface effects)

% Calculate bond type and bond stiffness (plus stiffness correction)

nBonds = size(BONDLIST, 1);
BONDSTIFFNESS = zeros(nBonds,1);  % Initialise bond stiffness vector
BONDTYPE = zeros(nBonds, 1);

for kBond = 1 : nBonds
        
    nodei = BONDLIST(kBond,1);
    nodej = BONDLIST(kBond,2);
    
    bondStiffness = (12 * E_bond(kBond)) / (pi * horizon^4);
        
    % Calculate stiffening factor - surface corrections for 2D/3D problem
    nodeiNeighbourhoodVolume = nFAMILYMEMBERS(nodei) * cellVolume;                                              % Neighbourhood area/volume for Node 'i'
    nodejNeighbourhoodVolume = nFAMILYMEMBERS(nodej) * cellVolume;                                              % Neighbourhood area/volume for Node 'j'
    stiffeningFactor = (2 * neighbourhoodVolume) / ((nodeiNeighbourhoodVolume + nodejNeighbourhoodVolume));     % Calculate stiffening correction factor - should the following be included: * VOLUMECORRECTIONFACTORS(kBond) 
    BONDSTIFFNESS(kBond) = stiffeningFactor * bondStiffness;                                                    % Correct the bond stiffness
    
end

%% Fracture energy corrections - TO FINISH
 
for i = 1 : size(BONDLIST, 1)
    
    s0(i, 1) = (ft_bond(i) / E_bond(i)); 
        
    % Decaying exponential
    k = 25;
    alpha = 0.25;
    sc(i, 1) = (10 * k * (1 - exp(k)) * (GF_bond(i) - (pi * BONDSTIFFNESS(i) * horizon^5 * s0(i)^2 * (2 * k - 2 * exp(k) + alpha * k - alpha * k * exp(k) + 2)) / (10 * k * (exp(k) - 1) * (alpha + 1))) * (alpha + 1)) / (BONDSTIFFNESS(i) * horizon^5 * s0(i) * pi * (2 * k - 2 * exp(k) + alpha * k - alpha * k * exp(k) + 2));

end

clear i beta gamma k alpha; 

%% Simulation Parameters

simulation.SAFETYFACTOR = 1;                                                                                                               % Time step safety factor - to reduce time step size and ensure stable simulation
simulation.DT = (0.8 * sqrt(2 * material.concrete.density * DX / (pi * horizon^2 * DX * max(BONDSTIFFNESS)))) / simulation.SAFETYFACTOR;   % Minimum stable time step

simulation.nTimeSteps = 200000;              % Number of time steps
simulation.DAMPING = 0;                      % Damping coefficient
simulation.appliedDisplacement = -1E-3;      % Applied displacement (m) (-0.5E-3)
simulation.referenceNode = 18;               % Define a reference point/node for measuring deflections (18, 35, 70, 140) (B4, B3, B2, B1 - DX = 5mm)
simulation.CMOD = [10 25];                   % Define reference nodes for measuring CMOD ([10 25], [25 45], [50 90], [100 180])
simulation.timeStepTracker = 1;              % Tracker for determining previous time step when restarting simulations
