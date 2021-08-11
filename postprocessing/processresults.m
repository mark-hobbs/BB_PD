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

%% Load required data
load(outputfile)
load(inputdatafilename)

%% Set-up arrays and variables
nBonds = size(BONDLIST,1);
stretch = zeros(nBonds,1);
deformedLength = zeros(nBonds,1);
deformedX = zeros(nBonds,1);
deformedY = zeros(nBonds,1);
deformedZ = zeros(nBonds,1);

nodalDisplacement = deformedCoordinates - undeformedCoordinates;

%% Plot deformed member
plotdeformedmember(undeformedCoordinates, undeformedCoordinates, MATERIALFLAG)

%% Calculate and plot damage for every node
damage = calculatedamage(BONDLIST, fail, nFAMILYMEMBERS);
plotbonddamage(undeformedCoordinates, deformedCoordinates, damage, DX , 5, 0)    % (damage - 1) * -1
% plotnodaldata(undeformedCoordinates, nodalDisplacement, damage, 'Damage', 10, 0)

%% Plot the fracture path
plotfracturepath(undeformedCoordinates, deformedCoordinates, damage, 0, 1, 25)

%% Calculate and plot softening damage for every node
flagBondSoftening = - (flagBondSoftening - 1);  % Switch flag value. This is to ensure compatibility with calculatedamage()
softeningDamage = calculatedamage(BONDLIST, flagBondSoftening, nFAMILYMEMBERS);
% plotbonddamage(undeformedCoordinates, deformedCoordinates, softeningDamage, DX , 10, 100)
plotnodaldata(undeformedCoordinates, nodalDisplacement, softeningDamage, 'Softening Damage', 5, 5)

%% Bond Stretch - plot stretch of every bond 
% TODO: seperate calculation of max stretch etc and plotnodaldata()

[deformedLength,deformedX,deformedY,deformedZ,stretch] = calculatedeformedlength(deformedLength,deformedX,deformedY,deformedZ,stretch,deformedCoordinates,UNDEFORMEDLENGTH,BONDLIST,nBonds);

plotstretch(stretch, fail, BONDLIST, undeformedCoordinates, nodalDisplacement, DX, 0, 20);    

%% Plot fracture process zone

%% Strain - calculate and plot strain tensor at every node
[strainTensor, maxPrincipalStrains, oneone, twotwo, threethree] = calculatestraintensor(undeformedCoordinates,deformedCoordinates,BONDLIST,fail,damage,nNodes);
% plotnodaldata(undeformedCoordinates,nodalDisplacement,strainTensor(:,1,3),'Strain \epsilon (1,3)',20,0)
plotnodaldatacrosssection(undeformedCoordinates,nodalDisplacement,strainTensor(:,1,3),DX,'Strain \epsilon (1,3)',20,0)

% maxPrincipalStrains = filloutliers(maxPrincipalStrains,'clip');
% plotnodaldata(undeformedCoordinates, nodalDisplacement, maxPrincipalStrains, 'Strain \epsilon (1,3)', 10, 0)
oneone = filloutliers(oneone,'clip');
plotnodaldatacrosssection(undeformedCoordinates, nodalDisplacement, -oneone, DX, 'Principal Strain', 20, 0)

%% Stress - calculate and plot stress tensor at every node
[stressTensor,maxPrincipalStress] = calculatestresstensor(strainTensor,MATERIALFLAG,effectiveModulusConcrete,effectiveModulusSteel,Vconcrete,Vsteel,Gconcrete,Gsteel);

[undeformedCoordinatesReduced] = extractmaterial(undeformedCoordinates, MATERIALFLAG, 1);
[nodalDisplacementReduced] = extractmaterial(nodalDisplacement, MATERIALFLAG, 1);
[stressTensorReduced] = extractmaterial(stressTensor, MATERIALFLAG, 1);

stressTensorReduced = filloutliers(stressTensorReduced(:,1),'clip');
plotnodaldata(undeformedCoordinatesReduced, nodalDisplacementReduced, stressTensorReduced(:,1), 'Stress \sigma (1,3)', 20, 0)
% plotnodaldatacrosssection(undeformedCoordinates, nodalDisplacement, stressTensor(:,1,1), DX, 'Stress \sigma (1,3)', 20, 0)
maxPrincipalStress = filloutliers(maxPrincipalStress,'clip');
plotnodaldatacrosssection(undeformedCoordinates, nodalDisplacement, maxPrincipalStress, DX,'Stress', 10, 10)

%% Shear Force - calculate the shear force along the length (x-axis) of the member
[shearForce,averageShearForce] = calculateshearforce(undeformedCoordinates,stressTensor);
figure
plot(unique(undeformedCoordinates(:,1)), -shearForce);
str1 = sprintf('Shear Force Diagram, average shear force V_{average} = %.0fN', averageShearForce);
title(str1)
xlabel('x axis (m)')
ylabel('Shear Force V (N)')

plotstressdistribution(undeformedCoordinates,DX,stressTensor)

% ----------------------------- END CODE ----------------------------------

end