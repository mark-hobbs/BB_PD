function [interpArrayIndependent, interpArrayDependent] = processgraphdata(expMaxIndependent, expArrayIndependent, expArrayDependent, method)
% This function is used to interpolate datasets in such a way that the
% independent variables are identical. This is required when shading areas
% between curves. In the below example CMOD would be the independent
% variable and load the dependent variable. Note: exp is shorthand for
% experimental data. 

% Outputs:
%   interpArrayIndependent  - Data on the independent axis (x-axis)
%   interpArrayDependent    - Data on the dependent axis (y-axis)

% =========================== EXAMPLE =====================================

% [CMOD, load] = processgraphdata(0, maxCMOD, expCMOD, expLoad, method)

% CMOD = linspace(0, maxCMOD, 1000);
% load = interp1(expCMOD, expLoad, CMOD, method); % linear / pchip
% 
% load(isnan(load)) = 0;
% load(load < 0) = 0;

% =========================================================================

interpArrayIndependent = linspace(0, expMaxIndependent, 1000);
interpArrayDependent = interp1(expArrayIndependent, expArrayDependent, interpArrayIndependent, method); % linear / pchip

interpArrayDependent(isnan(interpArrayDependent)) = 0;
interpArrayDependent(interpArrayDependent < 0) = 0;

end