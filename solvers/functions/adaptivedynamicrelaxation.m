function [fail,displacement,stretch,nodeDisplacement,timeStepTracker] = adaptivedynamicrelaxation(BONDLIST,undeformedCoordinates,UNDEFORMEDLENGTH,BONDTYPE,failure,BFMULTIPLIER,BONDSTIFFNESS,VOLUMECORRECTIONFACTORS,BODYFORCE,DENSITY,CONSTRAINTFLAG)
% Adaptive Dynamic Relaxation (ADR) scheme
% The ADR scheme is used to determine the most effective damping
% coefficient at each time step

%% Constants
datamaterialproperties
datageometry
dataPDparameters
datasimulationparameters

nBonds = size(BONDLIST,1);
nNodes = size(undeformedCoordinates,1);

%% Initialise 
fail = zeros(nBonds,1) + 1;                      
stretch = zeros(nBonds,1);
deformedLength = zeros(nBonds,1);
nodalForce = zeros(nNodes,NOD);                   % Total peridynamic force acting on a material point (Node)
nodalForcePrevious = zeros(nNodes,NOD);
displacement = zeros(nNodes,NOD);                 % Displacement of a material point
displacementForward = zeros(nNodes,NOD);
velocity = zeros(nNodes,NOD);                     % Velocity of a material point
velocityPreviousHalf = zeros(nNodes,NOD);
velocityForward = zeros(nNodes,NOD);
velocityForwardHalf = zeros(nNodes,NOD);
a = zeros(nNodes,NOD);                            % Acceleration of a material point
nodeDisplacement = zeros(NT,1);                   % History of displacement at selected node                          
deformedX = zeros(nBonds,1);
deformedY = zeros(nBonds,1);
deformedZ = zeros(nBonds,1);

%% Mass Matrix Construction
% Determine diagonal coefficients of the fictitious density matrix
% (sometimes referred to as modified density) - massMatrix(nNodes,NOD)

massMatrixConstant = 0.25 * DT * DT * ((4 / 3) * pi * DELTA^3) * C_CONCRETE / DX;
massVector = zeros(nNodes,NOD) + massMatrixConstant;
rowIndex = [1 : nNodes]';
columnIndex = [1 : nNodes]';

%% Main body of explicit time integration


for tt = timeStepTracker : NT
    
    timeStepTracker = tt + 1;
    
    %% Calculate bond and nodal forces 

    % Calculate deformed length of every bond
    [deformedLength,deformedX,deformedY,deformedZ,stretch] = calculatedeformedlength(undeformedCoordinates,displacement,nBonds,BONDLIST,deformedX,deformedY,deformedZ,UNDEFORMEDLENGTH,deformedLength);

    % Calculate bond force for every bond
    [nodalForce,fail] = calculatebondforces(nBonds,fail,BONDTYPE,stretch,CRITICAL_STRETCH_CONCRETE,CRITICAL_STRETCH_STEEL,failure,BFMULTIPLIER,BONDSTIFFNESS,VOLUME,VOLUMECORRECTIONFACTORS,deformedX,deformedY,deformedZ,deformedLength,BONDLIST,nodalForce,BODYFORCE,MAXBODYFORCE);
   
    cn = 0;
    cn1 = 0;
    cn2 = 0;

    for i = 1 : nNodes
        
        if velocityPreviousHalf(i,1) ~= 0
            
            cn1 = cn1 - displacement(i,1) * displacement(i,1) * (nodalForce(i,1) / massVector(i,1) - nodalForcePrevious(i,1) / massVector(i,1)) / (DT * velocityPreviousHalf(i,1));
            
        end
        
        if velocityPreviousHalf(i,2) ~= 0
            
            cn1 = cn1 - displacement(i,2) * displacement(i,2) * (nodalForce(i,2) / massVector(i,2) - nodalForcePrevious(i,2) / massVector(i,2)) / (DT * velocityPreviousHalf(i,2));
            
        end
        
        if velocityPreviousHalf(i,3) ~= 0
            
            cn1 = cn1 - displacement(i,3) * displacement(i,3) * (nodalForce(i,3) / massVector(i,3) - nodalForcePrevious(i,3) / massVector(i,3)) / (DT * velocityPreviousHalf(i,3));
            
        end
        
        cn2 = cn2 + displacement(i,1) * displacement(i,1);
        cn2 = cn2 + displacement(i,2) * displacement(i,2);
        cn2 = cn2 + displacement(i,3) * displacement(i,3);
        
    end

    if cn2 ~= 0
        
        if (cn1 / cn2) > 0
            
            cn = 2 * sqrt(cn1 / cn2);
            
        else
            
            cn = 0;
            
        end
        
    else
        
        cn=0;
    
    end

    if cn > 2
        
        cn = 1.9; % Why such a small value?
    
    end


    if tt == 1
        
        for i = 1 : nNodes

           velocityForwardHalf(i,1) = (DT * nodalForce(i,1)) / (2 * massVector(i,1));
           velocityForwardHalf(i,2) = (DT * nodalForce(i,2)) / (2 * massVector(i,2));
           velocityForwardHalf(i,3) = (DT * nodalForce(i,3)) / (2 * massVector(i,3));

        end
        
    else
        
        for i = 1 : nNodes

           velocityForwardHalf(i,1) = ((2 - cn * DT) * velocityPreviousHalf(i,1) + (2 * DT * nodalForce(i,1)) / massVector(i,1)) / (2 + cn * DT);
           velocityForwardHalf(i,2) = ((2 - cn * DT) * velocityPreviousHalf(i,2) + (2 * DT * nodalForce(i,2)) / massVector(i,2)) / (2 + cn * DT);
           velocityForwardHalf(i,3) = ((2 - cn * DT) * velocityPreviousHalf(i,3) + (2 * DT * nodalForce(i,3)) / massVector(i,3)) / (2 + cn * DT);

           displacement(i,1) = displacement(i,1) + velocityForwardHalf(i,1) * DT;
           displacement(i,2) = displacement(i,2) + velocityForwardHalf(i,2) * DT;
           displacement(i,3) = displacement(i,3) + velocityForwardHalf(i,3) * DT;

        end
        
    end

    velocityPreviousHalf = velocityForwardHalf;
    nodalForcePrevious = nodalForce;      
    
%     %% Diagonal local stiffness matrix 
%     % TODO: What should the correct dimensions be for the stiffness matrix?
%     stiffnessMatrix(:,1) = -((nodalForce(:,1)./massMatrix(:,1))-(nodalForcePrevious(:,1)./massMatrix(:,1)))./(DT*velocityPreviousHalf(:,1));
%     stiffnessMatrix(:,2) = -((nodalForce(:,2)./massMatrix(:,2))-(nodalForcePrevious(:,2)./massMatrix(:,2)))./(DT*velocityPreviousHalf(:,2));
%     stiffnessMatrix(:,3) = -((nodalForce(:,3)./massMatrix(:,3))-(nodalForcePrevious(:,3)./massMatrix(:,3)))./(DT*velocityPreviousHalf(:,3));
%   
%   
%     
%     stiffnessMatrixSparse1=sparse(rowIndex,columnIndex,stiffnessMatrix(:,1));
%     stiffnessMatrixSparse2=sparse(rowIndex,columnIndex,stiffnessMatrix(:,1));
%     stiffnessMatrixSparse3=sparse(rowIndex,columnIndex,stiffnessMatrix(:,1));
%     
%     stiffnessMatrixSparse1(isnan(stiffnessMatrixSparse1)) = 0; % Divison by 0 leads to 'Not-a-Number'. If stiffnessMatrix = 'NaN', set to 0 
%     stiffnessMatrixSparse2(isnan(stiffnessMatrixSparse2)) = 0;
%     stiffnessMatrixSparse3(isnan(stiffnessMatrixSparse3)) = 0;
%     
%     stiffnessMatrixSparse1(isinf(stiffnessMatrixSparse1)) = 0;
%     stiffnessMatrixSparse2(isinf(stiffnessMatrixSparse2)) = 0;
%     stiffnessMatrixSparse3(isinf(stiffnessMatrixSparse3)) = 0;
% 
%     %% Damping Ratio
%     % Calculate the damping ratio c at iteration n. For more info, see 'An
%     % adaptive dynamic relaxation method for quasi-static simulations using
%     % the peridynamic theory'
%     dampingCoefficient1 = 2*sqrt((displacement(:,1)' * stiffnessMatrixSparse1 * displacement(:,1))/(displacement(:,1)' * displacement(:,1)));
%     dampingCoefficient2 = 2*sqrt((displacement(:,2)' * stiffnessMatrixSparse2 * displacement(:,2))/(displacement(:,2)' * displacement(:,2)));
%     dampingCoefficient3 = 2*sqrt((displacement(:,3)' * stiffnessMatrixSparse3 * displacement(:,3))/(displacement(:,3)' * displacement(:,3)));
%     
%     
%     
%     dampingCoefficient1(dampingCoefficient1<=0)=0;
%     dampingCoefficient1(isnan(dampingCoefficient1)) = 0;
%     dampingCoefficient1(isinf(dampingCoefficient1)) = 0;
%     
%     dampingCoefficient2(dampingCoefficient2<=0)=0;
%     dampingCoefficient2(isnan(dampingCoefficient2)) = 0;
%     dampingCoefficient2(isinf(dampingCoefficient2)) = 0;
%     
%     dampingCoefficient3(dampingCoefficient3<=0)=0;
%     dampingCoefficient3(isnan(dampingCoefficient3)) = 0;
%     dampingCoefficient3(isinf(dampingCoefficient3)) = 0;
%     
%     dampingCoefficient=[dampingCoefficient1 dampingCoefficient2 dampingCoefficient3];
%     dampingCoefficient=max(dampingCoefficient);
%     
%     %fprintf('Damping coefficient = %e \n', dampingCoefficient)
%  
%     
%     %% Determine velocities and displacements using central difference explicit integration
% 
%     if tt==1 % First time step
%         velocity = zeros(nNODES,NOD);
%         velocityForwardHalf = (DT*nodalForce)./(2*massMatrix);
%     else     
%         velocityForwardHalfNumerator = ((2-dampingCoefficient*DT).*velocityPreviousHalf) + ((2*DT.*nodalForce)./massMatrix);
%         velocityForwardHalfDenominator = (2+dampingCoefficient*DT);
%         velocityForwardHalf = velocityForwardHalfNumerator./velocityForwardHalfDenominator;
%         velocityForwardHalf(isnan(velocityForwardHalf)) = 0;
%         velocityForwardHalf(isinf(velocityForwardHalf)) = 0;
%     end
% 
%     displacementForward = displacement + (DT * velocityForwardHalf);
%     displacement(:,:) = displacementForward(:,:);   % Update  
%     nodalForcePrevious = nodalForce;                % Update
%     velocityPreviousHalf = velocityForwardHalf;     % Update
    
    percProgress = (tt / NT) * 100; fprintf('Completed %.3f%% of time integration \n', percProgress)  % Calculate and output the percentage of progress of time integration
    nodeDisplacement(tt,1) = displacement(1500,3);  

end

end

