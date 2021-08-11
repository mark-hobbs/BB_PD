function [appliedForce] = calculateappliedforce(nodalForce,cellVolume)
% calculateappliedforce - determine the applied force on the member

% nodalForce (N/m^3) * cellvolume (m^3)
appliedForce = sum(nodalForce, 2) * cellVolume;
appliedForce = abs(round(sum(appliedForce), 2));


end

