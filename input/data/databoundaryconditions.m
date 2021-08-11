% -------------------------------------------------------------------------
% Define boundary conditions
% -------------------------------------------------------------------------

%% Define constants
nNodes = nDivX * nDivY * nDivZ;   % Number of nodes

%% Define location of steel reinforcing bars

MATERIALFLAG = zeros(nNodes,1);       % Create flag to identify steel and concrete nodes Concrete = 0 Steel = 1

% % ---------------- Bar 1 --------------------- %
% 
% for i = ((nDivX * 362) + 1) : (nDivX * 365)
%     
%    MATERIALFLAG(i,1) = 1; 
%    
% end
% 
% for i = ((nDivX * 377) + 1) : (nDivX * 380)
%     
%    MATERIALFLAG(i,1) = 1; 
%    
% end
% 
% for i = ((nDivX * 392) + 1) : (nDivX * 395)
%     
%    MATERIALFLAG(i,1) = 1; 
%    
% end
% 
% % ---------------- Bar 2 --------------------- %
% 
% for i = ((nDivX * 370) + 1) : (nDivX * 373)
%     
%    MATERIALFLAG(i,1) = 1; 
%    
% end
% 
% for i = ((nDivX * 385) + 1) : (nDivX * 388)
%     
%    MATERIALFLAG(i,1) = 1; 
%    
% end
% 
% for i = ((nDivX * 400) + 1) : (nDivX * 403)
%     
%    MATERIALFLAG(i,1) = 1; 
%    
% end

%% Application of body force

BODYFORCEFLAG = zeros(nNodes,NOD);
% bodyforceCounter = 0;
% 
% for i = nDivX : nDivX : nNodes
%     
%     BODYFORCEFLAG(i,3) = 1;
%     bodyforceCounter = bodyforceCounter + 1;
%     
% end

%% Apply constraints to member

CONSTRAINTFLAG = zeros(nNodes,NOD);
% 
% for i = 1 : nDivX : (nNodes - nDivX + 1)
%     
%   CONSTRAINTFLAG(i,:) = 0;
%   
% end
% 
% for i = 2 : nDivX : (nNodes - nDivX + 2)
%     
%   CONSTRAINTFLAG(i,:) = 0;
%   
% end
% 
% for i = 3 : nDivX : (nNodes - nDivX + 3)
%     
%   CONSTRAINTFLAG(i,:) = 0;
%   
% end

clear i % Don't save i
