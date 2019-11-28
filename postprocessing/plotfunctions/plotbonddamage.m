function[] = plotbonddamage(undeformedCoordinates, deformedCoordinates, damage, DX, dsf, sz)

nodalDisplacement = deformedCoordinates - undeformedCoordinates;

%% 3D view - Bond damage
% figure
% scatter3(undeformedCoordinates(:,1) + (nodalDisplacement(:,1) * dsf), undeformedCoordinates(:,2) + (nodalDisplacement(:,2) * dsf), undeformedCoordinates(:,3) + (nodalDisplacement(:,3) * dsf), sz, damage(:,1), 'filled')
% axis equal
% xlabel('x')   % length
% ylabel('y')   % width
% zlabel('z')   % depth
% %view([0,-90,0])    % View in 2D
% view(30,30)        % View in 3D
% grid off
% colormap jet 
% caxis([0 1])
% h = colorbar;
% ylabel(h, 'Damage')

%% 2D cross-section view - plot cross section of damage data

crossSectionFlag = (undeformedCoordinates(:,2) == (DX * 4)) == 1;   % Identify and flag nodes located in cross-section (X-Y Plane)

coordCrossSection = undeformedCoordinates(:,:);
dispCrossSection = nodalDisplacement(:,:);
damageCrossSection = damage(:,:);
logicCondition1 = crossSectionFlag == 0;                        % Delete node if it is not located in cross-section (flag == 0)
coordCrossSection(logicCondition1,:) = [];
dispCrossSection(logicCondition1,:) = [];
damageCrossSection(logicCondition1,:) = [];

% figure
scatter(coordCrossSection(:,1) + (dispCrossSection(:,1,1) * dsf), coordCrossSection(:,3) + (dispCrossSection(:,3,1) * dsf), sz, damageCrossSection(:,1), 'filled')
axis equal
xlabel('x') % length
ylabel('y') % depth
colormap jet 
colorbar
caxis([0 1])
h = colorbar;
ylabel(h, 'Damage')

end