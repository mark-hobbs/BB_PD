function [nodalForce] = calculatenodalforces2D(BONDLIST,nodalForce,bForceX,bForceY,BODYFORCEFLAG,MAXBODYFORCE)

nodalForce(:,:) = 0;        % Nodal force - initialise for every time step
nBonds = size(BONDLIST,1);

% Calculate the nodal force (N/m^3) for every node, iterate over the bond list
for kBond = 1 : nBonds
    
    nodei = BONDLIST(kBond,1); % Node i
    nodej = BONDLIST(kBond,2); % Node j
    
    % X-component
    nodalForce(nodei,1) = nodalForce(nodei,1) + bForceX(kBond); % Bond force is positive on Node i 
    nodalForce(nodej,1) = nodalForce(nodej,1) - bForceX(kBond); % Bond force is negative on Node j
    
    % Y-component
    nodalForce(nodei,2) = nodalForce(nodei,2) + bForceY(kBond);
    nodalForce(nodej,2) = nodalForce(nodej,2) - bForceY(kBond);
          
end

% Add body force (N/m^3)
nodalForce(:,:) = nodalForce(:,:) + (BODYFORCEFLAG(:,:) * MAXBODYFORCE);


end

