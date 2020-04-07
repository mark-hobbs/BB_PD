% arraypreallocation - pre-allocate all arrays
%
% Syntax: 
%
% Inputs:
%    
% 
% Outputs:
%
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
% November 2019

% ---------------------------- BEGIN CODE ---------------------------------

nBonds = size(BONDLIST,1);                  % Number of bonds
nNodes = size(undeformedCoordinates,1);     % Number of nodes
NOD = size(undeformedCoordinates,2);        % Number of degress of freedom


% -------------------------------------------------------------------------
% Bond Properties (nBonds, 1)
% -------------------------------------------------------------------------

deformedLength = zeros(nBonds,1);
deformedX = zeros(nBonds,1);
deformedY = zeros(nBonds,1);
deformedZ = zeros(nBonds,1);
stretch = zeros(nBonds,1);
bForceX = zeros(nBonds,1);
bForceY = zeros(nBonds,1);
bForceZ = zeros(nBonds,1);
fail = zeros(nBonds,1) + 1; % Bond is intact (fail == 1), bond has failed (fail == 0)
stretchPlastic = zeros(nBonds,1);
yieldingLength = zeros(nBonds,1);
flagBondYield = zeros(nBonds,1);
flagBondSoftening = zeros(nBonds,1);
bondSofteningFactor = zeros(nBonds,1);

% -------------------------------------------------------------------------
% Nodal Properties (nNodes, NOD)
% -------------------------------------------------------------------------

nodalForce = zeros(nNodes,NOD);
nodalDisplacement = zeros(nNodes,NOD);
nodalVelocity = zeros(nNodes,NOD);
nodalAcceleration = zeros(nNodes,NOD);

% nodalForcePrevious = zeros(nNodes,NOD);
% nodalVelocityPreviousHalf = zeros(nNodes,NOD);
% nodalVelocityForwardHalf = zeros(nNodes,NOD);


% ----------------------------- END CODE ----------------------------------