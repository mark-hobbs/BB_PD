function [reactionForce] = calculatereactionforceFast(nodalForce, BODYFORCEFLAG, DX)

    reactionForce = nodalForce(:,3) .* DX^3;        % convert nodal force to newtons
    reactionForce(BODYFORCEFLAG(:,3) == 0) = 0;     % determine reaction force at nodes with applied displacements (this line discards the values of nodes with no applied displacement)
    reactionForce = sum(reactionForce);             % sum all values to determine the total reaction force
    
end

