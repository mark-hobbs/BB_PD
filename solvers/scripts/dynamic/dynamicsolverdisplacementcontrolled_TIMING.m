function [deformedCoordinates,fail] = dynamicsolverdisplacementcontrolled_TIMING(inputdatafilename, config, nThreads, checkpointfileflag, checkpointfilename)
% -------------------------------------------------------------------------
% Dynamic Solver Displacement Controlled - TIMING
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

%% Set-up timing

timingPeriod = 100;

executionTimeA = zeros(timingPeriod,1); 
executionTimeB = zeros(timingPeriod,1);
executionTimeC = zeros(timingPeriod,1);  
executionTimeD = zeros(timingPeriod,1);  
executionTimeE = zeros(timingPeriod,1);  
executionTimeF = zeros(timingPeriod,1);  
executionTimeG = zeros(timingPeriod,1);  
executionTimeH = zeros(timingPeriod,1); 

%% Dynamic solver: displacement-controlled

nodalForceX = zeros(nNodes, nThreads); 
nodalForceZ = zeros(nNodes, nThreads);
nodalForceY = zeros(nNodes, nThreads);

printoutputheader();

tic

% Time Stepping Loop
for iTimeStep = simulation.timeStepTracker : simulation.nTimeSteps
    
    simulation.timeStepTracker = iTimeStep + 1; % If a checkpoint file is loaded, the simulation needs to start on the next iteration, (tt + 1)  
    
    % =====================================================================
    % Use a smooth amplitude curve to define the displacement increment at 
    % every time step
    % =====================================================================
    displacementIncrement = smoothstepdata(iTimeStep, 1, simulation.nTimeSteps, 0, simulation.appliedDisplacement);
    
    % =====================================================================
    % Calculate deformed length of every bond (A)
    % =====================================================================
    tic
    calculatedeformedlengthMex(deformedCoordinates, BONDLIST, UNDEFORMEDLENGTH, deformedLength, deformedX, deformedY, deformedZ, stretch)
    executionTimeA(iTimeStep) = toc;
    
    % =====================================================================
    % Calculate bond softening factor (B)
    % =====================================================================
    tic
    bsf(:,:) = 0; % Does bsf need to be initiatlised for every time step?
    calculatebsfexponentialMex(stretch, s0, sc, 25, 0.25, bsf, bondSofteningFactor, BONDTYPE, flagBondSoftening); 
    executionTimeB(iTimeStep) = toc;
    
    % =====================================================================
    % Determine if bonds have failed
    % =====================================================================
    % calculatebondfailureMex(fail, failureFunctionality, BONDTYPE, stretch, sc, bond.steel.sc);
    % [fail] = calculatebondfailure(fail, failureFunctionality, BONDTYPE, stretch, sc, bond.steel.sc); 
    
    % =====================================================================
    % Calculate bond force for every bond (C)
    % =====================================================================
    tic
    calculatebondforcesMex(bForceX, bForceY, bForceZ, fail, deformedX, deformedY, deformedZ, deformedLength, stretch, stretchPlastic, BONDSTIFFNESS, cellVolume, VOLUMECORRECTIONFACTORS, bondSofteningFactor);
    executionTimeC(iTimeStep) = toc;
    
    % =====================================================================
    % Calculate nodal force for every node (D)
    % =====================================================================
    tic
    nodalForce(:,:) = 0;     % Nodal force - initialise for every time step
    nodalForceX(:,:) = 0;    % Nodal force - initialise for every time step
    nodalForceY(:,:) = 0;    % Nodal force - initialise for every time step
    nodalForceZ(:,:) = 0;    % Nodal force - initialise for every time step
    calculatenodalforcesopenmpMex(BONDLIST, nodalForce, bForceX, bForceY, bForceZ, nodalForceX, nodalForceY, nodalForceZ)
    executionTimeD(iTimeStep) = toc;
    
    % =====================================================================
    % Time integration (E)
    % =====================================================================
    tic
    timeintegrationeulercromerMex(nodalAcceleration, nodalForce, simulation.DAMPING, nodalVelocity, DENSITY, CONSTRAINTFLAG, simulation.DT, nodalDisplacement, deformedCoordinates, undeformedCoordinates);
    executionTimeE(iTimeStep) = toc;
    
    % =====================================================================
    % Penetrator (F)
    % =====================================================================
    tic
    [nodalDisplacement, nodalVelocity, deformedCoordinates, penetratorfz1] = calculatecontactforce(penetrator, displacementIncrement, undeformedCoordinates, deformedCoordinates, nodalDisplacement, nodalVelocity, simulation.DT, cellVolume, DENSITY);
    executionTimeF(iTimeStep) = toc;
    
    % =====================================================================
    % Supports (G)
    % =====================================================================
    tic
    [nodalDisplacement, nodalVelocity, deformedCoordinates, supportfz1] = calculatecontactforce(supports(1), 0, undeformedCoordinates, deformedCoordinates, nodalDisplacement, nodalVelocity, simulation.DT, cellVolume, DENSITY);
    [nodalDisplacement, nodalVelocity, deformedCoordinates, supportfz2] = calculatecontactforce(supports(2), 0, undeformedCoordinates, deformedCoordinates, nodalDisplacement, nodalVelocity, simulation.DT, cellVolume, DENSITY);
    executionTimeG(iTimeStep) = toc;
    
    % =====================================================================
    % Calculate reaction force
    % =====================================================================
    reactionForce = penetratorfz1;
    
    % =====================================================================
    % Calculate crack mouth opening displacement (CMOD)
    % =====================================================================
    CMOD = nodalDisplacement(simulation.CMOD(2),1) - nodalDisplacement(simulation.CMOD(1),1);
    
    % =====================================================================
    % Dissipated damage energy
    % =====================================================================
    [damageEnergy] = calculatedamageenergy(BONDSTIFFNESS, s0, sc, UNDEFORMEDLENGTH, stretch, 25, 0.25, cellVolume, damageEnergy);
    
    % =====================================================================
    % Print output to text file
    % =====================================================================
    printoutput(iTimeStep, frequency, reactionForce, nodalDisplacement(simulation.referenceNode,3), fail, flagBondSoftening, flagBondYield, CMOD, sum(damageEnergy));
    
    % =====================================================================
    % Timing
    % =====================================================================
    if iTimeStep == timingPeriod
        
        fprintf('Average execution time: Function A = %.5fs \n', mean(executionTimeA))
        fprintf('Average execution time: Function B = %.5fs \n', mean(executionTimeB))
        fprintf('Average execution time: Function C = %.5fs \n', mean(executionTimeC))
        fprintf('Average execution time: Function D = %.5fs \n', mean(executionTimeD))
        fprintf('Average execution time: Function E = %.5fs \n', mean(executionTimeE))
        fprintf('Average execution time: Function F = %.5fs \n', mean(executionTimeF))
        fprintf('Average execution time: Function G = %.5fs \n', mean(executionTimeG))
        fprintf('Average execution time: %.5fs \n', mean(executionTimeA) + mean(executionTimeB) + mean(executionTimeC) + mean(executionTimeD) + mean(executionTimeE)+ mean(executionTimeF) + mean(executionTimeG))
        break

    end
    
end

timeintegrationTiming = toc;
fprintf('Time integration complete in %fs \n', timeintegrationTiming)


end

