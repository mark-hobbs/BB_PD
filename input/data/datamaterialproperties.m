%--------------------------------------------------------------------------
% Define material properties data
%--------------------------------------------------------------------------

%----------------------------- Density ------------------------------------

densityConcrete = 2400;     % Density concrete (kg/m^3)
densitySteel = 8000;        % Density steel (kg/m^3)


%------------------------- Young's Modulus --------------------------------

Econcrete = 30.5e9;      % Young's modulus (remember to convert cubic test results to cylindrical equivalent) 
Esteel = 208e9;          % Young's modulus


%------------------------- Fracture Energy --------------------------------

fractureEnergyConcrete = 133;  % Fracture energy (N/m)
fractureEnergySteel = 12500;   % Fracture energy (N/m)


%------------------------- Poisson's Ratio --------------------------------

Vconcrete = 0.2;         % Poisson's ratio
Vsteel = 0.3;            % Poisson's ratio


%--------------------------- Shear Modulus --------------------------------

Gconcrete = Econcrete / (2 * (1 + Vconcrete));  % Shear modulus (TODO: Need to find more info on the correct value for shear modulus)
Gsteel = 78e9;           % Shear modulus


%----------------------- Effective Modulus --------------------------------

effectiveModulusConcrete = Econcrete / ((1 - 2 * Vconcrete) * (1 + Vconcrete));     % Effective modulus
effectiveModulusSteel = Esteel / ((1 - 2 * Vsteel) * (1 + Vsteel));                 % Effective modulus
