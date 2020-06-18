function [deformedCoordinates,fail,stretch] = newtonraphsonloadcontrolled(inputdatafilename, config)
% newtonraphsonloadcontrolled - this function uses a standard
% Newton-Rapshon procedure to solve the static peridynamic equation of
% motion. Bond failure is not permitted with this method. 
%
% Syntax: 
%
% Inputs:
%   input1  - 
% 
%
% Outputs:
%   output1 -
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none
%
% Mark Hobbs 
% mch61@cam.ac.uk
% Department of Engineering
% Cambridge University
% June 2019

% ---------------------------- BEGIN CODE ---------------------------------

% Load the defined input file name                  
load(inputdatafilename, config.dynamicsolverinputlist{:});

% Initialise constants, arrays, and variables
nNodes = size(undeformedCoordinates,1);
NOD = size(undeformedCoordinates,2);
nBonds = size(BONDLIST,1); fprintf('Number of bonds = %d  \n', nBonds)
fail = zeros(nBonds,1) + 1;  
deformedX = zeros(nBonds,1);
deformedY = zeros(nBonds,1);
deformedZ = zeros(nBonds,1);
deformedLength = zeros(nBonds,1);
bForceX = zeros(nBonds,1);
bForceY = zeros(nBonds,1);
bForceZ = zeros(nBonds,1);
stretch = zeros(nBonds,1);
stretchPlastic = zeros(nBonds,1);
nodalForce = zeros(nNodes, NOD);
% nBondsBrokenTotalPreviousIteration = 0;   % Total number of bonds broken (previous iteration) - used to track number of bonds broken per iteration
loadIncrementCounter = 0;
startLoadMultiplier = 0.1 ;
finalLoadMultiplier = 10;
incrementLoadMultiplier = 0.1;
deformedCoordinates = undeformedCoordinates;    % For the first iteration, deformedCoordinates is equal to undeformedCoordinates
nBondsBrokenTotalPreviousIteration = 0;         % Total number of bonds broken (previous iteration) - used to track number of bonds broken per iteration
flagBondSoftening = zeros(nBonds,1);
bondSofteningFactor = zeros(nBonds,1);
MAXBODYFORCE = -500000000;

% Failure functionality
if strcmp(config.failureFunctionality ,'on')
    
    failureFunctionality = 0;
    
elseif strcmp(config.failureFunctionality ,'off')
    
    failureFunctionality = 1;
        
end

% Boundary conditions - determine the constrained and unconstrained DOFs
[constrainedDOF, unconstrainedDOF] = buildconstrainedDOF(CONSTRAINTFLAG);

% Boundary conditions - build the external force vector
startFext = buildexternalforcevector(BODYFORCEFLAG,MAXBODYFORCE,cellVolume,constrainedDOF);

% ----------------------- START LOAD INCREMENT ---------------------------- 

currentFext = startFext * startLoadMultiplier;
previousFext = 0;

% Loop to incrementally increase the externally applied load 
for loadMultiplier = startLoadMultiplier : incrementLoadMultiplier : finalLoadMultiplier
    
    loadIncrementCounter = loadIncrementCounter + 1;
    
    deltaF = currentFext - previousFext; fprintf('\nLoad Increment Counter = %d, \t Load increment = %.2fN \n', loadIncrementCounter, sum(deltaF))
    
    Fext = startFext * loadMultiplier;
    
    % Calculate the global stiffness matrix for the undeformed member
    K = buildstiffnessmatrix(deformedCoordinates,BONDLIST,VOLUMECORRECTIONFACTORS,cellVolume,BONDSTIFFNESS,BFMULTIPLIER,fail,bondSofteningFactor,constrainedDOF,UNDEFORMEDLENGTH);
    
    % Calculate the change in displacement (DELTA U)
    [deltaDisplacementVector] = bicgstabl(K,deltaF,[],5000); % Using symmetric LQ method or lsqr
    
    % Update nodal coordinates
    [deformedCoordinates,~,totalDisplacementVector] = updatecoordinates(undeformedCoordinates,deformedCoordinates,deltaDisplacementVector,unconstrainedDOF,constrainedDOF);

    % Calculate bond stretch
    [deformedLength,deformedX,deformedY,deformedZ,stretch] = calculatedeformedlength(deformedLength,deformedX,deformedY,deformedZ,stretch,deformedCoordinates,UNDEFORMEDLENGTH,BONDLIST,nBonds);
    
    % Calculate bond softening factor for bilinear material model
    [bondSofteningFactor, flagBondSoftening] = calculatebondsofteningfactor(stretch, s0, s0 * 25, flagBondSoftening, bondSofteningFactor, BONDTYPE);
      
    % Calculate bond failure
    fail = calculatebondfailure(fail,failureFunctionality,BONDTYPE,stretch,s0 * 25,1);
    
    % Did any bonds fail or yield?
    [nBondsBrokenTotal,nBondsBrokenCurrentIteration] = trackbondfailure(nBonds,fail,nBondsBrokenTotalPreviousIteration);
        
    % Calculate the internal force vector
    % Step 1: calculate bond forces
    % Step 2: calculate nodal forces
    % Step 3: re-arrange into Fint vector
    [bForceX,bForceY,bForceZ] = calculatebondforces(bForceX,bForceY,bForceZ,fail,deformedX,deformedY,deformedZ,deformedLength,stretch,stretchPlastic,nBonds,BFMULTIPLIER,BONDSTIFFNESS,cellVolume,VOLUMECORRECTIONFACTORS,bondSofteningFactor);
    [nodalForce] = calculatenodalforces(BONDLIST,nodalForce,bForceX,bForceY,bForceZ,BODYFORCEFLAG,0); 
    nodalForce = nodalForce * cellVolume;
    Fint = reshape(nodalForce',[1 size(nodalForce,1) * size(nodalForce,2)])';
    Fint(constrainedDOF,:) = [];
         
    % Check the convergence criteria
    [g,gEuclideanNorm,tolerance] = checkconvergencecriteria(Fext,-Fint);
    
    fprintf('Displacement = %.6f mm \n', (deformedCoordinates(18,3) - undeformedCoordinates(18,3)) * 1000)
    
    CMOD = (deformedCoordinates(25,1) - undeformedCoordinates(25,1)) - (deformedCoordinates(15,1) - undeformedCoordinates(15,1));
    fprintf('CMOD = %.6f mm \n', CMOD * 1000)
    
    damage = calculatedamage(BONDLIST, fail, nFAMILYMEMBERS);
    plotnodaldata(undeformedCoordinates, (deformedCoordinates - undeformedCoordinates), damage, 'damage', 20, 100)
    drawnow
    
    % ------------------- START ITERATIVE PROCEDURE -----------------------
    
    % Enter into while loop and repeat (iterate) until the out of balance
    % force vector is within a defined tolerance. 
    
    iterativeCounter = 0;
    
    while gEuclideanNorm > tolerance
        
        iterativeCounter = iterativeCounter + 1;
    
        % Build the tangent stiffness matrix (update stiffness matrix)
        Ktangent = buildstiffnessmatrix(deformedCoordinates,BONDLIST,VOLUMECORRECTIONFACTORS,cellVolume,BONDSTIFFNESS,BFMULTIPLIER,fail,bondSofteningFactor,constrainedDOF,UNDEFORMEDLENGTH); 
        
        % Calculate the change in displacement (delta U)
        [deltaDisplacementVector] = lsqr(Ktangent,g,[],5000); % Using symmetric LQ method or lsqr (Ktangent,g,[],5000)
        
        % Update nodal coordinates
        [deformedCoordinates,~,totalDisplacementVector] = updatecoordinates(undeformedCoordinates,deformedCoordinates,deltaDisplacementVector,unconstrainedDOF,constrainedDOF);

        % Calculate bond stretch
        [deformedLength,deformedX,deformedY,deformedZ,stretch] = calculatedeformedlength(deformedLength,deformedX,deformedY,deformedZ,stretch,deformedCoordinates,UNDEFORMEDLENGTH,BONDLIST,nBonds);
        
        % Calculate bond softening factor for bilinear material model
        [bondSofteningFactor, flagBondSoftening] = calculatebondsofteningfactor(stretch, s0, s0 * 25, flagBondSoftening, bondSofteningFactor, BONDTYPE);
      
        % Calculate bond failure
        fail = calculatebondfailure(fail,failureFunctionality,BONDTYPE,stretch,s0 * 25,1);
        
        % Did any bonds fail or yield?
        [nBondsBrokenTotal,nBondsBrokenCurrentIteration] = trackbondfailure(nBonds,fail,nBondsBrokenTotalPreviousIteration);
        
        % Calculate the internal force vector
        [bForceX,bForceY,bForceZ] = calculatebondforces(bForceX,bForceY,bForceZ,fail,deformedX,deformedY,deformedZ,deformedLength,stretch,stretchPlastic,nBonds,BFMULTIPLIER,BONDSTIFFNESS,cellVolume,VOLUMECORRECTIONFACTORS,bondSofteningFactor);
        [nodalForce] = calculatenodalforces(BONDLIST,nodalForce,bForceX,bForceY,bForceZ,BODYFORCEFLAG,0); 
        nodalForce = nodalForce * cellVolume;
        Fint = reshape(nodalForce',[1 size(nodalForce,1) * size(nodalForce,2)])';
        Fint(constrainedDOF,:) = [];
         
        % Calculate the out of balance force vector and check the convergence criteria    
        [g,gEuclideanNorm,tolerance] = checkconvergencecriteria(Fext,-Fint);      
        
        fprintf('Displacement = %.6f mm \n', (deformedCoordinates(18,3) - undeformedCoordinates(18,3)) * 1000)
    
        CMOD = (deformedCoordinates(25,1) - undeformedCoordinates(25,1)) - (deformedCoordinates(15,1) - undeformedCoordinates(15,1));
        fprintf('CMOD = %.6f mm \n', CMOD * 1000)
    
        damage = calculatedamage(BONDLIST, fail, nFAMILYMEMBERS);
        plotnodaldata(undeformedCoordinates, (deformedCoordinates - undeformedCoordinates), damage, 'damage', 20, 100)
        drawnow
        
    end
    
    % ------------------- END ITERATIVE PROCEDURE -------------------------
    
    
    previousFext = currentFext;
    currentFext = (loadMultiplier + incrementLoadMultiplier) * startFext;
    nBondsBrokenTotalPreviousIteration = nBondsBrokenTotal;

    % Save and plot results at the end of every load increment
    
    
end    
% ------------------------ END LOAD INCREMENT ----------------------------- 

% ----------------------------- END CODE ----------------------------------
end

