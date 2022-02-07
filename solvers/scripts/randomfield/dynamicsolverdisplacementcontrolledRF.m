function [] = dynamicsolverdisplacementcontrolledRF(nSimulations, nThreads)
% -------------------------------------------------------------------------
% Dynamic solver displacement controlled - random field generator
% -------------------------------------------------------------------------
% Solve the dynamic peridynamic equation of motion 

% INPUT:
%   nSimulation - Number of simulations (generate random fields)
%   nThreads - Number of OpenMP threads
%
% OUTPUT:
%   deformedCoordinates - coordinates of deformed nodes
%   fail - vector to track if a bond has failed
%   history - value of a variable at every time-step
% -------------------------------------------------------------------------

simulationCounter = 0;
inputdatafilename = 'd_80mm_e_pt625d_DX5mm';

for i = 1 : nSimulations
    
    simulationCounter = simulationCounter + 1;

    %% Create a new input file - generate random field

    % Gregoire_beam_tests_random_field_simplified;
    GarciaAlvarez_beam_tests_random_field_simplified;

    %% Initialise constants and empty arrays

    arraypreallocation

    MAXBODYFORCE = 0;                               % function calculatenodalforce requires this input
    deformedCoordinates = undeformedCoordinates;    % At t = 0, deformedCoordinates = undeformedCoordinates
    frequency = 200;                                % Frequency at which data is printed to output
    bsf = zeros(nBonds,1);
    damageEnergy = zeros(nBonds,1);
    counter = 0;

    %% Dynamic solver: displacement-controlled

    nodalForceX = zeros(nNodes, nThreads); 
    nodalForceZ = zeros(nNodes, nThreads);
    nodalForceY = zeros(nNodes, nThreads);

    % Time Stepping Loop
    for iTimeStep = simulation.timeStepTracker : simulation.nTimeSteps

        simulation.timeStepTracker = iTimeStep + 1; % If a checkpoint file is loaded, the simulation needs to start on the next iteration, (tt + 1)  

        % Use a smooth amplitude curve to define the displacement increment at every time step
        displacementIncrement = smoothstepdata(iTimeStep, 1, simulation.nTimeSteps, 0, simulation.appliedDisplacement);  

        % Calculate deformed length of every bond
        calculatedeformedlengthMex(deformedCoordinates, BONDLIST, UNDEFORMEDLENGTH, deformedLength, deformedX, deformedY, deformedZ, stretch)

        % Calculate bond softening factor    
        bsf(:,:) = 0;   % Does bsf need to be initialised for every time step?
        calculatebsfexponentialMex(stretch, s0, sc, 25, 0.25, bsf, bondSofteningFactor, BONDTYPE, flagBondSoftening); 

        % Determine if bonds have failed
        % calculatebondfailureMex(fail, failureFunctionality, BONDTYPE, stretch, sc, bond.steel.sc);

        % Calculate bond force for every bond
        calculatebondforcesMex(bForceX, bForceY, bForceZ, fail, deformedX, deformedY, deformedZ, deformedLength, stretch, stretchPlastic, BONDSTIFFNESS, cellVolume, VOLUMECORRECTIONFACTORS, bondSofteningFactor);

        % Calculate nodal force for every node
        nodalForce(:,:) = 0;     % Nodal force - initialise for every time step
        nodalForceX(:,:) = 0;    % Nodal force - initialise for every time step
        nodalForceY(:,:) = 0;    % Nodal force - initialise for every time step
        nodalForceZ(:,:) = 0;    % Nodal force - initialise for every time step
        calculatenodalforcesopenmpMex(BONDLIST, nodalForce, bForceX, bForceY, bForceZ, nodalForceX, nodalForceY, nodalForceZ)

        % Time integration
        timeintegrationeulercromerMex(nodalAcceleration, nodalForce, simulation.DAMPING, nodalVelocity, DENSITY, CONSTRAINTFLAG, simulation.DT, nodalDisplacement, deformedCoordinates, undeformedCoordinates);

        % Penetrator
        [nodalDisplacement, nodalVelocity, deformedCoordinates, penetratorfz1] = calculatecontactforce(penetrator, displacementIncrement, undeformedCoordinates, deformedCoordinates, nodalDisplacement, nodalVelocity, simulation.DT, cellVolume, DENSITY);

        % Supports
        [nodalDisplacement, nodalVelocity, deformedCoordinates, ~] = calculatecontactforce(supports(1), 0, undeformedCoordinates, deformedCoordinates, nodalDisplacement, nodalVelocity, simulation.DT, cellVolume, DENSITY);
        [nodalDisplacement, nodalVelocity, deformedCoordinates, ~] = calculatecontactforce(supports(2), 0, undeformedCoordinates, deformedCoordinates, nodalDisplacement, nodalVelocity, simulation.DT, cellVolume, DENSITY);

        
        reactionForce = penetratorfz1;
        CMOD = nodalDisplacement(simulation.CMOD(2),1) - nodalDisplacement(simulation.CMOD(1),1);
        
        % load-CMOD
        if mod(iTimeStep, frequency) == 0

            counter = counter + 1;
            
            loadCMOD(1, counter) = reactionForce;
            loadCMOD(2, counter) = CMOD;
            
            fprintf('%.0f \t %.5f \t %.6f \n', iTimeStep, reactionForce, CMOD * 1000) 
            
        end

        % Save load-CMOD data
        if (CMOD * 1000 > 0.25) && (mod(iTimeStep, frequency) == 0)

           [folderPath] = findfolder('BB_PD/output/outputfiles/randomfield/');
           inputdatafilename = erase(inputdatafilename,'.mat');             % erase .mat from inputdatafilename
           baseFileName = sprintf('%s_%d_loadCMOD.mat', inputdatafilename, simulationCounter);
           fullFileName = fullfile(folderPath , baseFileName);
           save(fullFileName, 'loadCMOD')
           break

        end

    end

end


end

