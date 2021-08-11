function [] = printoutput(iTimeStep, frequency, reactionForce, nodalDisplacement, fail, flagBondSoftening, flagBondYield, CMOD, damageEnergy)
% printoutput - print output to be saved in a text file. Save in a format
% suitable for processing at a later stage
%
% Syntax: [] = printoutput()
%
% Inputs:
%   iTimeStep           - Current time step
%   frequency           - Define the frequency of text output (number of time steps)
%   reactionForce       - Reaction force (kN)
%   nodalDisplacement   - Displacement at a specified node
%   fail                - Identify point at which fracture initiates
%   flagBondSoftening   - Identify point at which the linear elastic limit is exceeded
%   flagBondYield       - Identify point at which steel yields
%   kineticEnergy       -
%   strainEnergy        -
%   damageEnergy        - 
%   CMOD                - Crack mouth opening displacement 
%   
% 
% Outputs:
%
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
% November 2019

% ---------------------------- BEGIN CODE ---------------------------------

if mod(iTimeStep, frequency) == 0
    
    sumFail = size(fail,1) - sum(fail);
    sumFBS = sum(flagBondSoftening);
    sumFBY = sum(flagBondYield);
    nodalDisplacement = nodalDisplacement * 1000; % convert from m to mm
    CMOD = CMOD * 1000;                           % convert from m to mm
  
    % | Time Step | Reaction Force (N) | Displacement (mm) | .... 
    % | Damage | Concrete Softening | Interface Softening | Steel Yielding | ...
    % | Max Stretch Concrete | Max Stretch Interface | Max Stretch Steel | ...
    % | Kinetic Energy | Strain Energy | Damage Energy | ...

    fprintf('%.0f \t %.5f \t %.6f \t %.0f \t %.0f \t %.0f \t %.6f \t %.5f \n', iTimeStep, reactionForce, nodalDisplacement, sumFail, sumFBS, sumFBY, CMOD, damageEnergy)

end

% ----------------------------- END CODE ----------------------------------

end

