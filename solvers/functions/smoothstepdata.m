function [alpha] = smoothstepdata(currentTimeStep,startTimeStep,finalTimeStep,startValue,finalValue)
% smoothstepdata - define a smooth amplitude between two points. The
% standard use case is to define the displacement increment at every time
% step. When the displacement time history is defined using a smooth-step
% amplitude curve, the velocity and acceleration will be zero at every data
% point specified, although the average velocity and acceleration may well
% be nonzero. Further details of this function can be found in the
% following link;
% https://www.sharcnet.ca/Software/Abaqus610/Documentation/docs/v6.10/books/usb/default.htm?startat=pt07ch30s01aus104.html
%
% Syntax:  [alpha] = smoothstepdata(currentTimeStep,startTimeStep,finalTimeStep,startValue,finalValue)
%
% Inputs:
%    currentTimeStep - the current time step during an explicit simulation
%    startTimeStep   - start time step, always set to zero
%    finalTimeStep   - final time step, typically set to nTimeSteps
%    startValue      - value at start time step (if smoothly varying
%                      displacement, startValue = 0)
%    finalValue      - value at final time step
%
% Outputs:
%    alpha           - smoothly changing variable, output at every time
%                      step
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
% May 2019


%---------------------------- BEGIN CODE ----------------------------------

xi = (currentTimeStep - startTimeStep) / (finalTimeStep - startTimeStep);

alpha = startValue + (finalValue - startValue) * xi^3 * (10 - 15 * xi + 6 * xi^2); % 5th order polynomial

%----------------------------- END CODE -----------------------------------

end

