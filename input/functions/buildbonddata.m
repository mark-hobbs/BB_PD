function [BONDSTIFFNESS,BONDTYPE,BFMULTIPLIER] = buildbonddata(BONDLIST,nFAMILYMEMBERS,MATERIALFLAG,bondStiffnessConcrete,bondStiffnessSteel,cellVolume,neighbourhoodVolume,VOLUMECORRECTIONFACTORS)
% Build bond data - determine the bond type and stiffness connecting node
% pairs (e.g. is it a concrete or steel bond?)

tic

%% Constants
nBonds = size(BONDLIST,1);

%% Main body of build bond data

BONDSTIFFNESS = zeros(nBonds,1);  % Initialise bond stiffness vector
BONDTYPE = zeros(nBonds,1);       % Initialise bond type vector
BFMULTIPLIER = zeros(nBonds,1);   % Initialise bond force multiplier vector

for kBond = 1 : nBonds
        
    nodei = BONDLIST(kBond,1);
    nodej = BONDLIST(kBond,2);
        
    % Concrete to concrete - if materialflag i = 0 and j = 0 then bond is concrete
    if MATERIALFLAG(nodei,1) == 0 && MATERIALFLAG(nodej,1) == 0
        
        bondStiffnessTemp = bondStiffnessConcrete;
        BONDTYPE(kBond) = 0;
        
    % Concrete to steel - if materialflag i = 0 and j = 1 then bond is concrete   
    elseif MATERIALFLAG(nodei,1) == 0 && MATERIALFLAG(nodej,1) == 1
        
        bondStiffnessTemp = bondStiffnessConcrete;
        BONDTYPE(kBond) = 1;
        
    % Steel to concrete - if materialflag i = 1 and j = 0 then bond is concrete  
    elseif MATERIALFLAG(nodei,1) == 1 && MATERIALFLAG(nodej,1) == 0
        
        bondStiffnessTemp = bondStiffnessConcrete;
        BONDTYPE(kBond) = 1;
        
    % Steel to steel - if materialflag i = 1 and j = 1 then bond is steel
    elseif MATERIALFLAG(nodei,1) == 1 && MATERIALFLAG(nodej,1) == 1
        
        bondStiffnessTemp = bondStiffnessSteel;
        BONDTYPE(kBond) = 2;
        
    end

    % Calculate stiffening factor - surface corrections for 2D/3D problem
    nodeiNeighbourhoodVolume = nFAMILYMEMBERS(nodei) * cellVolume;                                              % Neighbourhood area/volume for Node 'i'
    nodejNeighbourhoodVolume = nFAMILYMEMBERS(nodej) * cellVolume;                                              % Neighbourhood area/volume for Node 'j'
    stiffeningFactor = (2 * neighbourhoodVolume) / ((nodeiNeighbourhoodVolume + nodejNeighbourhoodVolume));     % Calculate stiffening correction factor - should the following be included: * VOLUMECORRECTIONFACTORS(kBond));  
    BONDSTIFFNESS(kBond) = stiffeningFactor * bondStiffnessTemp ;                                               % Correct the bond stiffness

end

% Bond force multiplier
BFMULTIPLIER(BONDTYPE == 1) = 3;
BFMULTIPLIER(BONDTYPE == 0 | BONDTYPE == 2) = 1;

%% Function Timing
buildbonddataTiming = toc;
fprintf('Bond type and stiffness complete in %fs \n', buildbonddataTiming)

end