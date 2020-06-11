function [nodalDisplacement, deformedCoordinates, DISPLACEMENTFLAG] = applydisplacement(penetrator, displacementIncrement, undeformedCoordinates, deformedCoordinates, nodalDisplacement)
% applydisplacement - Calculate the contact force between the member
% under analysis and a rigid impactor. The rigid impactor is not
% deformable. Based on code from rigid_impactor.f90 in Chapter 10 -
% Peridynamic Theory & its Applications by Madenci & Oterkus
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
% See also: calculatecontactforce
%
% Mark Hobbs 
% mch61@cam.ac.uk
% Department of Engineering
% Cambridge University
% May 2019
%
%
%
%       Z (height)
%           ^
%           |       
%           |
%           |   
%           |
%         --|-----------> x (length)
%           |

% ---------------------------- BEGIN CODE ---------------------------------

% pseudo - code
% 1. create penetrator
%   1.1 - define centre (x,~,z)
%   1.2 - define radius
%   1.3 - determine penetrator family
%
% 2. Move penetrator
%
% 3. Calculate new nodal positions
%   3.1 - calculate distance between penetrator centre and nodes in
%   penetrator family
%   3.2 - check if a node lies within the radius of the penetrator 
%   3.3a - YES: calculate new nodal position
%   3.3b - NO: break out of if statement
%
% 4. Update velocity
%
% 5. Calculate the reaction force on the penetrator
%
% 6. Update penetrator acceleration, velocity, and displacement

nNodes = size(undeformedCoordinates , 1);
NOD = size(undeformedCoordinates, 2);
DISPLACEMENTFLAG = zeros(nNodes, NOD); 
family = penetrator.family;
counter = 0;

penetrator.centre(:,2) = penetrator.centre(:,2) + displacementIncrement; % Move penetrator vertically (z-axis)

% Calculate distance between penetrator centre and nodes in penetrator family
distanceX = deformedCoordinates(family,1) - penetrator.centre(:,1);
distanceZ = deformedCoordinates(family,3) - penetrator.centre(:,2);
distance = sqrt((distanceX .* distanceX) + (distanceZ .* distanceZ));

% Check if a node lies within the radius of the penetrator
for i = 1 : size(family,1)
    
    if distance(i,1) < penetrator.radius
        
        counter = counter + 1;
                
        % Calculate new position for nodes that lie within the radius of the
        % penetrator - material points can't move in y-axis
        
        nodei = family(i,1);
        
        % calculate unit vector
        unitX = distanceX(i,1) / distance(i,1);
        unitZ = distanceZ(i,1) / distance(i,1);
        
        % scale unit vector by penetrator radius
        unitXScaled = unitX * penetrator.radius;
        unitZScaled = unitZ * penetrator.radius;
        
        % calculate new position for material points
        deformedCoordinates(nodei,1) = penetrator.centre(:,1) + unitXScaled;
        deformedCoordinates(nodei,3) = penetrator.centre(:,2) + unitZScaled;
        
        % Flag to identify nodes with an applied displacement
        DISPLACEMENTFLAG(nodei,1) = 1; 
        DISPLACEMENTFLAG(nodei,3) = 1;      
        
        nodalDisplacement(nodei,:) = deformedCoordinates(nodei,:) - undeformedCoordinates(nodei,:);
        
    end
    
end
                           

% --------------------------- END CODE ------------------------------------

end

