function [cn] = calculatedampingcoefficient(nodalForce, massVector, nodalForcePrevious, DT, nodalVelocityPreviousHalf, nodalDisplacement)
% calculatedampingcoefficient - the damping coefficient can be determined
% by using the lowest frequency of the system. The lowest frequency is
% determined by making use of Rayleigh's quotient. See 'An adaptive dynamic
% relaxation method for quasi-static simulations using the peridynamic
% theory - Kilic & Madenci' for more details
%
% Syntax: 
%
% Inputs:
%   input1  - 
% 
% Outputs:
%   dampingCoefficient - 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none
%
% Mark Hobbs 
% mch61@cam.ac.uk
% Department of Engineering
% Cambridge University
% August 2019

% ---------------------------- BEGIN CODE ---------------------------------

nNodes = size(nodalForce, 1);
NOD = size(nodalForce , 2);

cn = 0;
cn1 = 0;
cn2 = 0;

if NOD == 2
    
        for i = 1 : nNodes
        
        if nodalVelocityPreviousHalf(i,1) ~= 0
            
            cn1 = cn1 - nodalDisplacement(i,1)^2 * ((nodalForce(i,1) / massVector(i,1) - nodalForcePrevious(i,1) / massVector(i,1)) / (DT * nodalVelocityPreviousHalf(i,1)));
            
        end
        
        if nodalVelocityPreviousHalf(i,2) ~= 0
            
            cn1 = cn1 - nodalDisplacement(i,2)^2 * ((nodalForce(i,2) / massVector(i,1) - nodalForcePrevious(i,2) / massVector(i,1)) / (DT * nodalVelocityPreviousHalf(i,2)));
            
        end
        
        cn2 = cn2 + nodalDisplacement(i,1)^2;
        cn2 = cn2 + nodalDisplacement(i,2)^2;
        
    end
    
    
elseif NOD == 3

    for i = 1 : nNodes
        
        if nodalVelocityPreviousHalf(i,1) ~= 0
            
            cn1 = cn1 - nodalDisplacement(i,1)^2 * ((nodalForce(i,1) / massVector(i,1) - nodalForcePrevious(i,1) / massVector(i,1)) / (DT * nodalVelocityPreviousHalf(i,1)));
            
        end
        
        if nodalVelocityPreviousHalf(i,2) ~= 0
            
            cn1 = cn1 - nodalDisplacement(i,2)^2 * ((nodalForce(i,2) / massVector(i,1) - nodalForcePrevious(i,2) / massVector(i,1)) / (DT * nodalVelocityPreviousHalf(i,2)));
            
        end
        
        if nodalVelocityPreviousHalf(i,3) ~= 0
            
            cn1 = cn1 - nodalDisplacement(i,3)^2 * ((nodalForce(i,3) / massVector(i,1) - nodalForcePrevious(i,3) / massVector(i,1)) / (DT * nodalVelocityPreviousHalf(i,3)));
            
        end
        
        cn2 = cn2 + nodalDisplacement(i,1)^2;
        cn2 = cn2 + nodalDisplacement(i,2)^2;
        cn2 = cn2 + nodalDisplacement(i,3)^2;
        
    end

end


if cn2 ~= 0 % if cn2 is not equal to 0

    if (cn1 / cn2) > 0

        cn = 2 * sqrt(cn1 / cn2);

    else

        cn = 0;

    end

else

    cn = 0;

end

if cn > 2

    cn = 1.9; % Why such a small value?

end

% ----------------------------- END CODE ----------------------------------

end

