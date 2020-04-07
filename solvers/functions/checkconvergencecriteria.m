function [g,gEuclideanNorm,tolerance] = checkconvergencecriteria(Fext,Fint)
% checkconvergencecriteria - 
%
% Syntax: 
%
% Inputs:
%   Fext  -
%   Fint  -
% 
% Outputs:
%   g               -
%   gEuclideanNorm  -
%   tolerance       -
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
% June 2019

% ---------------------------- BEGIN CODE ---------------------------------

sumFext = sum(Fext); % Net applied external force
sumFint = sum(Fint); % Net internal force
fprintf('The net external force is %.5fN  \n', sumFext)
fprintf('The net internal force is %.5fN  \n', sumFint)

g = Fext - Fint;    % Calculate the out of balance force vector
gEuclideanNorm = norm(g);
fprintf('The Euclidean norm of the residual force vector is %.5f  \n', gEuclideanNorm)

tolerance = abs(0.005 * sumFint); % Tolerance is set to 0.5% of force in system
fprintf('The convergence tolerance is %.5f \n', tolerance)

% ----------------------------- END CODE ----------------------------------

end

