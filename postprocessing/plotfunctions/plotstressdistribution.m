function [] = plotstressdistribution(COORDINATES,DX,stresstensor)
%% Plot stress distribution through the depth of a beam
% Important notation: Stress(X,Z) signifies stress acting on the face
% normal to the X axis, in the direction of the Z axis

% Identify and flag a single column of nodes, parallel with z-axis
xCoord=DX*50;    % column x-coordinate
yCoord=DX*10;     % column y-coordinate

crossSectionFlag=(COORDINATES(:,1)==xCoord & COORDINATES(:,2)==yCoord)==1; 
coordCrossSection=COORDINATES(:,:);
stressCrossSection=stresstensor(:,:,:);
logicCondition1 = crossSectionFlag==0;          % Delete node if it is not located in cross-section (flag==0)
coordCrossSection(logicCondition1,:)=[];
stressCrossSection(logicCondition1,:)=[];       % TODO: I believe that this line re-organises the 3x3 stress matrix into a 1x9 row. Check if this is true.


% Plot normal stress distribution through the depth of the beam
figure;
plot(stressCrossSection(:,1),coordCrossSection(:,3))
str1=sprintf('Normal stress distribution \\sigma (1,1) at coordinates x = %.0fmm , y = %.0fmm', xCoord*1000, yCoord*1000); % convert coordinates from m to mm (*1000)
title(str1)
xlabel('Normal stress \sigma (1,1) N/m^{2}')
ylabel('Z axis - beam depth (m)')

% Plot shear stress distribution through the depth of the beam
figure;
plot(stressCrossSection(:,3),coordCrossSection(:,3))
str2=sprintf('Shear stress distribution \\sigma (1,3) at coordinates x = %.0fmm, y = %.0fmm ', xCoord*1000, yCoord*1000);
title(str2)
xlabel('Shear stress \sigma (1,3) N/m^{2}')
ylabel('Z axis - beam depth (m) ')

% figure;
% tension=stressCrossSection(:,1).*abs(coordCrossSection(:,3)-0.1);
% plot(tension,coordCrossSection(:,3))

end