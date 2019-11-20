function [deformedCoordinates,fail] = dynamicsolverdisplacementcontrolled(inputdatafilename,config)
% -------------------------------------------------------------------------
% Dynamic Solver Displacement Controlled
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
                     
load(inputdatafilename, config.dynamicsolverinputlist{:});

%% Initialise constants and empty arrays
MAXBODYFORCE = 0; % function calculatenodalforce requires this input

% TODO create a seperate function or script for this
nBonds = size(BONDLIST,1);
nNodes = size(undeformedCoordinates,1);
NOD = size(undeformedCoordinates,2);
deformedCoordinates = undeformedCoordinates; % At t = 0, deformedCoordinates = undeformedCoordinates
deformedX = zeros(nBonds,1);
deformedY = zeros(nBonds,1);
deformedZ = zeros(nBonds,1);
fail = zeros(nBonds,1) + 1;
nodalForce = zeros(nNodes,NOD);
% nodalForcePrevious = zeros(nNodes,NOD);
nodalDisplacement = zeros(nNodes,NOD);
% nodalVelocityPreviousHalf = zeros(nNodes,NOD);
nodalVelocity = zeros(nNodes,NOD);
% nodalVelocityForwardHalf = zeros(nNodes,NOD);
yieldingLength = zeros(nBonds,1);
flagBondYield = zeros(nBonds,1);
flagBondSoftening = zeros(nBonds,1);
bondSofteningFactor = zeros(nBonds,1);

%% Configuring dynamic solver

dynamicsolverconfiguration

%% Dynamic solver: displacement-controlled

tic
frameCounter = 0;
figure
nTimeSteps = 100000;
finalDisplacement = -3e-3;
frequency = 200; 

% randomNumbers = 0.8 + (1.2 - 0.8) .* rand(nBonds,1);
% for i = 1 : nBonds
%     if BONDTYPE(i) == 0
%         BONDSTIFFNESS(i) = randomNumbers(i) * BONDSTIFFNESS(i);
%     end
% end

% [massVector] = buildmassmatrix(nNodes, DX, bondStiffnessConcrete, DT, nFAMILYMEMBERS);
%[~, ~, ~, massVector] = buildstiffnessmatrixCSCformat(undeformedCoordinates,BONDLIST,VOLUMECORRECTIONFACTORS,cellVolume,BONDSTIFFNESS,BFMULTIPLIER,fail);
% massVector = massVector .* 100000;

% Time Stepping Loop
for iTimeStep = timeStepTracker : nTimeSteps

    timeStepTracker = iTimeStep + 1; % If a checkpoint file is loaded, the simulation needs to start on the next iteration, (tt + 1)  
    
    % Use a smooth amplitude curve to define the displacement increment at every time step 
    displacementIncrement = smoothstepdata(iTimeStep, 1, nTimeSteps, 0, finalDisplacement);

    % Apply displacement boundary condition - DO!!!!
    nodalDisplacement(BODYFORCEFLAG == 1) = displacementIncrement;    % Apply boundary conditions - applied displacement
    deformedCoordinates(:,:) = undeformedCoordinates(:,:) + nodalDisplacement(:,:);   % Deformed coordinates of all nodes
    
    % Calculate deformed length of every bond
    [deformedLength,deformedX,deformedY,deformedZ,stretch] = calculatedeformedlength(deformedCoordinates,UNDEFORMEDLENGTH,deformedX,deformedY,deformedZ,nBonds,BONDLIST);
    
    % Calculate plastic stretch for steel-steel bonds
    [stretchPlastic,yieldingLength,flagBondYield] = calculateplasticstretch(yieldingLength,flagBondYield,stretch,BONDTYPE,deformedLength);
   
    % Calculate bond softening factor for bilinear material model
    [bondSofteningFactor, flagBondSoftening] = calculatebondsofteningfactor(stretch,linearElasticLimit,criticalStretchConcrete,flagBondSoftening,bondSofteningFactor,BONDTYPE);
    
    % Determine if bonds have failed
    [fail] = calculatebondfailure(fail,failureFunctionality,BONDTYPE,stretch,criticalStretchConcrete,criticalStretchSteel);
    
    % Calculate bond force for every bond
    [bForceX,bForceY,bForceZ] = calculatebondforces(fail,deformedX,deformedY,deformedZ,deformedLength,stretch,stretchPlastic,nBonds,BFMULTIPLIER,BONDSTIFFNESS,cellVolume,VOLUMECORRECTIONFACTORS,bondSofteningFactor);

    % Calculate nodal force for every node
    [nodalForce] = calculatenodalforces(BONDLIST,nodalForce,bForceX,bForceY,bForceZ,BODYFORCEFLAG,MAXBODYFORCE);

    % Adaptively calculate the damping coefficient
    % [cn] = calculatedampingcoefficient(nodalForce, massVector, nodalForcePrevious, DT, nodalVelocityPreviousHalf, nodalDisplacement);

    % Time integration 
    [nodalDisplacement,nodalVelocity,deformedCoordinates,~] = timeintegrationeulercromer(nodalForce,nodalDisplacement,nodalVelocity,DAMPING,DENSITY,CONSTRAINTFLAG,undeformedCoordinates,DT,BODYFORCEFLAG,config.loadingMethod,displacementIncrement);
    % [nodalDisplacement, nodalVelocityForwardHalf] = timeintegrationADR(iTimeStep, DT, nodalVelocityForwardHalf, nodalForce, massVector, cn, nodalVelocityPreviousHalf, nodalDisplacement, CONSTRAINTFLAG);
    % Where are constraint flags applied? ^^^^^^
    
    % deformedCoordinates(:,:) = undeformedCoordinates(:,:) + nodalDisplacement(:,:);   % Deformed coordinates of all nodes
    % nodalVelocityPreviousHalf = nodalVelocityForwardHalf;
    % nodalForcePrevious = nodalForce;
    
    % Calculate the strain energy density for every node
    % [strainEnergy,nodalStrainEnergyDensity] = calculatestrainenergy(nNodes,fail,BONDSTIFFNESS,BFMULTIPLIER,stretch,UNDEFORMEDLENGTH,VOLUMECORRECTIONFACTORS,BONDLIST,cellVolume); 
    
    % Save variable history
    % strainEnergyHistory(iTimeStep,1) = strainEnergy;
    % nodalDisplacementHistory(iTimeStep,1) = nodalDisplacement(1500,3);
    
    % Calculate reaction force
    reactionForce = calculatereactionforceFast(nodalForce, BODYFORCEFLAG, DX); % TODO: introduce frequency
    
    % Print output to text file
    printoutput(iTimeStep, frequency, reactionForce, nodalDisplacement(87,3), fail, flagBondSoftening, flagBondYield);
    
    % Save output variables
    
    
    % Save damage plot 
     
    % Determine reaction force and output load-displacement graph
%     if mod(iTimeStep, 200) == 0
%         
%         frameCounter = frameCounter + 1;
%         
%         reactionForceHistory(frameCounter,1) = sum(reactionForce);  
%         nodalDisplacementHistoryReduced(frameCounter,1) = nodalDisplacement(87,3);
%         % plot(nodalDisplacementHistoryReduced, reactionForceHistory)
%                 
%         damage = calculatedamage(BONDLIST, fail, nFAMILYMEMBERS);
%         plotnodaldata(undeformedCoordinates, nodalDisplacement, damage, 'Damage');
%         drawnow
%         % createGIF('B1_2D.gif',frameCounter)
%         
%         % fprintf('Time Step: %.0f \t Reaction Force: %.3fN \t Displacement: %.3fmm\n', iTimeStep, reactionForceHistory(frameCounter,1), nodalDisplacement(87,3)*1000)
%         
%     end
    
            
end

timeintegrationTiming = toc;
fprintf('Time integration complete in %fs \n', timeintegrationTiming)

% plotvariablehistory(nTimeSteps,nodalDisplacementHistory,'Nodal Displacement (m)')
% plotvariablehistory(nTimeSteps,appliedForceHistory,'Applied Force (N)')
% plotvariablehistory(nTimeSteps,strainEnergyHistory,'Strain Energy (J)')
% plotnodaldata(undeformedCoordinates,nodalDisplacement,nodalStrainEnergyDensity,'Strain Energy Density')

end

