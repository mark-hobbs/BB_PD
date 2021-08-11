function [MATERIALFLAG] = buildlongitudinalreinforcement(undeformedCoordinates,barCentreY,barCentreZ,barRadius,MATERIALFLAG,nNodes)
% buildlongitudinalreinforcement - 
%
% Syntax: 
%
% Inputs:
%   undeformedCoordinates - 
%   barCentre             - Define (y,z) coordinates of the centre of the reinforcing bar
%   barRadius             - Reinforcing bar radius (define in m)
%   MATERIALFLAG
%
% Outputs:
%   MATERIALFLAG
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
% July 2019

% ---------------------------- BEGIN CODE ---------------------------------

%% Main body of function
% Check the distance between the centre line of the reinforcing bar and a
% material point X. If this distance is less than the bar radius, then the
% material point lies inside the curved surface of the reinforcing bar.

% https://stackoverflow.com/questions/47932955/how-to-check-if-a-3d-point-is-inside-a-cylinder

NOD = size(undeformedCoordinates,2);

% -------------------------------- 2D -------------------------------------

if NOD == 2
    
    distance = sqrt((undeformedCoordinates(:,2) - barCentreY).^2);

    for i = 1 : nNodes

        if distance(i,1) <= barRadius

            MATERIALFLAG(i,1) = 1;

        end

    end   

% -------------------------------- 3D -------------------------------------
    
elseif NOD == 3
    
   distance = sqrt((undeformedCoordinates(:,2) - barCentreY).^2 + (undeformedCoordinates(:,3) - barCentreZ).^2);

    for i = 1 : nNodes

        if distance(i,1) <= barRadius

            MATERIALFLAG(i,1) = 1;

        end

    end   
  
end
% ----------------------------- END CODE ----------------------------------  

end
