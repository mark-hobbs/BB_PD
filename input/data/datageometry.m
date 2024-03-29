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

length = 0.175;   % x-axis (m) TODO: rename length. length() is an inbuilt matlab function
width = 0.05;     % y-axis (m) 
depth = 0.05;     % z-axis (m)

DX = 5/1000;    % Spacing between material points (mm). Using a regular discretisation (0.00575 m / 0.007667 m / 0.0115 m)

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
memberDepth = nDivY * DX;      % Depth (m) - y
memberWidth = nDivZ * DX;      % Width (m) - z
