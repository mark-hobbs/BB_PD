function [deformedCoordinates,fail,stretch] = newtonraphsondisplacementcontrolled(inputdatafilename, config)
% newtonraphsondisplacementcontrolled - this function uses a
% displacement-controlled Newton-Rapshon procedure to solve the static
% peridynamic equation of motion. The solver is based on that described in
% Section 2.6 of 'Non-linear finite element analysis of solids and
% structures' De Borst et al., 2012
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
% June 2020

% ---------------------------- BEGIN CODE ---------------------------------

% Load the defined input file name                  
load(inputdatafilename, config.dynamicsolverinputlist{:});

% Initialise constants, arrays, and variables
nNodes = size(undeformedCoordinates,1);
NOD = size(undeformedCoordinates,2);
nBonds = size(BONDLIST,1); fprintf('Number of bonds = %d  \n', nBonds)
nodalDisplacement = zeros(nNodes, NOD);
fail = zeros(nBonds,1) + 1;  
deformedX = zeros(nBonds,1);
deformedY = zeros(nBonds,1);
deformedZ = zeros(nBonds,1);
deformedLength = zeros(nBonds,1);
stretch = zeros(nBonds,1);

deformedCoordinates = undeformedCoordinates; % For the first iteration, deformedCoordinates is equal to undeformedCoordinates
nBondsBrokenCurrentIteration = 0;
nBondsBrokenTotalPreviousIteration = 0;   % Total number of bonds broken (previous iteration) - used to track number of bonds broken per iteration
flagBondSoftening = zeros(nBonds,1);
bondSofteningFactor = zeros(nBonds,1);
bForceX = zeros(nBonds,1);
bForceY = zeros(nBonds,1);
bForceZ = zeros(nBonds,1);
stretchPlastic = zeros(nBonds,1);
nodalForce = zeros(nNodes, NOD);
DISPLACEMENTFLAG = zeros(nNodes,NOD);
MAXBODYFORCE = 0;

% Failure functionality
if strcmp(config.failureFunctionality ,'on')
    
    failureFunctionality = 0;
    
elseif strcmp(config.failureFunctionality ,'off')
    
    failureFunctionality = 1;
        
end

% Boundary conditions - determine the constrained and unconstrained DOFs
[constrainedDOF, unconstrainedDOF] = buildconstrainedDOF(CONSTRAINTFLAG);

% Boundary conditions - build the external force vector
% startFext = buildexternalforcevector(BODYFORCEFLAG,MAXBODYFORCE,cellVolume,constrainedDOF);

Fext = zeros(nNodes * NOD, 1);      % Internal force vector (nNodes x NOD, 1)
Fext(constrainedDOF,:) = [];   

% ------------------- START DISPLACEMENT INCREMENT ------------------------

counter = 0;

% Loop to incrementally increase the externally applied displacement
for iTimeStep = 1 : simulation.nTimeSteps % TODO - number of loading steps
    
    fprintf('\n\n')
        
    counter = counter + 1;
                  
    % Apply displacement using a rigid penetrator. Determine new nodal
    % positions for nodes that lie within the rigid penetrator and flag
    % applied displacements
    % displacementIncrement = smoothstepdata(iTimeStep, 1, nTimeSteps, 0, appliedDisplacement);
    % [nodalDisplacement, deformedCoordinates, DISPLACEMENTFLAG] = applydisplacement(penetrator, - 0.000002 * counter, undeformedCoordinates, deformedCoordinates, nodalDisplacement);
                
    for i = 1 : nNodes
      
        if BODYFORCEFLAG(i,3) == 1
        
            DISPLACEMENTFLAG(i,3) = 1;
            
            nodalDisplacement(i,3) = - 0.000001 * counter;
        
        end
        
    end
    
    % Boundary conditions - determine the constrained and unconstrained DOFs
    [applieddisplacementDOF, noapplieddisplacementDOF] = buildconstrainedDOF(DISPLACEMENTFLAG);
    
    % Calculate the global stiffness matrix
    [K] = buildstiffnessmatrix(deformedCoordinates,BONDLIST,VOLUMECORRECTIONFACTORS,cellVolume,BONDSTIFFNESS,BFMULTIPLIER,fail,bondSofteningFactor,constrainedDOF,UNDEFORMEDLENGTH);
    
    % Build the constraint matrix
    [C] = buildconstraintmatrix(nNodes, NOD, applieddisplacementDOF, constrainedDOF);
    
    % Build the reduced stiffness matrix;
    Kuu = (C' * K) * C;
    
    % Build the right-hand side of the system
    u = reshape(nodalDisplacement',[1 size(nodalDisplacement,1) * size(nodalDisplacement,2)])';
    effectiveForceVec = (-C' * K) * u;
    
    % The prescribed displacements must be incorporated into the external
    % force vector
    
    % Determine the effective force         
        
    % Calculate the change in displacement (DELTA U)
    deltaDisplacementVector = bicgstabl(Kuu,effectiveForceVec,[],100);
    
    % Update nodal coordinates
    U = C * deltaDisplacementVector;
    U(applieddisplacementDOF,:) = - 0.000001;
    deltaDisplacement = reshape(U,NOD,[])';                            % Re-shape (nNodes, NOD)
    deformedCoordinates = deformedCoordinates + deltaDisplacement;     % Update coordinates <------------- LOOK AT THIS!
    
    nodalDisplacement = deformedCoordinates - undeformedCoordinates;
    U = reshape(nodalDisplacement',[1 size(nodalDisplacement,1) * size(nodalDisplacement,2)])';
    
    K(constrainedDOF,:) = [];
    K(:,constrainedDOF) = [];
    U(constrainedDOF) = [];
    Fext = K * U;
    
    % Calculate bond stretch
    [deformedLength,deformedX,deformedY,deformedZ,stretch] = calculatedeformedlength(deformedLength,deformedX,deformedY,deformedZ,stretch,deformedCoordinates,UNDEFORMEDLENGTH,BONDLIST,nBonds);
    
    % Calculate bond softening factor for bilinear material model
    [bondSofteningFactor, flagBondSoftening] = calculatebondsofteningfactor(stretch, bond.concrete.s0, bond.concrete.s0 * 25, flagBondSoftening, bondSofteningFactor, BONDTYPE);
      
    % Calculate bond failure
    fail = calculatebondfailure(fail,failureFunctionality,BONDTYPE,stretch,bond.concrete.s0 * 25,1);
    
    % Did any bonds fail or yield?
    [nBondsBrokenTotal,nBondsBrokenCurrentIteration] = trackbondfailure(nBonds,fail,nBondsBrokenTotalPreviousIteration);
        
    % Calculate the internal force vector
    % Step 1: calculate bond forces
    [bForceX,bForceY,bForceZ] = calculatebondforces(bForceX,bForceY,bForceZ,fail,deformedX,deformedY,deformedZ,deformedLength,stretch,stretchPlastic,nBonds,BFMULTIPLIER,BONDSTIFFNESS,cellVolume,VOLUMECORRECTIONFACTORS,bondSofteningFactor);
    [nodalForce] = calculatenodalforces(BONDLIST,nodalForce,bForceX,bForceY,bForceZ,BODYFORCEFLAG,0);
    nodalForce = nodalForce * cellVolume;
    Fint = reshape(nodalForce',[1 size(nodalForce,1) * size(nodalForce,2)])';
    Fint(constrainedDOF,:) = [];
        
    % Check the convergence criteria
    [g,gEuclideanNorm,tolerance] = checkconvergencecriteria(Fext,-Fint);
    
    fprintf('Displacement = %.6f mm \n', (deformedCoordinates(18,3) - undeformedCoordinates(18,3)) * 1000)
    
    CMOD = (deformedCoordinates(25,1) - undeformedCoordinates(25,1)) - (deformedCoordinates(10,1) - undeformedCoordinates(10,1));
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
    
        % Update the stiffness matrix
        Ktangent = buildstiffnessmatrix(deformedCoordinates,BONDLIST,VOLUMECORRECTIONFACTORS,cellVolume,BONDSTIFFNESS,BFMULTIPLIER,fail,bondSofteningFactor,constrainedDOF,UNDEFORMEDLENGTH);
        
        % Calculate the change in displacement (delta U)
        Ktangent(constrainedDOF,:) = [];
        Ktangent(:,constrainedDOF) = [];
        deltaDisplacementVector = lsqr(Ktangent,g,[],5000);        % Using symmetric LQ method or lsqr
        
        % Update nodal coordinates
        [deformedCoordinates,~,totalDisplacementVector] = updatecoordinates(undeformedCoordinates,deformedCoordinates,deltaDisplacementVector,unconstrainedDOF,constrainedDOF);      
        
        % Calculate bond stretch
        [deformedLength,deformedX,deformedY,deformedZ,stretch] = calculatedeformedlength(deformedLength,deformedX,deformedY,deformedZ,stretch,deformedCoordinates,UNDEFORMEDLENGTH,BONDLIST,nBonds);
        
        % Calculate bond softening factor for bilinear material model
        [bondSofteningFactor, flagBondSoftening] = calculatebondsofteningfactor(stretch, bond.concrete.s0, bond.concrete.s0 * 25, flagBondSoftening, bondSofteningFactor, BONDTYPE);
      
        % Calculate bond failure
        fail = calculatebondfailure(fail,failureFunctionality,BONDTYPE,stretch,bond.concrete.s0 * 25,1);
        
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
    
        CMOD = (deformedCoordinates(25,1) - undeformedCoordinates(25,1)) - (deformedCoordinates(10,1) - undeformedCoordinates(10,1));
        fprintf('CMOD = %.6f mm \n', CMOD * 1000)
    
        damage = calculatedamage(BONDLIST, fail, nFAMILYMEMBERS);
        plotnodaldata(undeformedCoordinates, (deformedCoordinates - undeformedCoordinates), damage, 'damage', 20, 100)
        drawnow
        
    end
    
    % ------------------- END ITERATIVE PROCEDURE -------------------------
    
    
    %Fext = Fint;
    nBondsBrokenTotalPreviousIteration = nBondsBrokenTotal;
    nodalDisplacement = deformedCoordinates - undeformedCoordinates;

    % Save and plot results at the end of every load increment
    
    
end    
% ------------------------ END LOAD INCREMENT ----------------------------- 

% ----------------------------- END CODE ----------------------------------
end

