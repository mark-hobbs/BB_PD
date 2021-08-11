function[] = plotbonddamage(undeformedCoordinates, deformedCoordinates, damage, DX, sz, dsf)

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


[coordCrossSection] = extractcrosssection(undeformedCoordinates, undeformedCoordinates, DX*8);
[dispCrossSection] = extractcrosssection(undeformedCoordinates, nodalDisplacement, DX*8);
[damageCrossSection] = extractcrosssection(undeformedCoordinates, damage, DX*8);

% figure
scatter(coordCrossSection(:,1) + (dispCrossSection(:,1,1) * dsf), coordCrossSection(:,3) + (dispCrossSection(:,3,1) * dsf), sz, damageCrossSection(:,1), 'filled')
axis equal
xlabel('x') % length
ylabel('y') % depth
% xlim([0 4.7])
% ylim([-0.05 0.35])
colormap jet 
colorbar
caxis([0 1])
h = colorbar;
ylabel(h, 'Damage')
% set(gca,'XColor', 'none','YColor','none')

% rectangle('Position',[0 0 (max(coordCrossSection(:,1)) + DX) (max(coordCrossSection(:,3)) + DX)], 'LineWidth', 1.5)

end