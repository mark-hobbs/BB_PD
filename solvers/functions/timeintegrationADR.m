function [nodalDisplacement, nodalVelocityForwardHalf] = timeintegrationADR(iTimeStep, DT, nodalVelocityForwardHalf, nodalForce, massVector, cn, nodalVelocityPreviousHalf, nodalDisplacement, CONSTRAINTFLAG)
% timeintegrationADR - 
%
% Syntax: 
%
% Inputs:
%   input1  - 
% 
% Outputs:
%   output1 - 
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
NOD = size(nodalForce, 2);

if NOD == 2
    
    for kNode = 1 : nNodes
        
        
        if iTimeStep == 1
            
            nodalVelocityForwardHalf(kNode,1) = 0.5 * DT * massVector(kNode,1)^-1 * nodalForce(kNode,1);
            nodalVelocityForwardHalf(kNode,2) = 0.5 * DT * massVector(kNode,1)^-1 * nodalForce(kNode,2);
            
        else
            
            nodalVelocityForwardHalf(kNode,1) = (((2 - cn * DT) * nodalVelocityPreviousHalf(kNode,1)) + (2 * DT * massVector(kNode,1)^-1 * nodalForce(kNode,1))) / (2 + cn * DT);
            nodalVelocityForwardHalf(kNode,2) = (((2 - cn * DT) * nodalVelocityPreviousHalf(kNode,2)) + (2 * DT * massVector(kNode,1)^-1 * nodalForce(kNode,2))) / (2 + cn * DT);
            
        end
        
        nodalDisplacement(kNode,1) = nodalDisplacement(kNode,1) + (DT * nodalVelocityForwardHalf(kNode,1));
        nodalDisplacement(kNode,2) = nodalDisplacement(kNode,2) + (DT * nodalVelocityForwardHalf(kNode,2));
        
    end
    
elseif NOD == 3

    for kNode = 1 : nNodes
        
        
        if iTimeStep == 1
            
            nodalVelocityForwardHalf(kNode,1) = 0.5 * DT * massVector(kNode,1)^-1 * nodalForce(kNode,1);
            nodalVelocityForwardHalf(kNode,2) = 0.5 * DT * massVector(kNode,1)^-1 * nodalForce(kNode,2);
            nodalVelocityForwardHalf(kNode,3) = 0.5 * DT * massVector(kNode,1)^-1 * nodalForce(kNode,3);
            
        else
            
            nodalVelocityForwardHalf(kNode,1) = (((2 - cn * DT) * nodalVelocityPreviousHalf(kNode,1)) + (2 * DT * massVector(kNode,1)^-1 * nodalForce(kNode,1))) / (2 + cn * DT);
            nodalVelocityForwardHalf(kNode,2) = (((2 - cn * DT) * nodalVelocityPreviousHalf(kNode,2)) + (2 * DT * massVector(kNode,1)^-1 * nodalForce(kNode,2))) / (2 + cn * DT);
            nodalVelocityForwardHalf(kNode,3) = (((2 - cn * DT) * nodalVelocityPreviousHalf(kNode,3)) + (2 * DT * massVector(kNode,1)^-1 * nodalForce(kNode,3))) / (2 + cn * DT);
            
        end
        
        nodalDisplacement(kNode,1) = nodalDisplacement(kNode,1) + (DT * nodalVelocityForwardHalf(kNode,1));
        nodalDisplacement(kNode,2) = nodalDisplacement(kNode,2) + (DT * nodalVelocityForwardHalf(kNode,2));
        nodalDisplacement(kNode,3) = nodalDisplacement(kNode,3) + (DT * nodalVelocityForwardHalf(kNode,3));
        
    end

end


nodalDisplacement(CONSTRAINTFLAG == 1) = 0;
nodalVelocityForwardHalf(CONSTRAINTFLAG == 1) = 0;

% ----------------------------- END CODE ----------------------------------

end

