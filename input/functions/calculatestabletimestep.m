function [DT]=calculatestabletimestep(TOTALNODES,bondlist,VOLUME,DENSITY,c)
% Calculate stable time step - use stability condition derived by Silling &
% Askari (2005)

denominatorCriticalTimeStep=zeros(TOTALNODES,1);
nBonds=size(bondlist,1);

for currentBond=1:nBonds
    
    nodei=bondlist(currentBond,1); % Node i
    nodej=bondlist(currentBond,2); % Node j
    
    denominatorCriticalTimeStep(nodei)=denominatorCriticalTimeStep(nodei)+(VOLUME*c(currentBond));
    denominatorCriticalTimeStep(nodej)=denominatorCriticalTimeStep(nodej)+(VOLUME*c(currentBond));
        
end

numeratorCriticalTimeStep=2*DENSITY;

% Determine critical time step for every particle
criticalTimeStep=sqrt(numeratorCriticalTimeStep./denominatorCriticalTimeStep);

% The critical time step is the minimum value of criticaltimestep vector
DT=min(criticalTimeStep);

% 1.5573e-5 using this function
% 1.1296e-6 using previous equation

end 