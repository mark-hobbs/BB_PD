%--------------------------------------------------------------------------
% Define geometry and discretisation parameters of member under analysis
%--------------------------------------------------------------------------
%
% Comment out relevant lines when creating 2D input files
% 
% Notation for 3D dimensions:
% OLD length (x) x width (y) x depth (z)
% NEW length (x) x depth (y) x width (z)
% 
% Notation for 2D dimensions: Plane Stress
% length (x) x depth (y)

%% Define geometry discretisation 

NOD = 3;    % Number of degrees of freedom

length = 1.45;   % x-axis (m)
width = 0.19;    % y-axis (m)
depth = 0.32;    % z-axis (m)

DX = 0.0115;    % Spacing between material points (mm). Using a regular discretisation

if NOD == 3
    
    nDivX = round(length/DX);        % Number of divisions in x-direction    - length
    nDivY = round(width/DX);         % Number of divisions in y-direction    - width
    nDivZ = round(depth/DX);         % Number of divisions in z-direction    - depth (height)
    cellVolume = DX^3;               % Cell volume

elseif NOD == 2
    
    nDivX = round(length/DX);        % Number of divisions in x-direction    - length
    nDivY = 1;                       % Number of divisions in y-direction    - width
    nDivZ = round(depth/DX);         % Number of divisions in z-direction    - depth (height)
    cellVolume = DX^2;               % Cell area
    
else
    
    fprintf('Please enter a valid value for NOD')
    return
    
end

RADIJ = DX/2;       % Material point radius

%% Define member geometry

memberLength = nDivX * DX;     % Length (m) - x
memberHeight = nDivY * DX;     % Height (m) - y
memberWidth = nDivZ * DX;      % Width (m) - z
