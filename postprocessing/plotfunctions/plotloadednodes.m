function plotloadednodes(UNDEFORMEDCOORDINATES,BODYFORCEFLAG)

% Plot all material points and highlight nodes with an applied body force

%% Seperate material points into sub sets
% Sub Sets:
% Applied and no applied body force in x direction 
% Applied and no applied body force in y direction 
% Applied and no applied body force in z direction

% If BODYFORCEFLAG = 1, body force is applied, if BODYFORCEFLAG = 0, no body force is applied 

flagAppliedBodyForceX = find(BODYFORCEFLAG(:,1)==1);
flagAppliedBodyForceY = find(BODYFORCEFLAG(:,2)==1);
flagAppliedBodyForceZ = find(BODYFORCEFLAG(:,3)==1);

coordinatesAppliedBodyForceX=UNDEFORMEDCOORDINATES(flagAppliedBodyForceX,:);
coordinatesAppliedBodyForceY=UNDEFORMEDCOORDINATES(flagAppliedBodyForceY,:);
coordinatesAppliedBodyForceZ=UNDEFORMEDCOORDINATES(flagAppliedBodyForceZ,:);

flagNoBodyForceX = find(BODYFORCEFLAG(:,1)==0);
flagNoBodyForceY = find(BODYFORCEFLAG(:,2)==0);
flagNoBodyForceZ = find(BODYFORCEFLAG(:,3)==0);

coordinatesNoBodyForceX=UNDEFORMEDCOORDINATES(flagNoBodyForceX,:);
coordinatesNoBodyForceY=UNDEFORMEDCOORDINATES(flagNoBodyForceY,:);
coordinatesNoBodyForceZ=UNDEFORMEDCOORDINATES(flagNoBodyForceZ,:);

%% Plot figure highlighting nodes with an applied body force in X direction
figure;
sz1=5;
scatter3(coordinatesAppliedBodyForceX(:,1),coordinatesAppliedBodyForceX(:,2),coordinatesAppliedBodyForceX(:,3),sz1,'r','filled');
hold on
figX=scatter3(coordinatesNoBodyForceX(:,1),coordinatesNoBodyForceX(:,2),coordinatesNoBodyForceX(:,3),sz1,'b','filled');
figX.MarkerFaceAlpha=0.2;
axis equal
xlabel('x')
ylabel('y')
zlabel('z')
view(30,30)
grid off
title('Applied body force in X direction')

%% Plot figure highlighting nodes with an applied body force in Y direction
figure;
sz1=5;
scatter3(coordinatesAppliedBodyForceY(:,1),coordinatesAppliedBodyForceY(:,2),coordinatesAppliedBodyForceY(:,3),sz1,'r','filled');
hold on
figY=scatter3(coordinatesNoBodyForceY(:,1),coordinatesNoBodyForceY(:,2),coordinatesNoBodyForceY(:,3),sz1,'b','filled');
figY.MarkerFaceAlpha=0.2;
axis equal
xlabel('x')
ylabel('y')
zlabel('z')
view(30,30)
grid off
title('Applied body force in Y direction')

%% Plot figure highlighting nodes with an applied body force in Z direction
figure;
sz1=5;
scatter3(coordinatesAppliedBodyForceZ(:,1),coordinatesAppliedBodyForceZ(:,2),coordinatesAppliedBodyForceZ(:,3),sz1,'r','filled');
hold on
figZ=scatter3(coordinatesNoBodyForceZ(:,1),coordinatesNoBodyForceZ(:,2),coordinatesNoBodyForceZ(:,3),sz1,'b','filled');
figZ.MarkerFaceAlpha=0.2;
axis equal
xlabel('x')
ylabel('y')
zlabel('z')
view(30,30)
grid off
title('Applied body force in Z direction')

end 