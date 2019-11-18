function [fail,totalDisplacement,stretch] = newtonraphson(COORDINATES,BONDLIST,VOLUMECORRECTIONFACTORS,VOLUME,BONDSTIFFNESS,CONSTRAINTFLAG,BODYFORCE,MAXBODYFORCE,BFMULTIPLIER,CRITICAL_STRETCH_CONCRETE,CRITICAL_STRETCH_STEEL,UNDEFORMEDLENGTH,failure,BONDTYPE,MATERIALFLAG,nFAMILYMEMBERS,DX,bodyforceCounter)
% newtonraphson -  This functions solves sets of non-linear equations in
% the form F = Ku using the Newton-Raphson method
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

%% Initialise constants, arrays, and variables
nNodes = size(COORDINATES,1);
NOD = size(COORDINATES,2);
nBonds = size(BONDLIST,1); fprintf('Number of bonds = %d  \n', nBonds)

fail = zeros(nBonds,1) + 1;  
deformedX = zeros(nBonds,1);
deformedY = zeros(nBonds,1);
deformedZ = zeros(nBonds,1);
deformedLength = zeros(nBonds,1);
displacedCoordinates = COORDINATES;       % For the first iteration, displacedCoordinates is equal to COORDINATES
nBondsBrokenTotalPreviousIteration = 0;   % Total number of bonds broken (previous iteration) - used to track number of bonds broken per iteration
counterLoadStep = 0;
startLoadMultiplier = 1;
finalLoadMultiplier = 3;
incrementLoadMultiplier = 0.01;

%% ------------------------ START INCREMENT ------------------------------- 
% Loop to incrementally increase the applied load

for loadMultiplier = startLoadMultiplier : incrementLoadMultiplier : finalLoadMultiplier
    
    %% INCREMENT admin
    startLoadMultiplier = loadMultiplier + incrementLoadMultiplier; % If a checkpoint file is loaded, the simulation needs to start on the next load case (loadMultiplier + incrementLoadMultiplier)
    counterLoadStep = counterLoadStep + 1;
    pointLoad = - MAXBODYFORCE * loadMultiplier * bodyforceCounter * VOLUME;
    fprintf('\nFind a static solution for load = %.0fN \n', pointLoad)
    
    %% Build the initial stiffness matrix K
    
    fprintf('Building initial stiffness matrix... ')
    
    if counterLoadStep == 1
        
        % --------------------- First Load Step ---------------------------
        
        MAXBODYFORCEtemp = MAXBODYFORCE * loadMultiplier;
        [Kinitial,Fext,unconstrainedDOF,constrainedDOF,~] = buildstiffnessmatrix(COORDINATES,BONDLIST,VOLUMECORRECTIONFACTORS,VOLUME,BONDSTIFFNESS,BFMULTIPLIER,CONSTRAINTFLAG,BODYFORCE,MAXBODYFORCEtemp,fail);

    else
        
        % ------------------ Subsequent Load Steps ------------------------
        
        MAXBODYFORCEtemp = (MAXBODYFORCE * loadMultiplier) - (MAXBODYFORCE * (loadMultiplier - incrementLoadMultiplier));
        [Kinitial,Fext,unconstrainedDOF,constrainedDOF,~] = buildstiffnessmatrix(displacedCoordinates,BONDLIST,VOLUMECORRECTIONFACTORS,VOLUME,BONDSTIFFNESS,BFMULTIPLIER,CONSTRAINTFLAG,BODYFORCE,MAXBODYFORCEtemp,fail);
    
    end
    
    fprintf('process complete \n')

    %% Calculate the change in displacement u = K^-1 * Fext
    % Solve systems of linear equations in the form Ax = B for x using x = A\B.
    % Therefore for Ku = F, u = K\F. mldivide (\) can be very slow for large sparse
    % matrices. Can also use other methods for solving linear systems of
    % equations such as conjugate gradient method.
    fprintf('Calculate change in displacement... \n')
    deltaDisplacementVector = symmlq(Kinitial,Fext,1e-6,5000); % Using symmetric LQ method
    clear Kinitial

    %% ITERATE admin
    g = 100;              % Initialise the out of balance force vector with a value greater than the tolerance
    tolerance = 10;       % TODO: find advice on setting the tolerance value (see https://classes.engineering.wustl.edu/2009/spring/mase5513/abaqus/docs/v6.6/books/gsa/default.htm?startat=ch08s02.html tolerance is set to 0.5% of force in system)
    counterNewtonRaphsonIteration = 0;
    
    %% ------------------------ START ITERATE -----------------------------
    % Enter into while loop and repeat (iterate) until the out of balance force vector is within a defined tolerance
    
    while abs(sum(g)) > tolerance

        counterNewtonRaphsonIteration = counterNewtonRaphsonIteration + 1;

        %% Calculate the total displacement and update nodal coordinatesUp
        [displacedCoordinates,totalDisplacement,totalDisplacementVector] = updatecoordinates(nNodes,NOD,unconstrainedDOF,constrainedDOF,deltaDisplacementVector,displacedCoordinates,COORDINATES); % Update coordinates
        fprintf('total displacement (%.9f) = displaced coordinates (%.9f) - coordinates (%.9f) \n', totalDisplacement(1500,3),displacedCoordinates(1500,3),COORDINATES(1500,3))  
        
        %% Calculate deformed length of every bond (bond stretch)
        [~,~,~,~,stretch] = calculatedeformedlength(COORDINATES,totalDisplacement,nBonds,BONDLIST,deformedX,deformedY,deformedZ,UNDEFORMEDLENGTH,deformedLength);

        %% Determine which bonds have failed and remove from bond-list
        % Determine if a bond has failed (failure == 1 when failure
        % functionality is turned off)
        
        fail(fail==1 & BONDTYPE==0 & stretch > CRITICAL_STRETCH_CONCRETE) = failure;     % Deactivate bond if stretch exceeds critical stretch   Bond has failed = 0 
        fail(fail==1 & BONDTYPE==1 & stretch > 3 * CRITICAL_STRETCH_CONCRETE) = failure;   % EMU user manual recommends that the critical stretch and bond force are multiplied by a factor of 3 for concrete to steel bonds 
        fail(fail==1 & BONDTYPE==2 & stretch > CRITICAL_STRETCH_STEEL) = 1;              % Bond remains active = 1
       
                
        nBondsBrokenTotal = nBonds - sum(fail);
        nBondsBrokenCurrentIteration = nBondsBrokenTotal - nBondsBrokenTotalPreviousIteration;
        fprintf('Total number of bonds broken = %d, bonds broken in current iteration = %d \n', nBondsBrokenTotal, nBondsBrokenCurrentIteration) % Print total number of bonds broken and number of bonds broken in each iteration
        
        %% Build the stiffness matrix for the updated geometry
        fprintf('Building tangent stiffness matrix... ')
        MAXBODYFORCEtemp = MAXBODYFORCE * loadMultiplier;
        [Ktangent,Fext,unconstrainedDOF,constrainedDOF,~] = buildstiffnessmatrix(displacedCoordinates,BONDLIST,VOLUMECORRECTIONFACTORS,VOLUME,BONDSTIFFNESS,BFMULTIPLIER,CONSTRAINTFLAG,BODYFORCE,MAXBODYFORCEtemp,fail);
        fprintf('process complete \n')

        %% Calculate the out of balance force vector (residual)
        % The scalar valued residual should be defined as the l2-norm of
        % the residual vector. See Section 5.8.3. Implicit time integration
        % for quasi-statics in 'Handbook of Peridynamic Modeling'
        
        Fint = Ktangent * totalDisplacementVector;  % Calculate internal force vector
        g = Fext - Fint;                            % Calculate out of balance force vector
        fprintf('Out of balance force vector g = %.5f \n', sum(g))
        
        %% Check convergence criteria
        % See the following link for guidance on convergence norms.
        % https://dianafea.com/manuals/d944/Analys/node395.html
        % Force Norm / Displacement Norm / Energy Norm / Residual Norm
        
        if abs(sum(g)) <= tolerance
            saveoutput;
            break
        end  
        
        %% Plot results during simulation run-time
        [bondDamage] = calculatedamage(nNodes,BONDLIST,fail,nFAMILYMEMBERS);             
        plotbonddamage(COORDINATES,displacedCoordinates,bondDamage,DX);
        drawnow
    
        %% If the out of balance force vector is greater than a defined tolerance, calculate the displacement correction
        
        fprintf('The out of balance force vector is greater than the defined tolerance \n')
        fprintf('Using Newon-Raphson procedure to converge on correct solution, iteration %d  \n', counterNewtonRaphsonIteration)
        fprintf('Calculate displacement correction... \n')
        deltaDisplacementVector = symmlq(Ktangent,g,1e-6,5000);
        nBondsBrokenTotalPreviousIteration = nBondsBrokenTotal;
        
    end
     
    fprintf('A static solution has been found for load = %.0fN \n', pointLoad)
    
    % -------------------------- END ITERATE ------------------------------

    %% Plot results at the end of every load increment 
    % plotdeformedmember(displacedCoordinates,COORDINATES,MATERIALFLAG);    
    [bondDamage] = calculatedamage(nNodes,BONDLIST,fail,nFAMILYMEMBERS);             
    plotbonddamage(COORDINATES,displacedCoordinates,bondDamage,DX);
    drawnow
    
end
% --------------------------- END INCREMENT -------------------------------

% ----------------------------- END CODE ----------------------------------

end

