function [nFAMILYMEMBERS,NODEFAMILYPOINTERS,NODEFAMILY,BONDLIST,UNDEFORMEDLENGTH] = buildhorizons(undeformedCoordinates,horizonRadius)
% Determine the nodes inside the horizon of each material point, build bond lists, and determine undeformed length of every bond

tic

%% Constants
nNodes = size(undeformedCoordinates,1);

%% KD-tree
% Use a KD-tree to search for the family members of every material point
% The returned node families (NF) are in a cell array 

[NF] = rangesearch(undeformedCoordinates, undeformedCoordinates, horizonRadius); % rangesearch is the KDTreeSearcher function for distance search.

%% Create node family data structure
% Unpack the node family cell array (NF) into correct node family data
% structure
counter = 1;
nFAMILYMEMBERS = zeros(nNodes,1);
NODEFAMILYPOINTERS = zeros(nNodes,1);
NODEFAMILY = zeros((sum(cellfun('size',NF,2)) - nNodes),1); % find the total number of entries in cell array NF minus first element of every cell (origin node)

for kNode = 1 : nNodes
    
    currentNodeFamilyTemp = NF{kNode};          % First element indicates the origin node
    currentNodeFamilyTemp(1) = [];              % Remove first element (origin node)
    currentNodeFamily = currentNodeFamilyTemp; 
    
    % TODO Sort nodes in ascending order and see if this speeds up memory access
    % CurrentNodeFamily=sort(CurrentNodeFamilyTemp); 
        
    nFAMILYMEMBERS(kNode,1) = size(currentNodeFamily,2); % Create an array containing the number of family members for every node
    
    % Create a list of pointers to node family members
    if kNode == 1
        
        NODEFAMILYPOINTERS(kNode,1) = 1;
    
    else
        
        NODEFAMILYPOINTERS(kNode,1) = NODEFAMILYPOINTERS(kNode-1) + nFAMILYMEMBERS(kNode-1);
    
    end
      
    for kFamilyMember = 1:nFAMILYMEMBERS(kNode,1)
        
        NODEFAMILY(counter,1) = currentNodeFamily(1,kFamilyMember);
        counter = counter + 1;
        
    end
    
end

%% Create bond list

BONDLIST = zeros(size(NODEFAMILY,1)/2,2); % Initialise bond list
counter1 = 0;

% Iterate over all material points
for kNode = 1 : nNodes
    
    % Iterate over all family members of Node 'k'
    for kFamilyMember = 1 : nFAMILYMEMBERS(kNode)
        
        % Consider bond between Node 'k' and Node 'familyMember' 
        familyMember = NODEFAMILY(NODEFAMILYPOINTERS(kNode) + (kFamilyMember - 1),1);
        
        if familyMember > kNode % if kNode is greater than familyMember, the corresponding bond has already been added to the list. The following link explains other methods to prevent the double checking of indices https://stackoverflow.com/questions/31961009/java-how-to-stop-nested-loops-from-checking-same-indices-twice
           
           counter1 = counter1 + 1;
           BONDLIST(counter1,:) = [kNode familyMember]; 
        
        end
        
        % Create a vector (nNodes x 1) to store the approximate volume of
        % every node horizon
        
        
    end
    
end

nBonds = counter1;

%% Calculate undeformed length of every bond

UNDEFORMEDLENGTH = zeros(nBonds,1);

for kBond = 1 : nBonds
    
    nodei = BONDLIST(kBond,1);
    nodej = BONDLIST(kBond,2);
    UNDEFORMEDLENGTH(kBond) = sum((undeformedCoordinates(nodei,:) - undeformedCoordinates(nodej,:)) .^ 2);
    
end

UNDEFORMEDLENGTH = sqrt(UNDEFORMEDLENGTH);

%% Function Timing

buildhorizonsTiming = toc;
fprintf('Horizons complete in %fs \n', buildhorizonsTiming)

end