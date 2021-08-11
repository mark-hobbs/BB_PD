function [deformedCoordinates,fail] = dynamicsolverdisplacementcontrolled(inputdatafilename, config, nThreads, checkpointfileflag, checkpointfilename)
% -------------------------------------------------------------------------
% Dynamic Solver Displacement Controlled
% -------------------------------------------------------------------------
% Solve the dynamic peridynamic equation of motion 

% INPUT:
%   inputdatafilename - name of input file
%   config - configuration file
%   nThreads - Number of OpenMP threads
%
% OUTPUT:
%   deformedCoordinates - coordinates of deformed nodes
%   fail - vector to track if a bond has failed
%   history - value of a variable at every time-step
% -------------------------------------------------------------------------

%% Load the defined input file name

if checkpointfileflag == false
    
    load(inputdatafilename, config.dynamicsolverinputlist{:});
    
end

%% Initialise constants and empty arrays

if checkpointfileflag == false
    
    arraypreallocation

    MAXBODYFORCE = 0;                               % function calculatenodalforce requires this input
    deformedCoordinates = undeformedCoordinates;    % At t = 0, deformedCoordinates = undeformedCoordinates
    frequency = 200;                                % Frequency at which data is printed to output
    bsf = zeros(nBonds,1);
    damageEnergy = zeros(nBonds,1);

end

%% Configuring dynamic solver

dynamicsolverconfiguration

%% Load checkpoint file

if checkpointfileflag == true
    
    load(checkpointfilename);
    
end

%% Dynamic solver: displacement-controlled

nodalForceX = zeros(nNodes, nThreads); 
nodalForceZ = zeros(nNodes, nThreads);
nodalForceY = zeros(nNodes, nThreads);

printoutputheader();

tic

% k = 25;
% alpha = 0.25;
% GF = material.concrete.fractureEnergy;
% c = bond.concrete.stiffness;
% horizon = pi * DX;
% s0 = 1.0541E-04;
% sc = (10 * k * (1 - exp(k)) * (GF - (pi * c * horizon^5 * s0^2 * (2 * k - 2 * exp(k) + alpha * k - alpha * k * exp(k) + 2)) / (10 * k * (exp(k) - 1) * (alpha + 1))) * (alpha + 1)) / (c * horizon^5 * s0 * pi * (2 * k - 2 * exp(k) + alpha * k - alpha * k * exp(k) + 2));

% Time Stepping Loop
for iTimeStep = simulation.timeStepTracker : simulation.nTimeSteps
    
    simulation.timeStepTracker = iTimeStep + 1; % If a checkpoint file is loaded, the simulation needs to start on the next iteration, (tt + 1)  
    
    % Use a smooth amplitude curve to define the displacement increment at every time step
    displacementIncrement = smoothstepdata(iTimeStep, 1, simulation.nTimeSteps, 0, simulation.appliedDisplacement);  
    
    % Calculate deformed length of every bond
    calculatedeformedlengthMex(deformedCoordinates, BONDLIST, UNDEFORMEDLENGTH, deformedLength, deformedX, deformedY, deformedZ, stretch)
    
    % Calculate bond softening factor
    % [bondSofteningFactor, flagBondSoftening] = calculatebondsofteningfactor(stretch, bond.concrete.s0, bond.concrete.sc, flagBondSoftening, bondSofteningFactor, BONDTYPE);   % Bilinear 
    % [bondSofteningFactor, flagBondSoftening] = calculatebsftrilinear(stretch, s0, s1, sc, bondSofteningFactor, BONDTYPE, flagBondSoftening);                                  % Trilinear
    % [bondSofteningFactor, flagBondSoftening] = calculatebsfexponential(stretch, s0, sc, 25, 0.25, bondSofteningFactor, BONDTYPE, flagBondSoftening);                          % Decaying exponential
    
    bsf(:,:) = 0; % Does bsf need to be initiatlised for every time step?
    calculatebsfexponentialMex(stretch, s0, sc, 25, 0.25, bsf, bondSofteningFactor, BONDTYPE, flagBondSoftening); 
    
    % Determine if bonds have failed
    % calculatebondfailureMex(fail, failureFunctionality, BONDTYPE, stretch, sc, bond.steel.sc);
    % [fail] = calculatebondfailure(fail, failureFunctionality, BONDTYPE, stretch, sc, bond.steel.sc); 
    
    % Calculate bond force for every bond
    calculatebondforcesMex(bForceX, bForceY, bForceZ, fail, deformedX, deformedY, deformedZ, deformedLength, stretch, stretchPlastic, BONDSTIFFNESS, cellVolume, VOLUMECORRECTIONFACTORS, bondSofteningFactor);
    
    % Calculate nodal force for every node
    nodalForce(:,:) = 0;     % Nodal force - initialise for every time step
    nodalForceX(:,:) = 0;    % Nodal force - initialise for every time step
    nodalForceY(:,:) = 0;    % Nodal force - initialise for every time step
    nodalForceZ(:,:) = 0;    % Nodal force - initialise for every time step
    calculatenodalforcesopenmpMex(BONDLIST, nodalForce, bForceX, bForceY, bForceZ, nodalForceX, nodalForceY, nodalForceZ)
        
    % Time integration
    % [nodalDisplacement, nodalVelocity, deformedCoordinates,~] = timeintegrationeulercromer(nodalForce, nodalDisplacement, nodalVelocity, simulation.DAMPING, DENSITY, CONSTRAINTFLAG, undeformedCoordinates, simulation.DT, BODYFORCEFLAG, config.loadingMethod, displacementIncrement, deformedCoordinates);    
    timeintegrationeulercromerMex(nodalAcceleration, nodalForce, simulation.DAMPING, nodalVelocity, DENSITY, CONSTRAINTFLAG, simulation.DT, nodalDisplacement, deformedCoordinates, undeformedCoordinates);
    
    % Penetrator
    [nodalDisplacement, nodalVelocity, deformedCoordinates, penetratorfz1] = calculatecontactforce(penetrator, displacementIncrement, undeformedCoordinates, deformedCoordinates, nodalDisplacement, nodalVelocity, simulation.DT, cellVolume, DENSITY);

    % Supports
    [nodalDisplacement, nodalVelocity, deformedCoordinates, supportfz1] = calculatecontactforce(supports(1), 0, undeformedCoordinates, deformedCoordinates, nodalDisplacement, nodalVelocity, simulation.DT, cellVolume, DENSITY);
    [nodalDisplacement, nodalVelocity, deformedCoordinates, supportfz2] = calculatecontactforce(supports(2), 0, undeformedCoordinates, deformedCoordinates, nodalDisplacement, nodalVelocity, simulation.DT, cellVolume, DENSITY);
    
    % Calculate reaction force
    reactionForce = penetratorfz1;
    %reactionForce = supportfz1 + supportfz2;
    
    CMOD = nodalDisplacement(simulation.CMOD(2),1) - nodalDisplacement(simulation.CMOD(1),1);
    
    % Dissipated damage energy
    [damageEnergy] = calculatedamageenergy(BONDSTIFFNESS, s0, sc, UNDEFORMEDLENGTH, stretch, 25, 0.25, cellVolume, damageEnergy);
    
    % Print output to text file
    printoutput(iTimeStep, frequency, reactionForce, nodalDisplacement(simulation.referenceNode,3), fail, flagBondSoftening, flagBondYield, CMOD, sum(damageEnergy));
    
    % Save output variables for postprocessing (BB_PD/output/outputfiles/inputdatafilename/)
    savedata(iTimeStep,1000,inputdatafilename,deformedCoordinates,fail,flagBondSoftening);
    
    % Save damage figure (BB_PD/output/outputfiles/inputdatafilename/)
    % savedamagefigure(iTimeStep,1000,inputdatafilename,BONDLIST,fail,nFAMILYMEMBERS,undeformedCoordinates,deformedCoordinates,DX);
    
    % Save checkpoint file
    if mod(iTimeStep, 10000) == 0
        
       [folderPath] = findfolder('BB_PD/output/checkpointfiles');
       inputdatafilename = erase(inputdatafilename,'.mat');             % erase .mat from inputdatafilename
       baseFileName = sprintf('%s_checkpoint.mat', inputdatafilename);
       fullFileName = fullfile(folderPath , baseFileName);
       save(fullFileName)
        
    end
    
end

timeintegrationTiming = toc;
fprintf('Time integration complete in %fs \n', timeintegrationTiming)


end

