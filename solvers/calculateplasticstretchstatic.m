function [] = calculateplasticstretchstatic()


stretch = ((deformedBondLength - undeformedBondLength) / undeformedBondLength);

if stretch > yieldStretchSteel && flagBondYield == 0
    
    yieldingLength = deformedBondLength; % Save the length of bond at yielding
    logicFlag = 1;    
    plasticStretch = ((deformedBondLength - yieldingLength) / yieldingLength);
    
end


if stretch > yieldStretchSteel && flagBondYield == 1
    
    plasticStretch = ((deformedBondLength - yieldingLength) / yieldingLength);
    
end

omega = plasticStretch/stretch;
omega(isnan(omega)) = 0;

end

