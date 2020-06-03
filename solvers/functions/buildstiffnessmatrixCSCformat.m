function [globalRowIndex, globalColumnIndex, globalNonZeroValues, massVector] = buildstiffnessmatrixCSCformat(nodalCoordinates,BONDLIST,VOLUMECORRECTIONFACTORS,VOLUME,BONDSTIFFNESS,BFMULTIPLIER,fail)
% buildstiffnessmatrixCSCformat - This function builds the stiffness matrix
% for the peridynamic member using the compressed sparse column (CSC)
% format. The function returns three one-dimensional arrays that
% efficiently represent a sparse stiffness matrix. A row and column index
% is stored for every non-zero value. For more information, see Section 2.1
% CSC storage scheme at https://www.math.uci.edu/~chenlong/226/Ch3FEMCode.pdf
%
% Syntax: [globalRowIndex, globalColumnIndex, globalNonZeroValues] = buildstiffnessmatrixCSCformat(nodalCoordinates,BONDLIST,VOLUMECORRECTIONFACTORS,VOLUME,BONDSTIFFNESS,BFMULTIPLIER,fail)
%
% Inputs:
%   nodalCoordinates            - undeformed or deformed nodalCoordinates of all nodes (nNodes x NOD)
%   BONDLIST
%   VOLUMECORRECTIONFACTORS
%   VOLUME
%   BONDSTIFFNESS
%   BFMULTIPLIER
%   fail
%
%
% Outputs:
%   globalRowIndex
%   globalColumnIndex
%   globalNonZeroValues
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: buildstiffnessmatrix.m
%
% Mark Hobbs 
% mch61@cam.ac.uk
% Department of Engineering
% Cambridge University

% ----------------------- BEGIN CODE --------------------------------------

%% Initialise arrays and constants
nBonds = size(BONDLIST,1);
nNodes = size(nodalCoordinates,1);
NOD = size(nodalCoordinates,2);
massVector = zeros(nNodes,1);
globalRowIndex = zeros(nBonds * (NOD + NOD) ^ 2, 1);    
globalColumnIndex = zeros(nBonds * (NOD + NOD) ^ 2, 1);
globalNonZeroValues = zeros(nBonds * (NOD + NOD) ^ 2, 1);
counter = 1;  % Initialise counter outside of for loop

%% Iterate over the bond list

if NOD == 2
    
    for kBond = 1 : nBonds
        
        if fail(kBond,1) == 1 % Ignore bonds that have failed
            
            nodei = BONDLIST(kBond,1); % Node i
            nodej = BONDLIST(kBond,2); % Node j
            
            %% Compute the local stiffness matrix for the bond connecting Node i to Node j
            
            % Direction cosines to transform bonds between global and local coordinates
            cX = (nodalCoordinates(nodej,1) - nodalCoordinates(nodei,1)); % X-component of deformed bond
            cY = (nodalCoordinates(nodej,2) - nodalCoordinates(nodei,2)); % Y-component of deformed bond
            bondLength = sqrt(cX ^ 2 + cY ^ 2);                           % Length of bond
            
            % *****************************************************************
            % Should bond length be set at the original undeformed length or
            % should it be updated after every load increment and iteration?
            % *****************************************************************
            
            % What does this represent?
            % I think the 'handbook of peridynamic modelling' explains how to
            % derive this
            
            rig = BFMULTIPLIER(kBond) * (BONDSTIFFNESS(kBond) / bondLength ^ 3) * VOLUMECORRECTIONFACTORS(kBond) * VOLUME ^ 2; %* (1 - omega)
            
            % Element stiffness matrix in global coordinates
            % T = [cx^2 cx*cy cx*cz; cx*cy cy^2 cy*cz; cx*cz cy*cz cz^2];
            % Klocal = rig * [T(3x3) -T(3x3); -T(3x3) T(3x3)]
            Klocal = rig * [cX^2 cX*cY -cX^2 -cX*cY;...
                            cX*cY cY^2 -cX*cY -cY^2;...
                            -cX^2 -cX*cY cX^2 cX*cY;...
                            -cX*cY -cY^2 cX*cY cY^2];
            
            % Find all non-zero values in the local stiffness matrix
            % (probably not possible to speed up with logical indexing)
            [localRowIndex,localColumnIndex,localNonZeroValues] = find(Klocal);
            
            massVector(nodei,1) = massVector(nodei,1) + norm(Klocal);
            massVector(nodej,1) = massVector(nodej,1) + norm(Klocal);
            
            %% Assemble the stiffness matrix using the Compressed Sparse Column (CSC) storage format
            bondGlobalDOF = [2 * nodei - 1; 2 * nodei; 2 * nodej - 1; 2 * nodej];       % Bond global degrees of freedom indexing
            nNonZeroValues = size(localNonZeroValues,1);                                % Number of non-zero values in the local stiffness matrix
            index = counter : (counter + nNonZeroValues - 1);                           % Index pointers for assembling arrays
            globalRowIndex(index, 1) = bondGlobalDOF(localRowIndex);                    % Vector containing global row-indices of non-zero entries
            globalColumnIndex(index, 1) = bondGlobalDOF(localColumnIndex);              % Vector containing global column-indices of non-zero entries
            globalNonZeroValues(index, 1) = localNonZeroValues;                         % Vector containing the value of all non-zero entries
            counter = counter + nNonZeroValues;                                         % Counter for assembling arrays
            
        end
        
    end
    
elseif NOD == 3
    
    for kBond = 1 : nBonds
        
        if fail(kBond,1) == 1 % Ignore bonds that have failed
            
            nodei = BONDLIST(kBond,1); % Node i
            nodej = BONDLIST(kBond,2); % Node j
            
            %% Compute the local stiffness matrix for the bond connecting Node i to Node j
            
            % Direction cosines to transform bonds between global and local coordinates
            cX = (nodalCoordinates(nodej,1) - nodalCoordinates(nodei,1)); % X-component of deformed bond
            cY = (nodalCoordinates(nodej,2) - nodalCoordinates(nodei,2)); % Y-component of deformed bond
            cZ = (nodalCoordinates(nodej,3) - nodalCoordinates(nodei,3)); % Z-component of deformed bond
            bondLength = sqrt(cX ^ 2 + cY ^ 2 + cZ ^ 2);                  % Length of bond
            
            % *****************************************************************
            % Should bond length be set at the original undeformed length or
            % should it be updated after every load increment and iteration?
            % *****************************************************************
            
            % What does this represent?
            % I think the 'handbook of peridynamic modelling' explains how to
            % derive this
            
            rig = BFMULTIPLIER(kBond) * (BONDSTIFFNESS(kBond) / bondLength ^ 3) * VOLUMECORRECTIONFACTORS(kBond) * VOLUME ^ 2; %* (1 - omega)
            
            % Element stiffness matrix in global coordinates
            % T = [cx^2 cx*cy cx*cz; cx*cy cy^2 cy*cz; cx*cz cy*cz cz^2];
            % Klocal = rig * [T(3x3) -T(3x3); -T(3x3) T(3x3)]
            Klocal = rig * [cX^2 cX*cY cX*cZ -cX^2 -cX*cY -cX*cZ;...
                            cX*cY cY^2 cY*cZ -cX*cY -cY^2 -cY*cZ;...
                            cX*cZ cY*cZ cZ^2 -cX*cZ -cY*cZ -cZ^2;...
                            -cX^2 -cX*cY -cX*cZ cX^2 cX*cY cX*cZ;...
                            -cX*cY -cY^2 -cY*cZ cX*cY cY^2 cY*cZ;...
                            -cX*cZ -cY*cZ -cZ^2 cX*cZ cY*cZ cZ^2];
            
            % Find all non-zero values in the local stiffness matrix
            % (probably not possible to speed up with logical indexing)
            [localRowIndex,localColumnIndex,localNonZeroValues] = find(Klocal);
            
            massVector(nodei,1) = massVector(nodei,1) + norm(Klocal);
            massVector(nodej,1) = massVector(nodej,1) + norm(Klocal);
                        
            %% Assemble the stiffness matrix using the Compressed Sparse Column (CSC) storage format
            bondGlobalDOF = [3 * nodei - 2; 3 * nodei - 1; 3 * nodei; 3 * nodej - 2; 3 * nodej - 1; 3 * nodej]; % Bond global degrees of freedom indexing
            nNonZeroValues = size(localNonZeroValues,1);                                    % Number of non-zero values in the local stiffness matrix
            index = counter : (counter + nNonZeroValues - 1);                               % Index pointers for assembling arrays
            globalRowIndex(index, 1) = bondGlobalDOF(localRowIndex);                        % Vector containing global row-indices of non-zero entries
            globalColumnIndex(index, 1) = bondGlobalDOF(localColumnIndex);                  % Vector containing global column-indices of non-zero entries
            globalNonZeroValues(index, 1) = localNonZeroValues;                             % Vector containing the value of all non-zero entries
            counter = counter + nNonZeroValues;                                             % Counter for assembling arrays
            
        end
     
    end
    
end

% Remove all zero entries 
globalRowIndex(globalRowIndex == 0) = [];
globalColumnIndex(globalColumnIndex == 0) = [];
globalNonZeroValues(globalNonZeroValues == 0) = [];
     
% ------------------------- END CODE --------------------------------------

end

