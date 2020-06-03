%--------------------------------------------------------------------------
% Define material properties data
%--------------------------------------------------------------------------

%----------------------------- Density ------------------------------------

material.concrete.density = 2400;     % Density concrete (kg/m^3)
material.steel.density = 8000;        % Density steel (kg/m^3)


%------------------------- Young's Modulus --------------------------------

material.concrete.E = 37E9;       % Young's modulus (remember to convert cubic test results to cylindrical equivalent) 
material.steel.E = 208e9;         % Young's modulus


%------------------------- Fracture Energy --------------------------------

material.concrete.fractureEnergy = 133;   % Fracture energy (N/m)
material.steel.fractureEnergy = 12500;    % Fracture energy (N/m)


%------------------------- Poisson's Ratio --------------------------------

material.concrete.v = 0.2;         % Poisson's ratio
material.steel.v = 0.3;            % Poisson's ratio


%--------------------------- Shear Modulus --------------------------------

material.concrete.shearModulus = material.concrete.E / (2 * (1 + material.concrete.v));  % Shear modulus (TODO: Need to find more info on the correct value for shear modulus)
material.steel.shearModulus = 78e9;                                                      % Shear modulus


%----------------------- Effective Modulus --------------------------------

material.concrete.effectiveModulus = material.concrete.E / ((1 - 2 * material.concrete.v) * (1 + material.concrete.v));     % Effective modulus
material.steel.effectiveModulus = material.steel.E / ((1 - 2 * material.steel.E) * (1 + material.steel.E));                 % Effective modulus
