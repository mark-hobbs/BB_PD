function [deformedCoordinates,fail,stretch] = newtonraphsonloadcontrolled(inputdatafilename,config)
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
stretch = zeros(nBonds,1);
% displacedCoordinates = COORDINATES;       % For the first iteration, displacedCoordinates is equal to COORDINATES
% nBondsBrokenTotalPreviousIteration = 0;   % Total number of bonds broken (previous iteration) - used to track number of bonds broken per iteration
% counterLoadStep = 0;
loadIncrementCounter = 0;
startLoadMultiplier = 1 ;
finalLoadMultiplier = 1;
incrementLoadMultiplier = 0.0025;
deformedCoordinates = undeformedCoordinates; % For the first iteration, deformedCoordinates is equal to undeformedCoordinates
nBondsBrokenTotalPreviousIteration = 0;   % Total number of bonds broken (previous iteration) - used to track number of bonds broken per iteration
flagBondYield = zeros(nBonds,1);

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
    K = buildstiffnessmatrix(deformedCoordinates,BONDLIST,VOLUMECORRECTIONFACTORS,cellVolume,BONDSTIFFNESS,BFMULTIPLIER,fail,constrainedDOF);
    
    % Calculate the change in displacement (DELTA U)
    deltaDisplacementVector = symmlq(K,deltaF,[],5000); % Using symmetric LQ method
    
    % Update nodal coordinates
    [deformedCoordinates,~,totalDisplacementVector] = updatecoordinates(undeformedCoordinates,deformedCoordinates,deltaDisplacementVector,unconstrainedDOF,constrainedDOF);

    % Calculate bond stretch
    [~,~,~,~,stretch] = calculatedeformedlength(deformedLength,deformedX,deformedY,deformedZ,stretch,deformedCoordinates,UNDEFORMEDLENGTH,BONDLIST,nBonds);
    %[~,~,~,stretch] = calculatedeformedlength2D(deformedCoordinates,UNDEFORMEDLENGTH,deformedX,deformedY,nBonds,BONDLIST);
    
    % Calculate plastic stretch for steel-steel bonds
    % [stretchPlastic,yieldingLength,flagBondYield] = calculateplasticstretch(yieldingLength,flagBondYield,stretch,BONDTYPE,deformedLength);
    % sum(flagBondYield)
    
    % Calculate bond failure
    fail = calculatebondfailure(fail,failureFunctionality,BONDTYPE,stretch,criticalStretchConcrete,criticalStretchSteel);
    
    % Did any bonds fail or yield?
    [nBondsBrokenTotal,nBondsBrokenCurrentIteration] = trackbondfailure(nBonds,fail,nBondsBrokenTotalPreviousIteration);
        
    % Calculate the internal force vector
    Fint = K * totalDisplacementVector;
         
    % Check the convergence criteria
    [g,gEuclideanNorm,tolerance] = checkconvergencecriteria(Fext,Fint);
    
    fprintf('Displacement = %.6fmm \n', (deformedCoordinates(87,3) - undeformedCoordinates(87,3))*1000)
    
    damage = calculatedamage(BONDLIST, fail, nFAMILYMEMBERS);
    plotnodaldata(undeformedCoordinates, (deformedCoordinates - undeformedCoordinates)*0, damage, 'damage')
    drawnow
    
    % ------------------- START ITERATIVE PROCEDURE -----------------------
    
    % Enter into while loop and repeat (iterate) until the out of balance
    % force vector is within a defined tolerance. 
    
    iterativeCounter = 0;
    
    while gEuclideanNorm > tolerance
        
        iterativeCounter = iterativeCounter + 1;
    
        % Update the stiffness matrix
        Ktangent = buildstiffnessmatrix(deformedCoordinates,BONDLIST,VOLUMECORRECTIONFACTORS,cellVolume,BONDSTIFFNESS,BFMULTIPLIER,fail,constrainedDOF); 
        
        % Calculate the change in displacement (delta U)
        deltaDisplacementVector = symmlq(Ktangent,g,[],5000); % Using symmetric LQ method ,[],[],totalDisplacementVector)
        
        % Update nodal coordinates
        [deformedCoordinates,~,totalDisplacementVector] = updatecoordinates(undeformedCoordinates,deformedCoordinates,deltaDisplacementVector,unconstrainedDOF,constrainedDOF);

        % Calculate bond stretch
        [~,~,~,~,stretch] = calculatedeformedlength(deformedCoordinates,UNDEFORMEDLENGTH,deformedX,deformedY,deformedZ,nBonds,BONDLIST);
        %[~,~,~,stretch] = calculatedeformedlength2D(deformedCoordinates,UNDEFORMEDLENGTH,deformedX,deformedY,nBonds,BONDLIST);
        
        % Calculate plastic stretch for steel-steel bonds
        %[stretchPlastic,yieldingLength,flagBondYield] = calculateplasticstretch(yieldingLength,flagBondYield,stretch,BONDTYPE,deformedLength);
        
        % Calculate bond failure
        fail = calculatebondfailure(fail,failureFunctionality,BONDTYPE,stretch,criticalStretchConcrete,criticalStretchSteel);
        
        % Did any bonds fail or yield?
        [nBondsBrokenTotal,nBondsBrokenCurrentIteration] = trackbondfailure(nBonds,fail,nBondsBrokenTotalPreviousIteration);
        
        % Calculate the internal force vector
        Fint = Ktangent * totalDisplacementVector;
        
        % Calculate the out of balance force vector and check the convergence criteria    
        [g,gEuclideanNorm,tolerance] = checkconvergencecriteria(Fext,Fint);      
        
        fprintf('Displacement = %.6fmm \n', (deformedCoordinates(87,3) - undeformedCoordinates(87,3))*1000)
        
        damage = calculatedamage(BONDLIST, fail, nFAMILYMEMBERS);
        plotnodaldata(undeformedCoordinates, (deformedCoordinates - undeformedCoordinates)*0, damage, 'damage')
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

