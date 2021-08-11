function [stressTensor,maxPrincipalStress] = calculatestresstensor(strainTensor,MATERIALFLAG,effectiveModulusConcrete,effectiveModulusSteel,Vconcrete,Vsteel,Gconcrete,Gsteel)
% calculatestresstensor - calculate Cauchy true stress tensor

%% Initialise constants

nNodes = size(strainTensor,1);
NOD = size(strainTensor,2);
stressTensor = zeros(nNodes,NOD,NOD);
principalStress = zeros(nNodes,NOD,NOD);

%% Main body of calculatestresstensor function

if NOD == 3
    
    for kNode = 1 : nNodes
        
        if MATERIALFLAG(kNode,1) == 0 % concrete
 
           EM = effectiveModulusConcrete;
           v = Vconcrete;
           G = Gconcrete;

        elseif MATERIALFLAG(kNode,1) == 1 % Steel

           EM = effectiveModulusSteel;
           v = Vsteel;
           G = Gsteel;
                     
        end
        
        % For more info on the factor of 2 used in stressXY,stressXZ and
        % stressYZ, see the following link:
        % http://solidmechanics.org/text/Chapter3_2/Chapter3_2.htm
        
        alpha = EM / ((1 + v) * (1 - 2*v));
        stressXX = alpha * ((1 - v) * strainTensor(kNode,1,1) + v * strainTensor(kNode,2,2) + v * strainTensor(kNode,3,3));
        % stressXX = EM * ((1 - v) * strainTensor(kNode,1,1) + v * strainTensor(kNode,2,2) + v * strainTensor(kNode,3,3));
        stressXY = G * 2 * strainTensor(kNode,1,2);
        stressXZ = G * 2 * strainTensor(kNode,1,3);

        stressYX = stressXY;
        stressYY = EM * (v * strainTensor(kNode,1,1) + (1 - v) * strainTensor(kNode,2,2) + v * strainTensor(kNode,3,3));
        stressYZ = G * 2* strainTensor(kNode,2,3);

        stressZX = stressXZ;
        stressZY = stressYZ;
        stressZZ = EM * (v * strainTensor(kNode,1,1) + v * strainTensor(kNode,2,2) + (1 - v) * strainTensor(kNode,3,3));

        stressTensor(kNode,:,:) = [stressXX stressXY stressXZ; stressYX stressYY stressYZ; stressZX stressZY stressZZ];
        
        principalStress(kNode,:,:) = eig(squeeze(strainTensor(kNode,:,:)), 'matrix');
                
        temp = squeeze(principalStress(kNode,:,:));
        temp = [temp(1,1), temp(2,2), temp(3,3)];
        
        maxPrincipalStress(kNode,1) = min(temp); %min(temp(temp > 0));
                                                      
   end
    
elseif NOD == 2
    
      for kNode = 1:nNodes
          
        if MATERIALFLAG(kNode,1) == 0 % concrete 

           EM = effectiveModulusConcrete;
           v = Vconcrete;
           G = Gconcrete;

        elseif MATERIALFLAG(kNode,1) == 1 % Steel

           EM = effectiveModulusSteel;
           v = Vsteel;
           G = Gsteel;

        end
        
        stressXX = EM * ((1 - v) * strainTensor(kNode,1,1) + v * strainTensor(kNode,2,2));
        stressXY = G * strainTensor(kNode,1,2);

        stressYX = stressXY;
        stressYY = EM * (v * strainTensor(kNode,1,1) + (1 - v) * strainTensor(kNode,2,2));

        stressTensor(kNode,:,:) = [stressXX stressXY; stressYX stressYY];
        
      end
      
end

end

