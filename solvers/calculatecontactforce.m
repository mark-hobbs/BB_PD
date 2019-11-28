function [] = calculatecontactforce()
% calculatecontactforce - Calculate the contact force between the member
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
% See also: none
%
% Mark Hobbs 
% mch61@cam.ac.uk
% Department of Engineering
% Cambridge University
% May 2019

% ---------------------------- BEGIN CODE ---------------------------------

% pseudo - code
% 1. create penetrator
%   1.1 - define centre (x,y,z)
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

% Code copied from 2D problem

penetratorfx = 0; % penetrator contact force in x-direction 
penetratorfy = 0; % penetrator contact force in y-direction
penetratorfz = 0; % penetrator contact force in z-direction
penetratormx = 0; % what is this?
penetratormy = 0;
penetratormz = 0;


penetratorccx = penetratoricx + penetratorux; % what is this?
penetratorccy = penetratoricy + penetratoruy;
penetratorccz = 0;

for kNode = 1 : nNodes % loop over all nodes

    newpositionx = undeformedCoordinates(kNode,1) + disp(kNode,1); % new position x
    newpositiony = undeformedCoordinates(kNode,2) + disp(kNode,2); % new position y
    newpositionz = 0;                                              % new position z
    
    dpenx = newpositionx - penetratorccx;
    dpeny = newpositiony - penetratorccy;
    dpenz = 0;
    dpend = sqrt(dpenx * dpenx + dpeny * dpeny + dpenz * dpenz);
    
    % if a deformable material point is located within the rigid impactor,
    % the material point is relocated to a new point outside the rigid
    % impactor. New locations are assigned in order to achieve the closest
    % distance to the surface of the rigid impactor. 
    
    if dpend < penrad %(dpend.lt.penrad) % dpend < penetrator radius

        dpux = dpenx / dpend;
        dpuy = dpeny / dpend;
        dpuz = dpenz / dpend;
        
        dprx = dpux * penrad;
        dpry = dpuy * penrad;
        dprz = dpuz * penrad;     
        
        dpcx = penetratorccx + dprx; 
        dpcy = penetratorccy + dpry; 
        dpcz = 0;
        
        olddispx = disp(kNode,1);
        olddispy = disp(kNode,2);
        olddispz = 0;
        
        oldvelx = vel(kNode,1);
        oldvely = vel(kNode,2);
        oldvelz = 0;
        
        % Modified displacement vector
        disp(kNode,1) = dpcx - undeformedCoordinates(kNode,1);
        disp(kNode,2) = dpcy - undeformedCoordinates(kNode,2);
        disp(kNode,3) = 0;
        
        % Velocity of a material point in its new location
        vel(kNode,1) = (disp(kNode,1) - olddisp(kNode,1)) / dt;
        vel(kNode,2) = (disp(kNode,2) - olddisp(kNode,2)) / dt;
        vel(kNode,3) = 0;
        
        % Reaction force from  a material point in the deformable body to
        % the rigid impactor (Eq 10.2)
        dpenfx = -1.0d0 * dens * (vel(kNode,1) - oldvelx) / dt * vol;
        dpenfy = -1.0d0 * dens * (vel(kNode,2) - oldvely) / dt * vol;
        dpenfz = 0;
        
        dpenmx = dpry * dpenfz - dprz * dpenfy;
        dpenmy = dprz * dpenfx - dprx * dpenfz;
        dpenmz = dprx * dpenfy - dpry * dpenfx;
        
        % Summation of the contributions of all material points inside the
        % impactor results in the total reaction force on the impactor (Eq
        % 10.3)
        penetratorfx = penetratorfx + dpenfx;
        penetratorfy = penetratorfy + dpenfy;
        penetratorfz = 0;
        
        penetratormx = 0;
        penetratormy = 0;
        penetratormz = penetratormz + dpenmz;

    end

end
    
penax = penetratorfx / penetratorMass; % penetrator acceleration in x-direction
penay = penetratorfy / penetratorMass; % penetrator acceleration in y-direction
penaz = 0;                             % penetrator acceleration in z-direction

penvx = penvx + penax * dt;            % penetrator velocity in x-direction
penvy = penvy + penay * dt;            % penetrator velocity in y-direction
penvz = 0;                             % penetrator velocity in z-direction

penux = penux + penvx * dt;            % penetrator displacement in x-direction
penuy = penuy + penvy * dt;            % penetrator displacement in y-direction
penuz = 0;                             % penetrator displacement in z-direction
    
% --------------------------- END CODE ------------------------------------

end

