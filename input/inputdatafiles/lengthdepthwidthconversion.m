% -------------------------------------------------------------------------
% Length (x) x Depth (y) x Width (z) conversion
% -------------------------------------------------------------------------

% Notation from DIANA FEM:
% Column 1 - length (x)
% Column 2 - depth (y)
% Column 3 - width (z)


BODYFORCEFLAG(:,[2,3]) = BODYFORCEFLAG(:,[3,2]);

CONSTRAINTFLAG(:,[2,3]) = CONSTRAINTFLAG(:,[3,2]);

undeformedCoordinates(:,[2,3]) = undeformedCoordinates(:,[3,2]);


temporary_nDivY = nDivY;
temporary_nDivZ = nDivZ;

nDivY = temporary_nDivZ;
nDivZ = temporary_nDivY;