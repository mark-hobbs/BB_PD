function [strainTensor, maxPrincipalStrains] = calculatestraintensor(COORDINATES,disp,BONDLIST,fail,damage,nNodes)
% calculatestraintensor - returns the strain tensor at every node of a
% given set using state based theory with correspondency strategy.
%
% [strainTensor] = calculatestraintensor(COORDINATES,disp,nFAMILYMEMBERS,NODEFAMILY,NODEFAMILYPOINTERS,BONDLIST,fail)
%
% -------------------------------------------------------------------------
%
% INPUT:
%   undeformedCoordinates - matrix with the intial coordinates of the
%   particles
%   deformedCoordinates - matrix with the deformed coordinates of the
%   particles
%
% OUTPUT:
%   strainTensor - strain tensor for every particle
%
% -------------------------------------------------------------------------

%   [Input] 
%   The first index of the input arrays corresponds to a particle number.
%   matX: matrix with the initial coordinates of the particles
%   matY: matrix with the deformed coordinates of the particles
%   matFamilies: matrix with the node ID of the particles within 
%   the material horizon of each point
%   vecNFamily: number of particles in each family
%   horizon_delta: material horizon (this is only necessary if the
%   influence function is not constant)
%   
%   [Output]
%   The first index of the output array corresponds to a particle number.
%   vecmatEps: 3D array, where vecmatEps(k,:,:) is the strain tensor at
%   the point k.
%
%   Original Author:
%   H. David Miranda
%   University of Cambridge
%   May 2018
%   
%   Mark Hobbs (mch61@cam.ac.uk)
%   University of Cambridge
%   May 2019
%
%   References:
%   "Peridynamic states and constitutive modeling"
%   SA Silling, M Epton, O Weckner, J Xu, E Askari
%   Journal of Elasticity 88 (2), 151-184

% TODO: Include failure of bonds
    
matX = COORDINATES;         % matX contains the initial coordinates of a particle
matY = disp;  % matY contains the deformed coordinates of a particle

nNODES = size(matX,1);      % number of particles
NOD = size(matX,2);         % number of dimensions
nBonds = size(BONDLIST,1);  % number of bonds
stretch = zeros(nBonds,NOD);
  
strainTensor = zeros(nNODES, NOD, NOD);
XX = zeros(nNODES, NOD, NOD);
YX = zeros(nNODES, NOD, NOD);
F2 = zeros(nNODES, NOD, NOD);
I = eye(NOD); % identity matrix

principalStrains = zeros(nNodes,NOD,NOD);
   
%% Node lists
% tic
% for nodei = 1 : nNODES % loop all particles
%         
%     % loop all the points within the family of node i
%     XX = zeros(NOD); % tensor product X * X
%     YX = zeros(NOD); % tensor product Y * Y
% 
%     for j = 1 : nFAMILYMEMBERS(nodei)
%         
%         nodej = NODEFAMILY(NODEFAMILYPOINTERS(nodei)+(j-1),1);
%         X = matX(nodej,:) - matX(nodei,:);
%         Y = matY(nodej,:) - matY(nodei,:);
%         
%         % Compute the influence function omega(X), here I'll simply assume:
%         omega = 1;  %kn = 2; omega = (1-norm(X)/ delta)^kn; % example of a quadratic function 
% 
%         % compute XX and XY by assemblage
%         for row=1:NOD
%             for column=1:NOD
%                 % XX is the shape tensor K
%                 XX(row,column) = XX(row,column) + (X(row) * X(column) * omega);
%                 YX(row,column) = YX(row,column) + (Y(row) * X(column) * omega);
%             end
%         end
% 
%     end
% 
%     if det(XX) > 1e-20 % this is to avoid singularities
%         F = YX*XX^-1; % calculate deformation gradient
%         
%         % convert deformation gradient into small strains - Operator ' complex conjugate transpose
%         % See this webpage http://www.continuummechanics.org/smallstrain.html
%         strainTensor(nodei,:,:) = 0.5 * (F + F') - I;     
%     end
%         
% end
% toc    
 
%% Bond lists 
 
% Loop bond list

for kBond = 1 : nBonds
    
        nodei = BONDLIST(kBond,1); % Node i
        nodej = BONDLIST(kBond,2); % Node j

        X = matX(nodei,:) - matX(nodej,:);  % matX contains the initial coordinates of a particle 
        Y = matY(nodei,:) - matY(nodej,:);  % matY contains the deformed coordinates of a particle
        
        % Compute the influence function omega(X)
        %kn = 2; omega = (1-norm(X)/ delta)^kn; % example of a quadratic function 
        omega = fail(kBond); % Exclude damaged bonds from the calculation of the deformation gradient 

        for row = 1 : NOD

            for column = 1 : NOD

                % XX - Shape Tensor (see Definition 3.4 Eq 17)   
                XX(nodei,row,column) = XX(nodei,row,column) + (X(row) * X(column) * omega);  
                XX(nodej,row,column) = XX(nodej,row,column) + (X(row) * X(column) * omega); 

                % YX - 
                YX(nodei,row,column) = YX(nodei,row,column) + (Y(row) * X(column) * omega); 
                YX(nodej,row,column) = YX(nodej,row,column) + (Y(row) * X(column) * omega); 

            end

        end
    
end

% Loop nodes - runs faster in parfor loop

for kNode = 1 : nNODES
    
    YXkNode = squeeze(YX(kNode,:,:)); % Remove dimensions of length 1
    XXkNode = squeeze(XX(kNode,:,:)); % Remove dimensions of length 1
    
     if damage(kNode) < 0.1 % det(XXkNode) > 1e-20 this is to avoid singularities 
                
        F = YXkNode * XXkNode^-1 + I; % calculate deformation gradient
        
        % convert deformation gradient into small strains - Operator ' complex conjugate transpose
        % See this webpage http://www.continuummechanics.org/smallstrain.html
        strainTensor(kNode,:,:) = 0.5 * (F + F') - I;             % Small deformations
        % strainTensor(kNode,:,:) = 0.5 * (I - inv(F') * inv(F));  % Large deformations (need to check the correct formula)  
        
        principalStrains(kNode,:,:) = eig(squeeze(strainTensor(kNode,:,:)), 'matrix');
        
        temp = squeeze(principalStrains(kNode,:,:));
        
        maxPrincipalStrains(kNode,1) = min(temp(temp>0));
        
        %maxPrincipalStrains(kNode,1) = max(max((eig(squeeze(strainTensor(kNode,:,:)), 'matrix'))));

     else
    
         F = I;
         strainTensor(kNode,:,:) = 0.5 * (F + F') - I; % Small deformations
         
     end
     
end


end

