function [penetrator] = buildpenetrator(penetratorID, penetratorCentreX, penetratorCentreZ, penetratorRadius, searchRadius, undeformedCoordinates)
% example:
% [penetrator] = buildpenetrator(1, 0.82, 31*DX, 3*DX, 5.1*DX, undeformedCoordinates)

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
    
plotnodes(undeformedCoordinates(penetrator.family,:), 'penetrator family', 10, 0, 0)


circle(penetratorCentreX, penetratorCentreZ, penetratorRadius);


end

function circle(x,z,r)
hold on
th = 0 : pi/50 : 2*pi;
xunit = r * cos(th) + x;
yunit = zeros(1,size(th,2));
zunit = r * sin(th) + z;
h = plot3(xunit, yunit, zunit);
hold off
end


