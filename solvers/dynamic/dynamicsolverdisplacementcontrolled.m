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
arraypreallocation

MAXBODYFORCE = 0; % function calculatenodalforce requires this input
deformedCoordinates = undeformedCoordinates; % At t = 0, deformedCoordinates = undeformedCoordinates
nTimeSteps = 100000;
finalDisplacement = -3e-3;
frequency = 200;
BFMULTIPLIER = ones(nBonds,1);

%% Configuring dynamic solver

dynamicsolverconfiguration

%% Dynamic solver: displacement-controlled

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

% Time Stepping Loop
for iTimeStep = timeStepTracker : nTimeSteps

    timeStepTracker = iTimeStep + 1; % If a checkpoint file is loaded, the simulation needs to start on the next iteration, (tt + 1)  
    
    % Use a smooth amplitude curve to define the displacement increment at every time step
    displacementIncrement = smoothstepdata(iTimeStep, 1, nTimeSteps, 0, finalDisplacement);
    
    % Apply displacement boundary condition - DO!!!!
%     nodalDisplacement(BODYFORCEFLAG == 1) = displacementIncrement;                    % Apply boundary conditions - applied displacement
%     deformedCoordinates(:,:) = undeformedCoordinates(:,:) + nodalDisplacement(:,:);   % Deformed coordinates of all nodes
    
    % Calculate deformed length of every bond
    [deformedLength,deformedX,deformedY,deformedZ,stretch] = calculatedeformedlength(deformedLength,deformedX,deformedY,deformedZ,stretch,deformedCoordinates,UNDEFORMEDLENGTH,BONDLIST,nBonds);
    
    % Calculate plastic stretch for steel-steel bonds
    [stretchPlastic,yieldingLength,flagBondYield] = calculateplasticstretch(stretchPlastic,yieldingLength,flagBondYield,stretch,BONDTYPE,deformedLength);
    
    % Calculate bond softening factor for bilinear material model
    [bondSofteningFactor, flagBondSoftening] = calculatebondsofteningfactor(stretch,linearElasticLimit,criticalStretchConcrete,flagBondSoftening,bondSofteningFactor,BONDTYPE);
    
    % Determine if bonds have failed
    [fail] = calculatebondfailure(fail,failureFunctionality,BONDTYPE,stretch,criticalStretchConcrete,criticalStretchSteel);
    
    % Calculate bond force for every bond
    [bForceX,bForceY,bForceZ] = calculatebondforces(bForceX,bForceY,bForceZ,fail,deformedX,deformedY,deformedZ,deformedLength,stretch,stretchPlastic,nBonds,BFMULTIPLIER,BONDSTIFFNESS,cellVolume,VOLUMECORRECTIONFACTORS,bondSofteningFactor);
    
    % Calculate nodal force for every node
    [nodalForce] = calculatenodalforces(BONDLIST,nodalForce,bForceX,bForceY,bForceZ,BODYFORCEFLAG,MAXBODYFORCE);
    
    % Adaptively calculate the damping coefficient
    % [cn] = calculatedampingcoefficient(nodalForce, massVector, nodalForcePrevious, DT, nodalVelocityPreviousHalf, nodalDisplacement);
      
    % Time integration
    [nodalDisplacement,nodalVelocity,deformedCoordinates,~] = timeintegrationeulercromer(nodalForce,nodalDisplacement,nodalVelocity,DAMPING,DENSITY,CONSTRAINTFLAG,undeformedCoordinates,DT,BODYFORCEFLAG,config.loadingMethod,displacementIncrement);    
    % [nodalDisplacement, nodalVelocityForwardHalf] = timeintegrationADR(iTimeStep, DT, nodalVelocityForwardHalf, nodalForce, massVector, cn, nodalVelocityPreviousHalf, nodalDisplacement, CONSTRAINTFLAG);
    % Where are constraint flags applied? ^^^^^^
    
    [nodalDisplacement, nodalVelocity, deformedCoordinates, penetratorfz1] = calculatecontactforce(penetrator1, displacementIncrement, undeformedCoordinates, deformedCoordinates, nodalDisplacement, nodalVelocity, DT, cellVolume, DENSITY);
    [nodalDisplacement, nodalVelocity, deformedCoordinates, penetratorfz2] = calculatecontactforce(penetrator2, displacementIncrement, undeformedCoordinates, deformedCoordinates, nodalDisplacement, nodalVelocity, DT, cellVolume, DENSITY);
    
    % deformedCoordinates(:,:) = undeformedCoordinates(:,:) + nodalDisplacement(:,:);   % Deformed coordinates of all nodes
    % nodalVelocityPreviousHalf = nodalVelocityForwardHalf;
    % nodalForcePrevious = nodalForce;
    
    % Calculate the strain energy density for every node
    % [strainEnergy,nodalStrainEnergyDensity] = calculatestrainenergy(nNodes,fail,BONDSTIFFNESS,BFMULTIPLIER,stretch,UNDEFORMEDLENGTH,VOLUMECORRECTIONFACTORS,BONDLIST,cellVolume); 
    
    % Save variable history
    % strainEnergyHistory(iTimeStep,1) = strainEnergy;
    % nodalDisplacementHistory(iTimeStep,1) = nodalDisplacement(1500,3);
    
    % Calculate reaction force
    % reactionForce = calculatereactionforceFast(nodalForce, BODYFORCEFLAG, DX); % TODO: introduce frequency
    reactionForce = penetratorfz1 + penetratorfz2;
    
    % Print output to text file
    printoutput(iTimeStep, frequency, reactionForce, nodalDisplacement(63,3), fail, flagBondSoftening, flagBondYield);
    
    % Save output variables for postprocessing
    % savedata(iTimeStep,frequency,inputdatafilename,deformedCoordinates,fail);
    
    % Save damage figure
    savedamagefigure(iTimeStep,1000,inputdatafilename,BONDLIST,fail,nFAMILYMEMBERS,undeformedCoordinates,deformedCoordinates,DX);
    
    % Save checkpoint file   
            
end

timeintegrationTiming = toc;
fprintf('Time integration complete in %fs \n', timeintegrationTiming)

% plotvariablehistory(nTimeSteps,nodalDisplacementHistory,'Nodal Displacement (m)')
% plotvariablehistory(nTimeSteps,appliedForceHistory,'Applied Force (N)')
% plotvariablehistory(nTimeSteps,strainEnergyHistory,'Strain Energy (J)')
% plotnodaldata(undeformedCoordinates,nodalDisplacement,nodalStrainEnergyDensity,'Strain Energy Density')

end

