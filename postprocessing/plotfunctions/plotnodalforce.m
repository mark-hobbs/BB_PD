function [] = plotnodalforce(COORDINATES,disp,nodalForce)
% Plot nodal force data

netNodalForce = sum(nodalForce,2);
POINT_SIZE=1;
figure;
scatter3(COORDINATES(:,1)+(disp(:,1,1)*10),COORDINATES(:,2)+(disp(:,2,1)*10),COORDINATES(:,3)+(disp(:,3,1)*10),POINT_SIZE,netNodalForce)
title('Nodal force')
xlabel('x (1)')
ylabel('y (2)')
zlabel('z (3)')
axis equal
colormap jet 
colorbar

end