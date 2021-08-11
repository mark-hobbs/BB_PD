function [r2, rsme] = validateresponse(expLoad, expCMOD, numLoad, numCMOD, rangeCMOD)
% validateresponse - This function validates the numerical structural
% response against experimental data. Structural response will be in the
% form of a load-deflection or load-CMOD curve. The relative error between
% experimental and numerical results is reported uing the coefficient of
% determination (R-squared)
%
% Syntax:  [] = validateresponse()
%
% Inputs:
%    expLoad     - experimental load data
%    expCMOD     - experimental CMOD data
%    numLoad     - numerical load data
%    expLoad     - experimental load data
%    rangeCMOD   - range of CMOD data [min max]
%    
%
% Outputs:
%    R2          - coefficient of determination
%    RSME        - root mean squared error
%    
% Other m-files required: rsquare.m
% Subfunctions: none
% MAT-files required: none
%
% See also: none
%
% Mark Hobbs 
% mch61@cam.ac.uk
% Department of Engineering
% Cambridge University
% September 2020

%---------------------------- BEGIN CODE ----------------------------------

% Determine if experimental data is a column vector
if isrow(expLoad) == true
    expLoad = expLoad';
end

if isrow(expCMOD) == true
    expCMOD = expCMOD';
end

% Remove data that is out of the defined range of CMOD data - experimental
logicCondition1 = expCMOD > rangeCMOD(2);
expCMOD(logicCondition1,:) = []; 
expLoad(logicCondition1,:) = [];

% Remove data that is out of the defined range of CMOD data - numerical
logicCondition2 = numCMOD > rangeCMOD(2);
numCMOD(logicCondition2,:) = []; 
numLoad(logicCondition2,:) = [];

% Remove zero values from numerical CMOD data
logicCondition3 = numCMOD == 0;
numCMOD(logicCondition3,:) = []; 
numLoad(logicCondition3,:) = [];

if length(expCMOD) ~= length(numCMOD) % The length of the experimental and numerical data must be the same
    
    % If not, the numerical data must be interpolated so that the length of
    % the experimental and numerical data is equal.
    load_interp = interp1(numCMOD, numLoad, expCMOD, 'linear');
    numLoad = load_interp;
    
end

[r2, rsme] = rsquare(expLoad, numLoad);


%----------------------------- END CODE -----------------------------------

end

