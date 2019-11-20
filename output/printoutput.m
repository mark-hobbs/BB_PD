function [] = printoutput(iTimeStep, frequency, reactionForce, nodalDisplacement, fail, flagBondSoftening, flagBondYield)
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
%   
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

    % | Time Step | Reaction Force (N) | Displacement (mm) | Damage | Concrete Softening | Steel Yielding | Kinetic Energy | Strain Energy | Damage Energy |

    fprintf('%.0f \t %.3f \t %.3f \t %.0f \t %.0f \t %.0f \n', iTimeStep, reactionForce, nodalDisplacement, sumFail, sumFBS, sumFBY)

end

% ----------------------------- END CODE ----------------------------------

end

