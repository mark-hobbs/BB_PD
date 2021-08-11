% -------------------------------------------------------------------------
% Peridynamic parameters
% -------------------------------------------------------------------------

%----------------- Peridynamic Horizon Radius (delta) ---------------------

horizonRadius = pi * DX;    % Peridynamic horizon radius


%---------------------- Neighbourhood area/volume -------------------------

if NOD == 2
    
    neighbourhoodVolume = pi * horizonRadius^2;           % Neighbourhood area for node contained within material bulk
    
elseif NOD == 3
    
    neighbourhoodVolume = (4/3) * pi * horizonRadius^3;   % Neighbourhood volume for node contained within material bulk
    
end


%---------------------------- Bond Stiffness ------------------------------

if NOD == 2 % Plane stress
    
    bondStiffnessConcrete = (9 * Econcrete) / (pi * horizonRadius^3);    % Bond stiffness concrete 2D - should thickness be included in this equation?
    bondStiffnessSteel = (9 * Esteel) / (pi * horizonRadius^3);          % Bond stiffness steel 2D
    
elseif NOD == 3 
    
    bondStiffnessConcrete = (12 * Econcrete) / (pi * horizonRadius^4);   % Bond stiffness concrete 3D
    bondStiffnessSteel = (12 * Esteel) / (pi * horizonRadius^4);         % Bond stiffness steel 3D    
    
end