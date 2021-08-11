function [] = plotbonddata(undeformedCoordinates,nodalDisplacement,BONDLIST,stretch,datalabel)
% plotbonddata - plot bond data on deformed shape. This functions plots a
% 4-D figure. The 4th dimension is color coded to represent the value of a
% variable in a bond
%
% Syntax: plotbonddata(undeformedCoordinates,nodalDisplacement,BONDLIST,bondData,datalabel)
%
% Inputs:
%   undeformedCoordinates - orignal underformed coordinates of all nodes (nNodes x NOD)
%   nodalDisplacement     - displacement vector for every node (nNodes x NOD)
%   BONDLIST              - Array containing nodal connectivity information (nBonds x 2)
%   bondData              - the 4th dimension (bond data could be stretch, bond force, bond type etc)
%   datalabel             - title of output figure
%
% Outputs:
%   figure                - output 4-D figure with bond data plotted on the
%                           deformed member
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

% ----------------------- BEGIN CODE --------------------------------------

nBonds = size(BONDLIST,1); % Number of bonds
sz = 1;                    % Marker size
dsf = 0;                   % Displacement scale factor
deformedCoordinates = undeformedCoordinates + (nodalDisplacement * dsf);
myColor = zeros(nBonds,3);

for i = 1:nBonds
    f = stretch(i,1); % your float

    cm = colormap; % returns the current color map

    colorID = max(1, sum(f > [0:1/length(cm(:,1)):1])); 

    myColor(i,:) = cm(colorID, :); % returns your color
end

figure
for i = 1:nBonds
    plot3([deformedCoordinates(BONDLIST(i,1),1) deformedCoordinates(BONDLIST(i,2),1)], [deformedCoordinates(BONDLIST(i,1),2) deformedCoordinates(BONDLIST(i,2),2)], [deformedCoordinates(BONDLIST(i,1),3) deformedCoordinates(BONDLIST(i,2),3)], 'Color', myColor(i,:));    
    hold on
end
xlabel('x (1)')
ylabel('y (2)')
zlabel('z (3)')
str = sprintf('%s', datalabel);
title(str)
axis equal
% colormap jet 
% colorbar
% ----------------------- END CODE --------------------------------------
for i = 1:size(nYieldedBonds,1)
plot3([undeformedCoordinates(BONDLIST(nYieldedBonds(i,1),1),1) undeformedCoordinates(BONDLIST(nYieldedBonds(i,1),2),1)], [undeformedCoordinates(BONDLIST(nYieldedBonds(i,1),1),2) undeformedCoordinates(BONDLIST(nYieldedBonds(i,1),2),2)], [undeformedCoordinates(BONDLIST(nYieldedBonds(i,1),1),3) undeformedCoordinates(BONDLIST(nYieldedBonds(i,1),2),3)]);
hold on
end
end