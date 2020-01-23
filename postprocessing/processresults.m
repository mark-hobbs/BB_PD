function processresults(outputfile,inputdatafilename)
% processresults - load output file and process results
% 1. Plot deformed member
% 2. Calculate and plot damage for every node
% 3. Plot the fracture path
% 4. Plot bond stretch
% 5. Plot strain
% 6. Plot stress
%
% Syntax: processresults(outputfile,inputdatafilename)
%
% Mark Hobbs 
% mch61@cam.ac.uk
% Department of Engineering
% Cambridge University
% November 2019

% ---------------------------- BEGIN CODE ---------------------------------

%% Load required data and set-up variables
load(outputfile)
load(inputdatafilename)

nodalDisplacement = deformedCoordinates - undeformedCoordinates;

%% Plot deformed member
plotdeformedmember(deformedCoordinates, undeformedCoordinates, MATERIALFLAG)

%% Calculate and plot damage for every node
damage = calculatedamage(BONDLIST, fail, nFAMILYMEMBERS);
plotbonddamage(undeformedCoordinates, deformedCoordinates, damage, DX , 0, 10)

%% Plot the fracture path
plotfracturepath(undeformedCoordinates, deformedCoordinates, damage, 0, 1, 25)

%% Calculate and plot softening damage for every node
flagBondSoftening = - (flagBondSoftening - 1); % Switch flag value. This is to ensure compatibility with calculatedamage()
softeningDamage = calculatedamage(BONDLIST, flagBondSoftening, nFAMILYMEMBERS);
%plotbonddamage(undeformedCoordinates, deformedCoordinates, softeningDamage, DX , 0, 10)
plotnodaldata(undeformedCoordinates, nodalDisplacement, softeningDamage, 'Softening Damage', 10, 0)

%% Bond Stretch - plot stretch of every bond 
% TODO: seperate calculation of max stretch etc and plotnodaldata()
plotstretch(stretch, BONDLIST, undeformedCoordinates, nodalDisplacement);    

%% Strain - calculate and plot strain tensor at every node
[strainTensor, maxPrincipalStrains] = calculatestraintensor(undeformedCoordinates,deformedCoordinates,BONDLIST,fail,damage,nNodes);
%plotnodaldata(undeformedCoordinates,nodalDisplacement,strainTensor(:,1,3),'Strain \epsilon (1,3)',10,10)
maxPrincipalStrains = filloutliers(maxPrincipalStrains,'clip');
plotnodaldata(undeformedCoordinates,nodalDisplacement,maxPrincipalStrains,'Strain \epsilon (1,3)',10,10)

%% Stress - calculate and plot stress tensor at every node
[stressTensor,maxPrincipalStress] = calculatestresstensor(strainTensor,MATERIALFLAG,effectiveModulusConcrete,effectiveModulusSteel,Vconcrete,Vsteel,Gconcrete,Gsteel);
% plotnodaldata(undeformedCoordinates,nodalDisplacement,stressTensor(:,1,3),'Stress \sigma (1,3)',10,10)
maxPrincipalStress = filloutliers(maxPrincipalStress,'clip');
plotnodaldata(undeformedCoordinates,nodalDisplacement,maxPrincipalStress,'Stress',10,10)

%% Shear Force - calculate the shear force along the length (x-axis) of the member
[shearForce,averageShearForce] = calculateshearforce(undeformedCoordinates,stressTensor);
figure
plot(unique(undeformedCoordinates(:,1)), -shearForce);
str1 = sprintf('Shear Force Diagram, average shear force V_{average} = %.0fN', averageShearForce);
title(str1)
xlabel('x axis (m)')
ylabel('Shear Force V (N)')

% ----------------------------- END CODE ----------------------------------

end