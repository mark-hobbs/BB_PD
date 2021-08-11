function [deformedCoordinates,fail] = dynamicsolverdisplacementcontrolledADR(inputdatafilename, config, checkpointfileflag, checkpointfilename)
% -------------------------------------------------------------------------
% Dynamic Solver Displacement Controlled Adaptive Dynamic Relaxation
% -------------------------------------------------------------------------
% Solve the dynamic peridynamic equation of motion 

% INPUT:
%   inputdatafilename - name of input file
%   config - configuration file
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
    frequency = 200;
    BFMULTIPLIER = ones(nBonds,1);

end

%% Configuring dynamic solver

dynamicsolverconfiguration

%% Load checkpoint file

if checkpointfileflag == true
    
    load(checkpointfilename);
    
end

%% Dynamic solver: displacement-controlled


nodalForceX = zeros(nNodes,4);
nodalForceZ = zeros(nNodes,4);
nodalForceY = zeros(nNodes,4);


printoutputheader();

tic

% randomNumbers = 0.8 + (1.2 - 0.8) .* rand(nBonds,1);
% for i = 1 : nBonds
%     if BONDTYPE(i) == 0
%         BONDSTIFFNESS(i) = randomNumbers(i) * BONDSTIFFNESS(i);
%     end
% end


% [massVector] = buildmassmatrix(nNodes, DX, bondStiffnessConcrete, DT, nFAMILYMEMBERS);
%[~, ~, ~, massVector] = buildstiffnessmatrixCSCformat(undeformedCoordinates,BONDLIST,VOLUMECORRECTIONFACTORS,cellVolume,BONDSTIFFNESS,BFMULTIPLIER,fail);
% massVector = massVector .* 100000;

timingPeriod = 100;

executionTimeA = zeros(timingPeriod,1); 
executionTimeB = zeros(timingPeriod,1);
executionTimeC = zeros(timingPeriod,1);  
executionTimeD = zeros(timingPeriod,1);  
executionTimeE = zeros(timingPeriod,1);  
executionTimeF = zeros(timingPeriod,1);  
executionTimeG = zeros(timingPeriod,1);  
executionTimeH = zeros(timingPeriod,1); 

% Time Stepping Loop
for iTimeStep = timeStepTracker : nTimeSteps
    
    timeStepTracker = iTimeStep + 1; % If a checkpoint file is loaded, the simulation needs to start on the next iteration, (tt + 1)  
    
    % Use a smooth amplitude curve to define the displacement increment at every time step
    displacementIncrement = smoothstepdata(iTimeStep, 1, nTimeSteps, 0, appliedDisplacement);
    
    % Apply displacement boundary condition - DO!!!!
    % nodalDisplacement(BODYFORCEFLAG == 1) = displacementIncrement;                    % Apply boundary conditions - applied displacement
    % deformedCoordinates(:,:) = undeformedCoordinates(:,:) + nodalDisplacement(:,:);   % Deformed coordinates of all nodes
    
    % Calculate deformed length of every bond
    tic
    % [deformedLength,deformedX,deformedY,deformedZ,stretch] = calculatedeformedlength(deformedLength,deformedX,deformedY,deformedZ,stretch,deformedCoordinates,UNDEFORMEDLENGTH,BONDLIST,nBonds);
    calculatedeformedlengthMex(deformedCoordinates, BONDLIST, UNDEFORMEDLENGTH, deformedLength, deformedX, deformedY, deformedZ, stretch)
    executionTimeA(iTimeStep) = toc;
    
    % Calculate plastic stretch for steel-steel bonds
    tic
    % [stretchPlastic,yieldingLength,flagBondYield] = calculateplasticstretch(stretchPlastic,yieldingLength,flagBondYield,stretch,BONDTYPE,deformedLength);
    calculateplasticstretchMex(stretchPlastic,yieldingLength,flagBondYield,stretch,BONDTYPE,deformedLength);
    executionTimeB(iTimeStep) = toc;
    
    % Calculate bond softening factor for bilinear material model
    tic
    [bondSofteningFactor, flagBondSoftening] = calculatebondsofteningfactor(stretch,linearElasticLimit,criticalStretchConcrete,flagBondSoftening,bondSofteningFactor,BONDTYPE);
    executionTimeC(iTimeStep) = toc;
    
    % Determine if bonds have failed
    tic
    calculatebondfailureMex(fail,failureFunctionality,BONDTYPE,stretch,criticalStretchConcrete,criticalStretchSteel);
    % [fail] = calculatebondfailure(fail,failureFunctionality,BONDTYPE,stretch,criticalStretchConcrete,criticalStretchSteel);
    executionTimeD(iTimeStep) = toc;
    
    % Calculate bond force for every bond
    tic
    calculatebondforcesMex(bForceX,bForceY,bForceZ,fail,deformedX,deformedY,deformedZ,deformedLength,stretch,stretchPlastic,BONDSTIFFNESS,cellVolume,VOLUMECORRECTIONFACTORS,bondSofteningFactor);
    % [bForceX,bForceY,bForceZ] = calculatebondforces(bForceX,bForceY,bForceZ,fail,deformedX,deformedY,deformedZ,deformedLength,stretch,stretchPlastic,nBonds,BFMULTIPLIER,BONDSTIFFNESS,cellVolume,VOLUMECORRECTIONFACTORS,bondSofteningFactor);
    executionTimeE(iTimeStep) = toc;
    
    % Calculate nodal force for every node
    tic
    % [nodalForce] = calculatenodalforces(BONDLIST,nodalForce,bForceX,bForceY,bForceZ,BODYFORCEFLAG,MAXBODYFORCE);
    nodalForce(:,:) = 0;     % Nodal force - initialise for every time step
    nodalForceX(:,:) = 0;    % Nodal force - initialise for every time step
    nodalForceY(:,:) = 0;    % Nodal force - initialise for every time step
    nodalForceZ(:,:) = 0;    % Nodal force - initialise for every time step
    calculatenodalforcesopenmpMex(BONDLIST, nodalForce, bForceX, bForceY, bForceZ, nodalForceX, nodalForceY, nodalForceZ)
    executionTimeF(iTimeStep) = toc;
        
    % Adaptively calculate the damping coefficient
    % [cn] = calculatedampingcoefficient(nodalForce, massVector, nodalForcePrevious, DT, nodalVelocityPreviousHalf, nodalDisplacement);
      
    % Time integration
    tic
    [nodalDisplacement,nodalVelocity,deformedCoordinates,~] = timeintegrationeulercromer(nodalForce,nodalDisplacement,nodalVelocity,DAMPING,DENSITY,CONSTRAINTFLAG,undeformedCoordinates,DT,BODYFORCEFLAG,config.loadingMethod,displacementIncrement,deformedCoordinates);    
    % [nodalDisplacement, nodalVelocityForwardHalf] = timeintegrationADR(iTimeStep, DT, nodalVelocityForwardHalf, nodalForce, massVector, cn, nodalVelocityPreviousHalf, nodalDisplacement, CONSTRAINTFLAG);
    % Where are constraint flags applied? ^^^^^^
    executionTimeG(iTimeStep) = toc;

    tic
    [nodalDisplacement, nodalVelocity, deformedCoordinates, penetratorfz1] = calculatecontactforce(penetrator1, displacementIncrement, undeformedCoordinates, deformedCoordinates, nodalDisplacement, nodalVelocity, DT, cellVolume, DENSITY);
    [nodalDisplacement, nodalVelocity, deformedCoordinates, penetratorfz2] = calculatecontactforce(penetrator2, displacementIncrement, undeformedCoordinates, deformedCoordinates, nodalDisplacement, nodalVelocity, DT, cellVolume, DENSITY);
    %[nodalDisplacement, nodalVelocity, deformedCoordinates, supportfz1] = calculatecontactforce(support1, 0, undeformedCoordinates, deformedCoordinates, nodalDisplacement, nodalVelocity, DT, cellVolume, DENSITY);
    %[nodalDisplacement, nodalVelocity, deformedCoordinates, supportfz2] = calculatecontactforce(support2, 0, undeformedCoordinates, deformedCoordinates, nodalDisplacement, nodalVelocity, DT, cellVolume, DENSITY);
    executionTimeH(iTimeStep) = toc;
    
    % deformedCoordinates(:,:) = undeformedCoordinates(:,:) + nodalDisplacement(:,:);   % Deformed coordinates of all nodes
    % nodalVelocityPreviousHalf = nodalVelocityForwardHalf;
    % nodalForcePrevious = nodalForce;
    
    % Calculate the strain energy density for every node
    % [strainEnergy,nodalStrainEnergyDensity] = calculatestrainenergy(nNodes,fail,BONDSTIFFNESS,BFMULTIPLIER,stretch,UNDEFORMEDLENGTH,VOLUMECORRECTIONFACTORS,BONDLIST,cellVolume); 
    
    % Save variable history
    % strainEnergyHistory(iTimeStep,1) = strainEnergy;
    % nodalDisplacementHistory(iTimeStep,1) = nodalDisplacement(1500,3);
    
    % Calculate reaction force
    % reactionForce = calculatereactionforceFast(nodalForce, CONSTRAINTFLAG, DX); % TODO: introduce frequency
    reactionForce = penetratorfz1 + penetratorfz2;
    % reactionForce = supportfz1 + supportfz2;
    
    % CMOD = nodalDisplacement(20,1) - nodalDisplacement(15,1);
    
    % Print output to text file
    printoutput(iTimeStep, frequency, reactionForce, nodalDisplacement(referenceNode,3), fail, flagBondSoftening, flagBondYield);
    
    % Save output variables for postprocessing (BB_PD/output/outputfiles/inputdatafilename/)
    savedata(iTimeStep,1000,inputdatafilename,deformedCoordinates,fail,flagBondSoftening);
    
    % Save damage figure (BB_PD/output/outputfiles/inputdatafilename/)
    savedamagefigure(iTimeStep,200,inputdatafilename,BONDLIST,fail,nFAMILYMEMBERS,undeformedCoordinates,deformedCoordinates,DX);
    
    % Save checkpoint file
    if mod(iTimeStep, 10000) == 0
        
       [folderPath] = findfolder('BB_PD/output/checkpointfiles');
       inputdatafilename = erase(inputdatafilename,'.mat'); % erase .mat from inputdatafilename
       baseFileName = sprintf('%s_checkpoint.mat', inputdatafilename);
       fullFileName = fullfile(folderPath , baseFileName);
       save(fullFileName)
        
    end
    
    % Timing
    if iTimeStep == timingPeriod
        
        fprintf('Average execution time: Function A = %.3fs \n', mean(executionTimeA))
        fprintf('Average execution time: Function B = %.3fs \n', mean(executionTimeB))
        fprintf('Average execution time: Function C = %.3fs \n', mean(executionTimeC))
        fprintf('Average execution time: Function D = %.3fs \n', mean(executionTimeD))
        fprintf('Average execution time: Function E = %.3fs \n', mean(executionTimeE))
        fprintf('Average execution time: Function F = %.3fs \n', mean(executionTimeF))
        fprintf('Average execution time: Function G = %.3fs \n', mean(executionTimeG))
        fprintf('Average execution time: Function H = %.3fs \n', mean(executionTimeH))

    end
    
end



timeintegrationTiming = toc;
fprintf('Time integration complete in %fs \n', timeintegrationTiming)

% plotvariablehistory(nTimeSteps,nodalDisplacementHistory,'Nodal Displacement (m)')
% plotvariablehistory(nTimeSteps,appliedForceHistory,'Applied Force (N)')
% plotvariablehistory(nTimeSteps,strainEnergyHistory,'Strain Energy (J)')
% plotnodaldata(undeformedCoordinates,nodalDisplacement,nodalStrainEnergyDensity,'Strain Energy Density')

end

