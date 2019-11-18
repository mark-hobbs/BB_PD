[constrainedDOF, unconstrainedDOF] = buildconstrainedDOF(CONSTRAINTFLAG);
K = buildstiffnessmatrix(deformedCoordinates,BONDLIST,VOLUMECORRECTIONFACTORS,cellVolume,BONDSTIFFNESS,BFMULTIPLIER,fail,constrainedDOF);
totalDisplacement = deformedCoordinates - undeformedCoordinates;
totalDisplacementVector = reshape(totalDisplacement',[],1);
totalDisplacementVector(constrainedDOF,:) = []; 
reactionForce = K * totalDisplacementVector;
reactionForce = sum(reactionForce);