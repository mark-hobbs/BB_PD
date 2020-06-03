% =========================================================================
%                   Fracture Energy Validation
% =========================================================================

% By determining the energy required to break a single bond, the energy per
% unit fracture area for complete seperation of a peridynamic body can be
% determined. The energy required to break a single bond will increase if
% surface correction factors are applied to a peridynamic body. Therefore
% the calculated critical stretch value for a three-dimensional peridynamic
% material will be wrong and the predicted failure load will be higher than
% that observed experimentally. 

%% Clear workspace 
close all
clear all
clc

%% Geometry and Discretisation 

member.NOD = 3;          % Number of degrees of freedom
member.LENGTH = 1;       % x-axis (m) 
member.WIDTH = 1;        % y-axis (m) 
member.DEPTH = 1;        % z-axis (m)

DX = 50/1000;                       % Spacing between material points (mm)
nDivX = round(member.LENGTH/DX);    % Number of divisions in x-direction    
nDivY = round(member.WIDTH/DX);     % Number of divisions in y-direction    
nDivZ = round(member.DEPTH/DX);     % Number of divisions in z-direction   
cellVolume = DX^3;                  % Cell volume
RADIJ = DX/2;                       % Material point radius

memberLength = nDivX * DX;     % Length (m) - x
memberDepth = nDivY * DX;      % Depth (m) - y
memberWidth = nDivZ * DX;      % Width (m) - z

undeformedCoordinates = buildmaterialpointcoordinates(member.NOD, DX, nDivX, nDivY, nDivZ);    % Build regular grid of nodes
nNodes = size(undeformedCoordinates , 1);

fprintf('Length (x) = %.2fm \nDepth (y) = %.2fm \nWidth (z) = %.2fm \n', memberLength, memberDepth, memberWidth)
fprintf('DX = %.4fm \n', DX)
fprintf('nDivX = %.0f \nnDivY = %.0f \nnDivZ = %.0f \n', nDivX, nDivY, nDivZ)

% plotnodes(undeformedCoordinates, 'Undeformed material points: x-y plane ', 10, 0, 0)    % Plot undeformed nodes and check for errors
% plotnodes(undeformedCoordinates, 'Undeformed material points', 10, 30, 30)

MATERIALFLAG = zeros(nNodes, 1);

%% Build node families 

% Improve spatial localtiy of data (space filling curve ordering of particles)

horizon = pi * DX; % Be consistent - this is also known as the horizonRadius

% Build node families, bond lists, and determine undeformed length of every bond
[nFAMILYMEMBERS,NODEFAMILYPOINTERS,NODEFAMILY,BONDLIST,UNDEFORMEDLENGTH] = buildhorizons(undeformedCoordinates,horizon);

%% Volume correction factors 

% Calculate volume correction factors to improve the accuracy of spatial
% integration
VOLUMECORRECTIONFACTORS = calculatevolumecorrectionfactors(UNDEFORMEDLENGTH,horizon,RADIJ);

%% Material properies 

datamaterialproperties      % Load material properties

%% Peridynamic parameters 

neighbourhoodVolume = (4/3) * pi * horizon^3;   % Neighbourhood volume for node contained within material bulk

bond.concrete.stiffness = (12 * material.concrete.E) / (pi * horizon^4);    % Bond stiffness 3D
bond.steel.stiffness = (12 * material.steel.E) / (pi * horizon^4);          % Bond stiffness 3D

bond.concrete.s0 = 8.75009856494892E-05;  % constitutive law
bond.concrete.sc = 2.18752464123723E-03;
bond.steel.sc = 1;

%% Bond stiffness correction (surface effects)

% Calculate bond type and bond stiffness (plus stiffness correction)
[BONDSTIFFNESS,BONDTYPE,BFMULTIPLIER] = buildbonddata(BONDLIST,nFAMILYMEMBERS,MATERIALFLAG,bond.concrete.stiffness,bond.steel.stiffness,cellVolume,neighbourhoodVolume,VOLUMECORRECTIONFACTORS);

%% Determine numerically the energy per unit fracture area for complete seperation of a peridyamic body

% kNode = 1313; % 1313 2722
% %family(1,1) = kNode;
% pt0 = [undeformedCoordinates(kNode,1), undeformedCoordinates(kNode,2), undeformedCoordinates(kNode,3)];
% counter = 0;
% figure 
% 
% % Iterate over all family members of Node 'k'
% for kFamilyMember = 1 : nFAMILYMEMBERS(kNode)
% 
%     counter = counter + 1;
%     
%     % Consider bond between Node 'k' and Node 'familyMember' 
%     family(counter,1) = NODEFAMILY(NODEFAMILYPOINTERS(kNode) + (kFamilyMember - 1),1);
%     
%     % Plot bond
%     pt2 = [undeformedCoordinates(family(counter,1),1), undeformedCoordinates(family(counter,1),2), undeformedCoordinates(family(counter,1),3)];
%     pts = [pt0; pt2]; % vertial concatenation 
%     plot3(pts(:,1), pts(:,2), pts(:,3), 'LineWidth', 1.5)
%     hold on
%     
% end
% 
% scatter3(undeformedCoordinates(family,1), undeformedCoordinates(family,2), undeformedCoordinates(family,3), 50, 'b', 'filled')
% xlabel('x (1)')
% ylabel('y (2)')
% zlabel('z (3)')
% axis equal
% 
% % x = max(undeformedCoordinates(:,1));
% % y = max(undeformedCoordinates(:,2));
% % z = max(undeformedCoordinates(:,3));
% % plotcube([x y z],[0 0 0],0,1.5)
% 
% % Determine collinear particles. See 'Bond-based peridynamic modelling of
% % singular and nonsingular crack tip files'
% 
% % Calculate distance between penetrator centre and nodes in penetrator family
% distanceX = undeformedCoordinates(family,1) - undeformedCoordinates(kNode,1);
% distanceY = undeformedCoordinates(family,2) - undeformedCoordinates(kNode,2);
% distanceZ = undeformedCoordinates(family,3) - undeformedCoordinates(kNode,3);
% 
% counter = 0;
% for i = 1 : size(family,1)
%     if distanceX(i,1) == 0 && distanceY(i,1) == 0 && undeformedCoordinates(family(i,1),3) < undeformedCoordinates(kNode,3)
%         counter = counter + 1;  
%         familyCollinear(counter,1) = family(i,1); 
%     end
% end
% 
% 
% FAMILYORIGIN = kNode;
% FAMILY = family;
% 
% count = size(FAMILYORIGIN,1);
% COUNT = size(FAMILY,1);
% figure
% for i = 1 : size(familyCollinear,1)
%     
%     kNode = familyCollinear(i,1);
%     family = [];
%     family(1,1) = kNode;
%     counter = 1;
%     count = count + 1;
%     FAMILYORIGIN(count,1) = kNode;
%     
%     for kFamilyMember = 1 : nFAMILYMEMBERS(kNode)
%        
%         counter = counter + 1;
%         COUNT = COUNT + 1;
% 
%         % Consider bond between Node 'k' and Node 'familyMember' 
%         family(counter,1) = NODEFAMILY(NODEFAMILYPOINTERS(kNode) + (kFamilyMember - 1),1);
%         FAMILY(COUNT,1) = family(counter,1);
% 
%         % Plot bond
%         pt1 = [undeformedCoordinates(kNode,1), undeformedCoordinates(kNode,2), undeformedCoordinates(kNode,3)];
%         pt2 = [undeformedCoordinates(family(counter,1),1), undeformedCoordinates(family(counter,1),2), undeformedCoordinates(family(counter,1),3)];
%         pts = [pt1; pt2]; % vertial concatenation
%         plot3(pts(:,1), pts(:,2), pts(:,3), 'LineWidth', 1.5)
%         scatter3(undeformedCoordinates(family,1), undeformedCoordinates(family,2), undeformedCoordinates(family,3), 20, 'b', 'filled')
%         hold on     
%                 
%     end
%            
% end
% 
% axis equal
% 
% 
% figure
% counter = 0;
% 
% for i = 1 : size(FAMILYORIGIN,1)
%     
%     for kFamilyMember = 1 : nFAMILYMEMBERS(kNode)
%         
%         counter = counter + 1;
%        
%         nodei = FAMILYORIGIN(i,1);
%         nodej = FAMILY(counter,1);
% 
%         % Plot bond
%         pt1 = [undeformedCoordinates(nodei,1), undeformedCoordinates(nodei,2), undeformedCoordinates(nodei,3)];
%         pt2 = [undeformedCoordinates(nodej,1), undeformedCoordinates(nodej,2), undeformedCoordinates(nodej,3)];
%         pts = [pt1; pt2]; % vertial concatenation
%         
%         if pt2(1,3) > pt0(1,3)
%             plot3(pts(:,1), pts(:,2), pts(:,3), 'LineWidth', 1.5)
%         end
%         
%         hold on     
%            
%     end
%            
% end
% 
% x = max(undeformedCoordinates(:,1));
% y = max(undeformedCoordinates(:,2));
% z = max(undeformedCoordinates(:,3));
% plotcube([x y z],[0 0 0],0,1.5)
% 
% %scatter3(undeformedCoordinates(family,1), undeformedCoordinates(family,2), undeformedCoordinates(family,3), 20, 'b', 'filled')
% axis equal

%% Determine numerically the energy per unit fracture area for complete seperation of a unit cube

nBonds = size(BONDLIST,1);
counter = 0;
figure

totalEnergy = 0;
s = 1.1974E-04;

A = [0 0 0.525];
B = [0 1 0.525];
C = [0.025 1 0.525];
D = [0.025 0 0.525];

% A = [0.0251 0 0.525];
% B = [0.0251 1 0.525];
% C = [0.075 1 0.525];
% D = [0.075 0 0.525];

% A = [0.485 0 0.525];
% B = [0.485 1 0.525];
% C = [0.515 1 0.525];
% D = [0.515 0 0.525];

% A = [0 0 0.525];
% B = [0 1 0.525];
% C = [1 1 0.525];
% D = [1 0 0.525];

% A = [0.5 0.5 1.025];
% B = [0.5 1.5 1.025];
% C = [1.5 1.5 1.025];
% D = [1.5 0.5 1.025];


% Calculate the nodal force (N/m^3) for every node, iterate over the bond list
for kBond = 1 : nBonds
    
    nodei = BONDLIST(kBond,1); % Node i
    nodej = BONDLIST(kBond,2); % Node j
    
    [checkcheck] = determineintersection(A, B, C, D, undeformedCoordinates(nodei,:), undeformedCoordinates(nodej,:));
    
%     if undeformedCoordinates(nodei,3) < 0.525 && undeformedCoordinates(nodej,3) > 0.525
%         
%         counter = counter + 1;
%         newBL(counter,:) = [nodei, nodej];
%         newUL(counter,:) = UNDEFORMEDLENGTH(kBond,1);
%         newBS(counter,:) = BONDSTIFFNESS(kBond,1);
%    
%     end
%     
%     if undeformedCoordinates(nodej,3) < 0.525 && undeformedCoordinates(nodei,3) > 0.525
%         
%         counter = counter + 1;
%         newBL(counter,:) = [nodei, nodej];
%         newUL(counter,:) = UNDEFORMEDLENGTH(kBond,1);
%         newBS(counter,:) = BONDSTIFFNESS(kBond,1);
%         
%     end
    
    if checkcheck == 1
        
        counter = counter + 1;
        newBL(counter,:) = [nodei, nodej];
        newUL(counter,:) = UNDEFORMEDLENGTH(kBond,1);
        newBS(counter,:) = BONDSTIFFNESS(kBond,1);
        
    end
        

        
end




for kBond = 1 : size(newBL,1)

    nodei = newBL(kBond,1); % Node i
    nodej = newBL(kBond,2); % Node j
    
    bondEnergy = ((newBS(kBond) * s^2 * newUL(kBond,1))/2) * cellVolume^2; % newBS(kBond)   bond.concrete.stiffness
    totalEnergy = totalEnergy + bondEnergy;

    % Plot bond
    pt1 = [undeformedCoordinates(nodei,1), undeformedCoordinates(nodei,2), undeformedCoordinates(nodei,3)];
    pt2 = [undeformedCoordinates(nodej,1), undeformedCoordinates(nodej,2), undeformedCoordinates(nodej,3)];
    pts = [pt1; pt2]; % vertial concatenation
    plot3(pts(:,1), pts(:,2), pts(:,3), 'LineWidth', 0.75)
    
    hold on     
    

end

fprintf('Fracture energy: %.2f \n', totalEnergy/(0.025*1))


plot3( [A(1) B(1) C(1) D(1) A(1)], [A(2) B(2) C(2) D(2) A(2)], [A(3) B(3) C(3) D(3) A(3)], 'Color', 'k', 'LineWidth', 4 )
scatter3(undeformedCoordinates(newBL(:,1),1), undeformedCoordinates(newBL(:,1),2), undeformedCoordinates(newBL(:,1),3), 20, 'b', 'filled')
scatter3(undeformedCoordinates(newBL(:,2),1), undeformedCoordinates(newBL(:,2),2), undeformedCoordinates(newBL(:,2),3), 20, 'b', 'filled')

x = max(undeformedCoordinates(:,1));
y = max(undeformedCoordinates(:,2));
z = max(undeformedCoordinates(:,3));
plotcube([x y z],[0 0 0],0,1.5)
set(gca,'XTick',[], 'YTick', [], 'ZTick', [])
set(gca,'XTickLabel',[], 'YTickLabel', [], 'ZTickLabel', [])
% set(gca,'visible','off')
xlabel('x', 'interpreter', 'latex')
ylabel('y', 'interpreter', 'latex')
zlabel('z', 'interpreter', 'latex')
axis equal



%% Required functions
function plotcube(varargin)
% PLOTCUBE - Display a 3D-cube in the current axes
%
%   PLOTCUBE(EDGES,ORIGIN,ALPHA,COLOR,LINEWIDTH) displays a 3D-cube in the current axes
%   with the following properties:
%   * EDGES     : 3-elements vector that defines the length of cube edges
%   * ORIGIN    : 3-elements vector that defines the start point of the cube
%   * ALPHA     : scalar that defines the transparency of the cube faces (from 0 to 1)
%   * COLOR     : 3-elements vector that defines the faces color of the cube
%   * LINEWIDTH : scalar that defines the thickess of polygon edges
%
% Example:
%   >> plotcube([5 5 5],[ 2  2  2],.8,[1 0 0],1);
%   >> plotcube([5 5 5],[10 10 10],.8,[0 1 0],2);
%   >> plotcube([5 5 5],[20 20 20],.8,[0 0 1]),3;

% Default input arguments
inArgs = { ...
  [10 56 100] , ... % Default edge sizes (x,y and z)
  [10 10  10] , ... % Default coordinates of the origin point of the cube
  .7          , ... % Default alpha value for the cube's faces
  [1 0 0]     , ... % Default Color for the cube
  1             ... % Default line width
  };

% Replace default input arguments by input values
inArgs(1:nargin) = varargin;

% Create all variables
[edges,origin,alpha,clr,linewidth] = deal(inArgs{:});

% ---------------------------------
%   XYZ{1}  |  XYZ{2}  |  XYZ{3} |
% ---------------------------------
XYZ = { ...
  [0 0 0 0]  [0 0 1 1]  [0 1 1 0] ; ... % 1
  [1 1 1 1]  [0 0 1 1]  [0 1 1 0] ; ... % 2
  [0 1 1 0]  [0 0 0 0]  [0 0 1 1] ; ... % 3
  [0 1 1 0]  [1 1 1 1]  [0 0 1 1] ; ... % 4
  [0 1 1 0]  [0 0 1 1]  [0 0 0 0] ; ... % 5
  [0 1 1 0]  [0 0 1 1]  [1 1 1 1]   ... % 6
  };

XYZ = mat2cell(...
  cellfun( @(x,y,z) x*y+z , ...
    XYZ , ...
    repmat(mat2cell(edges,1,[1 1 1]),6,1) , ...     % Cube has 6 faces
    repmat(mat2cell(origin,1,[1 1 1]),6,1) , ...
    'UniformOutput',false), ...
    6,[1 1 1]);

cellfun(@patch,XYZ{1},XYZ{2},XYZ{3},... % Apply function to each cell in cell array
  repmat({clr},6,1),...                 % Return an array containing 6x1 copies of {clr}
  repmat({'FaceAlpha'},6,1),... 
  repmat({alpha},6,1),...
  repmat({'LineWidth'},6,1),... 
  repmat({linewidth},6,1)... 
  );

view(3);

end
    