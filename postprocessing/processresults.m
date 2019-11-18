% -------------------------------------------------------------------------
% Process Results
% -------------------------------------------------------------------------

%% Load required data
load(inputdatafilename)

nodalDisplacement = deformedCoordinates - undeformedCoordinates;

%% Plot deformed member
plotdeformedmember(deformedCoordinates, undeformedCoordinates, MATERIALFLAG)

%% Calculate and plot damage for every node
damage = calculatedamage(BONDLIST, fail, nFAMILYMEMBERS);
plotbonddamage(undeformedCoordinates, deformedCoordinates, damage, DX)

%% Plot the fracture path
plotfracturepath(undeformedCoordinates, deformedCoordinates, damage, 0, 1, 25)

%% Bond Stretch - plot stretch of every bond 
% TODO: seperate calculation of max stretch etc and plotnodaldata()
disp = deformedCoordinates - undeformedCoordinates;
plotstretch(nNodes, stretch, BONDLIST, undeformedCoordinates, disp);    

%% Strain - calculate and plot strain tensor at every node
strainTensor = calculatestraintensor(undeformedCoordinates,deformedCoordinates,BONDLIST,fail,damage);
plotnodaldata(undeformedCoordinates,nodalDisplacement,strainTensor(:,1,1),'Strain \epsilon (1,3)')

%% Stress - calculate and plot stress tensor at every node
stressTensor = calculatestresstensor(strainTensor,MATERIALFLAG,effectiveModulusConcrete,effectiveModulusSteel,Vconcrete,Vsteel,Gconcrete,Gsteel);
plotnodaldata(undeformedCoordinates,nodalDisplacement,stressTensor(:,1,1),'Stress \sigma (1,3)')

%% Shear Force - calculate the shear force along the length (x-axis) of the member
[shearForce,averageShearForce] = calculateshearforce(undeformedCoordinates,stressTensor);
figure
plot(unique(undeformedCoordinates(:,1)), -shearForce);
str1 = sprintf('Shear Force Diagram, average shear force V_{average} = %.0fN', averageShearForce);
title(str1)
xlabel('x axis (m)')
ylabel('Shear Force V (N)')
