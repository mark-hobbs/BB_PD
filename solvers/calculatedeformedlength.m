function [deformedLength,deformedX,deformedY,deformedZ,stretch] = calculatedeformedlength(deformedCoordinates,UNDEFORMEDLENGTH,deformedX,deformedY,deformedZ,nBonds,BONDLIST)
% calculatedeformedlength - calculate the deformed length and stretch of
% every bond

% [deformedLength,deformedX,deformedY,deformedZ,stretch] = calculatedeformedlength(deformedCoordinates,UNDEFORMEDLENGTH,deformedX,deformedY,deformedZ,nBonds,BONDLIST)

% Calculate the deformed length of every bond using a for loop
for kBond = 1 : nBonds                           
    
   nodei = BONDLIST(kBond,1);
   nodej = BONDLIST(kBond,2);

   deformedX(kBond) = deformedCoordinates(nodej, 1) - deformedCoordinates(nodei, 1); % X-component of deformed bond
   deformedY(kBond) = deformedCoordinates(nodej, 2) - deformedCoordinates(nodei, 2); % Y-component of deformed bond
   deformedZ(kBond) = deformedCoordinates(nodej, 3) - deformedCoordinates(nodei, 3); % Z-component of deformed bond

end

% Calculate length of deformed bond
deformedLength = deformedX.^2 + deformedY.^2 + deformedZ.^2;    % Move outside of for loop - optimises speed
deformedLength = sqrt(deformedLength);                          % sqrt outside of for loop - optimises speed

% Calculate bond stretch
stretch = (deformedLength - UNDEFORMEDLENGTH) ./ UNDEFORMEDLENGTH; % Surely this should be ./undeformedLength???

end

