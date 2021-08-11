function [deformedCoordinates,fail,stretch,flagBondYield] = dynamicsolverloadcontrolled(config)
% -------------------------------------------------------------------------
% Dynamic Solver Load Controlled
% -------------------------------------------------------------------------
% Solve the dynamic peridynamic equation of motion 
%
% INPUT:
%   inputdatafilename - name of input file
%   config - configuration file
%
% OUTPUT:
%   deformedCoordinates - coordinates of deformed nodes
%   fail - vector to track if a bond has failed
%
% -------------------------------------------------------------------------

%% Load the defined input file name
                     
load(config.inputdatafilename, config.dynamicsolverinputlist{:});
% nodalMass = DENSITY * cellVolume; 
% totalSystemMass = sum(nodalMass);

%% Initialise constants and empty arrays
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
nodalDisplacement = zeros(nNodes,NOD);
nodalVelocity = zeros(nNodes,NOD);

% nodalDisplacementHistory = zeros(nTimeSteps,1);
% kineticEnergyHistory = zeros(nTimeSteps,1);
% strainEnergyHistory = zeros(nTimeSteps,1);
% externalWorkHistory = zeros(nTimeSteps,1);
% dampingEnergyHistory = zeros(nTimeSteps,1);
% appliedForceHistory = zeros(nTimeSteps,1);
% externalWorkSum = 0;
% dampingEnergySum = 0;
displacementIncrement = 0;
yieldingLength = zeros(nBonds,1);
flagBondYield = zeros(nBonds,1);
flagBondSoftening = zeros(nBonds,1);
bondSofteningFactor = zeros(nBonds,1);

%% Configuring dynamic solver
dynamicsolverconfiguration

%% Dynamic solver load controlled

% Testing ADR
% randomNumbers = 0.8 + (1.2 - 0.8) .* rand(nBonds,1);
% for i = 1 : nBonds
%     if BONDTYPE(i) == 0
%         BONDSTIFFNESS(i) = randomNumbers(i) * BONDSTIFFNESS(i);
%     end
% end

% nodalForcePrevious = zeros(nNodes,NOD);
% nodalVelocityPreviousHalf = zeros(nNodes,NOD);
% nodalVelocityForwardHalf = zeros(nNodes,NOD);
% DT = 1;
% [~, ~, ~, massVector] = buildstiffnessmatrixCSCformat(undeformedCoordinates,BONDLIST,VOLUMECORRECTIONFACTORS,cellVolume,BONDSTIFFNESS,BFMULTIPLIER,fail);
% massVector = massVector .* 100000;

% Time integration loop - TODO: Should I make the time integration loop
% into a function?

% for loop (incrementally increase load / incrementally increase
% displacement)

% Binary search for failure load

% 
    
    % If running a 'batch-processing' job, re-initialise 
    
    tic  
    figure
    
%     appliedLoad = -[60000, 65000, 70000, 75000, 80000, 85000, 90000, 95000, 100000, 105000, 110000, 115000, 120000, 125000, 130000];
%     
%     for iAppliedLoad = 1 : size(appliedLoad,2)
%         
%         MAXBODYFORCE = calculateappliedbodyforce(BODYFORCEFLAG,appliedLoad(1,iAppliedLoad),cellVolume);
        
        % Time Stepping Loop
        countersave = 0;
        frameCounter = 0;
        timeStepTracker = 1;
        equilibriumState = zeros(nTimeSteps,1);
        equilibriumStateAverage = zeros(nTimeSteps,1);

        for iTimeStep = timeStepTracker : nTimeSteps
            
            timeStepTracker = iTimeStep + 1; % If a checkpoint file is loaded, the simulation needs to start on the next iteration, (tt + 1)
            
            % Calculate deformed length of every bond
            [deformedLength,deformedX,deformedY,deformedZ,stretch] = calculatedeformedlength(deformedCoordinates,UNDEFORMEDLENGTH,deformedX,deformedY,deformedZ,nBonds,BONDLIST);
            
            % Calculate plastic stretch for steel-steel bonds
            [stretchPlastic,yieldingLength,flagBondYield] = calculateplasticstretch(yieldingLength,flagBondYield,stretch,BONDTYPE,deformedLength);
            
            % Calculate bond softening factor for bilinear material model
            % [bondSofteningFactor, flagBondSoftening] = calculatebondsofteningfactor(stretch, criticalStretchConcrete, flagBondSoftening, bondSofteningFactor, BONDTYPE);
            
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
            
            % nodalVelocityPreviousHalf = nodalVelocityForwardHalf;
            % nodalForcePrevious = nodalForce;
            % deformedCoordinates(:,:) = undeformedCoordinates(:,:) + nodalDisplacement(:,:);
            
            % Calculate equilbrium state and terminate simulation if equilibrium state tolerance is met
            [equilibriumState,equilibriumStateAverage] = calculateequilibriumstate(iTimeStep,150,nodalForce,BODYFORCEFLAG,MAXBODYFORCE,equilibriumState,equilibriumStateAverage);
            
            % Calculate kinetic energy
            % [kineticEnergy] = calculatekineticenergy(nodalMass,nodalVelocity,deformedCoordinates,totalSystemMass);
            % [strainEnergy,nodalStrainEnergyDensity] = calculatestrainenergy(nNodes,fail,BONDSTIFFNESS,BFMULTIPLIER,stretch,UNDEFORMEDLENGTH,VOLUMECORRECTIONFACTORS,BONDLIST,cellVolume);
            % calculateworkdone(nodalMass,totalSystemMass,deformedCoordinates,nodalVelocity);
            % [~,dampingEnergySum] = calculatedampingenergy(nodalVelocity,DAMPING,cellVolume,dampingEnergySum,nodalDisplacementDT);
            
            % Calculate and output the percentage of progress of time integration
            % percProgress = (iTimeStep / nTimeSteps) * 100;
            % fprintf('Time integration: %.3f%% \n', percProgress)
            
            
            % Save variable history
            nodalDisplacementHistory(iTimeStep,1) = - nodalDisplacement(150,3);
            % kineticEnergyHistory(iTimeStep,1) = kineticEnergy;
            % strainEnergyHistory(iTimeStep,1) = strainEnergy;
            % externalWorkHistory(iTimeStep,1) = externalWorkSum;
            % dampingEnergyHistory(iTimeStep,1) = dampingEnergySum;
            % appliedForceHistory(iTimeStep,1) = appliedForce;
            
            
            %         if mod(iTimeStep,500) == 0
            %             countersave = countersave + 1;
            %             calculatereactionforcestiffnessmatrixapproach
            %             reactionForceHistory(countersave,1) = reactionForce;
            %         end
            
            % Determine reaction force and output load-displacement graph
            if mod(iTimeStep, 100) == 0
                
                % frameCounter = frameCounter + 1;
                fprintf('P: %.0fkN \t Time Step: %.0f \t Equilibrium State: %.3f \t Displacement: %.3fmm\n', 13000, iTimeStep, equilibriumStateAverage(iTimeStep,1), nodalDisplacement(150,3)*1000)
                damage = calculatedamage(BONDLIST, fail, nFAMILYMEMBERS);
                plotnodaldata(undeformedCoordinates, nodalDisplacement, damage, 'Damage');
                % DX = undeformedCoordinates(2,1) - undeformedCoordinates(1,1);
                % plotbonddamage(undeformedCoordinates, deformedCoordinates, damage, DX)
                drawnow
                
            end
            
            
            % if equilibriumStateAverage(iTimeStep,1) < equilibriumTolerance
                % save output
                % break
            % end
            
            
        end
        

%     end

    timeintegrationTiming = toc;
    fprintf('Time integration complete in %fs \n', timeintegrationTiming)    
    
     % plotvariablehistory(nTimeSteps,equilibriumStateAverage,'Equilibrium State')
     % plotvariablehistory(nTimeSteps,nodalDisplacementHistory,'Nodal Displacement')
    
%     plotvariablehistory(nTimeSteps,kineticEnergyHistory,'Kinetic Energy (J)')
%     plotvariablehistory(nTimeSteps,strainEnergyHistory,'Strain Energy (J)')
%     plotvariablehistory(nTimeSteps,externalWorkHistory,'External Work (J)')
%     plotvariablehistory(nTimeSteps,dampingEnergyHistory,'Damping Energy (J)')
%     plotvariablehistory(nTimeSteps,appliedForceHistory,'Applied Force (N)')
%     plotnodaldata(undeformedCoordinates,nodalDisplacement,nodalStrainEnergyDensity,'Strain Energy Density')
    
  

% end


end

