function [] = newtonraphsonnew()
% newtonraphson -  This functions solves sets of non-linear equations in
% the form F = Ku using the Newton-Raphson method with fracture. In
% non-linear analysis, an iterative process is required to reduce the error
% in the calculated displacement vector. The iterative procedure continues
% until the external force vector and internal force vector are equal
% (within a given tolerance).
%
% Syntax: 
%
% Inputs:
%   input1  - 
% 
%
% Outputs:
%   output1 -
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

% Calculate the change in displacement (DELTA U / delta u)

% Calculate bond stretch and failure

% Did any bonds fail or yield?

% Calculate the internal force

% Calculate the out of balance force vector and check the convergence
% criteria

% Update the stiffness matrix

% ----------------------------- END CODE ----------------------------------

end

