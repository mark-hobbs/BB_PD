function [] = plotfracturepath(undeformedCoordinates, deformedCoordinates, damage, damageTolerance, dsf, sz)
% plotfracturepath - 
%
% Syntax: [] = plotfracturepath(undeformedCoordinates, deformedCoordinates, damage, damageTolerance, dsf, sz)
%
% Inputs:
%   input1   - 
%
% Outputs:
%   figure                - output 3D figure showing fracture path
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
% August 2019

% ----------------------- BEGIN CODE --------------------------------------

nodalDisplacement = deformedCoordinates - undeformedCoordinates;

coordinatesFP = undeformedCoordinates;
damageFracturePath = damage;
nodalDisplacementFP = nodalDisplacement;

logicCondition1 = (damage <= damageTolerance);    % Discard undamaged nodes
coordinatesFP(logicCondition1,:) = [];            % Undeformed coordinates of the fracture path
nodalDisplacementFP(logicCondition1,:) = [];  
damageFracturePath(logicCondition1,:) = [];       % Damage at nodes on the fracture path

figure
scatter3(coordinatesFP(:,1) + (nodalDisplacementFP(:,1) * dsf), coordinatesFP(:,2) + (nodalDisplacementFP(:,2) * dsf), coordinatesFP(:,3) + (nodalDisplacementFP(:,3) * dsf), sz, damageFracturePath(:,1), 'filled')
axis equal
xlabel('x')   % length
ylabel('y')   % width
zlabel('z')   % depth
view(30,30)   % View in 3D
grid off
colormap jet 
caxis([0 1])
h = colorbar;
ylabel(h, 'Damage')

% ----------------------- BEGIN CODE --------------------------------------


end
