function [deformedCoordinates,fail] = dynamicsolverdisplacementcontrolled(inputdatafilename, config, checkpointfileflag, checkpointfilename)
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

% Time Stepping Loop
for iTimeStep = timeStepTracker : nTimeSteps
    
    timeStepTracker = iTimeStep + 1; % If a checkpoint file is loaded, the simulation needs to start on the next iteration, (tt + 1)  
    
    % Use a smooth amplitude curve to define the displacement increment at every time step
    displacementIncrement = smoothstepdata(iTimeStep, 1, nTimeSteps, 0, appliedDisplacement);
    
    % Calculate deformed length of every bond
    calculatedeformedlengthMex(deformedCoordinates, BONDLIST, UNDEFORMEDLENGTH, deformedLength, deformedX, deformedY, deformedZ, stretch)
    
    % Calculate bond softening factor for bilinear material model
    [bondSofteningFactor, flagBondSoftening] = calculatebondsofteningfactor(stretch,bond.concrete.s0,bond.concrete.sc,flagBondSoftening,bondSofteningFactor,BONDTYPE);
    
    % Determine if bonds have failed
    calculatebondfailureMex(fail,failureFunctionality,BONDTYPE,stretch,bond.concrete.sc,bond.steel.sc);
    
    % Calculate bond force for every bond
    calculatebondforcesMex(bForceX,bForceY,bForceZ,fail,deformedX,deformedY,deformedZ,deformedLength,stretch,stretchPlastic,BONDSTIFFNESS,cellVolume,VOLUMECORRECTIONFACTORS,bondSofteningFactor);
    
    % Calculate nodal force for every node
    nodalForce(:,:) = 0;     % Nodal force - initialise for every time step
    nodalForceX(:,:) = 0;    % Nodal force - initialise for every time step
    nodalForceY(:,:) = 0;    % Nodal force - initialise for every time step
    nodalForceZ(:,:) = 0;    % Nodal force - initialise for every time step
    calculatenodalforcesopenmpMex(BONDLIST, nodalForce, bForceX, bForceY, bForceZ, nodalForceX, nodalForceY, nodalForceZ)
        
    % Time integration
    [nodalDisplacement,nodalVelocity,deformedCoordinates,~] = timeintegrationeulercromer(nodalForce,nodalDisplacement,nodalVelocity,DAMPING,DENSITY,CONSTRAINTFLAG,undeformedCoordinates,DT,BODYFORCEFLAG,config.loadingMethod,displacementIncrement,deformedCoordinates);    

    % Penetrator
    [nodalDisplacement, nodalVelocity, deformedCoordinates, penetratorfz1] = calculatecontactforce(penetrator, displacementIncrement, undeformedCoordinates, deformedCoordinates, nodalDisplacement, nodalVelocity, DT, cellVolume, DENSITY);

    % Supports
    [nodalDisplacement, nodalVelocity, deformedCoordinates, supportfz1] = calculatecontactforce(supports(1), 0, undeformedCoordinates, deformedCoordinates, nodalDisplacement, nodalVelocity, DT, cellVolume, DENSITY);
    [nodalDisplacement, nodalVelocity, deformedCoordinates, supportfz2] = calculatecontactforce(supports(2), 0, undeformedCoordinates, deformedCoordinates, nodalDisplacement, nodalVelocity, DT, cellVolume, DENSITY);
    
    % Calculate reaction force
    reactionForce = penetratorfz1;
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
       inputdatafilename = erase(inputdatafilename,'.mat');             % erase .mat from inputdatafilename
       baseFileName = sprintf('%s_checkpoint.mat', inputdatafilename);
       fullFileName = fullfile(folderPath , baseFileName);
       save(fullFileName)
        
    end
    
end

timeintegrationTiming = toc;
fprintf('Time integration complete in %fs \n', timeintegrationTiming)


end

