function [penetrator] = buildpenetrator(penetratorID, penetratorCentreX, penetratorCentreZ, penetratorRadius, searchRadius, undeformedCoordinates)

penetrator.ID = penetratorID;
penetrator.centre = [penetratorCentreX penetratorCentreZ];
penetrator.radius = penetratorRadius;
penetrator.searchRadius = searchRadius;

nNodes = size(undeformedCoordinates,1);
counter = 0;
distance = sqrt((undeformedCoordinates(:,1) - penetratorCentreX).^2 + (undeformedCoordinates(:,3) - penetratorCentreZ).^2);

for i = 1 : nNodes

    if distance(i,1) <= searchRadius

        counter = counter + 1;
        
        penetrator.family(counter,1) = i;

    end

end   
    
plotnodes(undeformedCoordinates(penetrator.family,:), 'penetrator family', 100, 30, 30)

end

