function plotdeformedmember(deformedCoordinates,undeformedCoordinates,MATERIALFLAG)
% Plot displacement of beam under analysis

% Seperate scatter data into sub sets - The first set represents concrete nodes
% and the second set represents steel nodes
dispConcrete = deformedCoordinates(:,:);
COORDINATESCONCRETE = undeformedCoordinates(:,:);
LogicCondition1 = MATERIALFLAG(:,1) == 1; % If node is steel, delete from concrete sub set
dispConcrete(LogicCondition1,:) = [];
COORDINATESCONCRETE(LogicCondition1,:) = [];

dispSteel = deformedCoordinates(:,:);
COORDINATESSTEEL = undeformedCoordinates(:,:);
LogicCondition2 = MATERIALFLAG(:,1) == 0; % If node is concrete, delete from steel sub set
dispSteel(LogicCondition2,:) = [];
COORDINATESSTEEL(LogicCondition2,:) = [];



% Displacement scale factor
DSF = 1;

%% Plot concrete nodes
figure
sz1 = 5;
conc = scatter3((COORDINATESCONCRETE(:,1)+(dispConcrete(:,1)*DSF)),(COORDINATESCONCRETE(:,2)+(dispConcrete(:,2)*DSF)),(COORDINATESCONCRETE(:,3)+(dispConcrete(:,3)*DSF)),sz1,'b','filled');
conc.MarkerFaceAlpha = 0.2;
hold on

%% Plot steel nodes
scatter3((COORDINATESSTEEL(:,1)+(dispSteel(:,1)*DSF)),(COORDINATESSTEEL(:,2)+(dispSteel(:,2)*DSF)),(COORDINATESSTEEL(:,3)+(dispSteel(:,3)*DSF)),sz1,'r','filled')
axis equal
xlabel('x')
ylabel('y')
zlabel('z')
view(30,30)
grid off
%title(['Time step:' ,num2str(i),],'Color','k')
hold off

%% Plot cross-section of beam
sz2 = 100;
figure;
scatter(COORDINATESCONCRETE(:,2),COORDINATESCONCRETE(:,3),sz2,'b','filled');
hold on
scatter(COORDINATESSTEEL(:,2),COORDINATESSTEEL(:,3),sz2,'g','filled')
hold off
axis equal
        
end 