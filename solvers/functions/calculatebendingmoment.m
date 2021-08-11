function [] = calculatebendingmoment(nDIVX,DX,COORDINATES,stresstensor)
% Calculate the bending moment along the length (x-axis) of the member
% TODO: finish this function! Currently just a copy & paste job of
% calculateshear

datageometry
nodesPlaneYZ=zeros(nDIVX,1);
bendingMoment=zeros(nDIVX,1);

for i=1:nDIVX % Loop the member length
    
    % Identify and flag all nodes within cross-sectional plane Y-Z
    nodesPlaneYZ(i,1)=i*DX;
    crossSectionFlag=(COORDINATES(:,1)==nodesPlaneYZ(i,1))==1; 
    coordCrossSection=COORDINATES(:,:);
    stressCrossSection=stresstensor(:,:,:);
    logicCondition1 = crossSectionFlag==0;          % Delete node if it is not located in cross-section (flag==0)
    coordCrossSection(logicCondition1,:)=[];
    stressCrossSection(logicCondition1,:)=[];       % TODO: I believe that this line re-organises the 3x3 stress matrix into a 1x9 row. Check if this is true.
   
    bendingMoment(i,1)=sum(stressCrossSection(:,1).*abs(coordCrossSection(:,3)-0.09665)*DX^2);
    
end

plot(nodesPlaneYZ,bendingMoment);
str1=sprintf('Bending Moment Diagram, maximum bending moment M_{max} = %.0fNm', max(bendingMoment));
title(str1)
xlabel('x axis (m)')
ylabel('Bending Moment M (Nm)')

end

