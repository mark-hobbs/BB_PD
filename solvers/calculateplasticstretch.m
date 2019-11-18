function [stretchPlastic,yieldingLength,flagBondYield] = calculateplasticstretch(yieldingLength,flagBondYield,stretch,BONDTYPE,deformedLength)
% calculateplasticstretch - calculate and track the plastic stretch history
% of a bond that has exceeded the critical yield stretch value (only for
% steel-steel bonds)

yieldStretchSteel = 0.002;

% Calculate length of bond at yielding
logicalIndex = (flagBondYield == 0 & BONDTYPE == 2 & stretch > yieldStretchSteel);
yieldingLength(logicalIndex,1) = deformedLength(logicalIndex,1);

% create a flag to identify steel - steel bonds (BONDTYPE == 2) that have
% yielded flag == 1 when a bond has yielded (stretch > yieldStretchSteel)
% flag == 0 when a bond remains in the elastic range
flagBondYield(BONDTYPE == 2 & stretch > yieldStretchSteel) = 1; 

% Calculate plastic bond stretch
stretchPlastic = flagBondYield .* ((deformedLength - yieldingLength) ./ yieldingLength); 
stretchPlastic(isnan(stretchPlastic)) = 0;

end

