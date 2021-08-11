% =========================================================================
%                   Critical Stretch Derivation
% =========================================================================

% Use the symbolic toolbox to verify the critical stretch derivation

%% Volume of a sphere
% Validate the symbolic solver. Recover the volume of a sphere:
% V = 4/3 * pi * r

syms r phi theta R

fun = r^2 * sin(phi);

first = int(fun, theta, 0, 2 * pi);

second = int(first, phi, 0, pi);

third = int(second, r, 0, R);


%% Fracture energy

syms phi xi theta z c s0 delta

funFE = ((c * s0^2 * xi) / 2) * xi^2 * sin(phi);

firstFE = int(funFE, z, 0, delta)

secondFE = int(firstFE, theta, 0, 2 * pi)

thirdFE = int(secondFE, xi, z, delta)

fourthFE = int(thirdFE, phi, 0, acos(z/xi))



    