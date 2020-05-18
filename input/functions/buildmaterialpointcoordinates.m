function [undeformedCoordinates] = buildmaterialpointcoordinates(NOD, DX, nDivX, nDivY, nDivZ)
% buildmaterialpointcoordinates - specification of material point
% coordinates using a regular discretisation

%% Main body of function

% -------------------------------- 2D -------------------------------------
% Notation for 2D dimensions: Plane Stress
% length (x) x depth (y)

if NOD == 2
    
    undeformedCoordinates = zeros((nDivX * nDivY), NOD); % Initialise coordinates array
    counter = 0;

    for k3 = 0 : nDivY % depth (height)

        for k1 = 0 : nDivX % length

            coordx = DX * k1;
            coordy = DX * k3;
            counter = counter + 1;
            undeformedCoordinates(counter,1) = coordx; % length
            undeformedCoordinates(counter,2) = coordy; % depth (height)

        end
            
    end
    
% -------------------------------- 3D -------------------------------------  
% Notation for 3D dimensions:
% length (x) x depth (y) x width (z)

elseif NOD == 3
    
    undeformedCoordinates = zeros((nDivX * nDivY * nDivZ), NOD); % Initialise coordinates array
    counter = 0;

    for k3 = 0 : nDivZ % width

        for k2 = 0 : nDivY  % depth (height)

            for k1 = 0 : nDivX % length

                coordx = DX * k1;
                coordy = DX * k2;
                coordz = DX * k3;
                counter = counter + 1;
                undeformedCoordinates(counter,1) = coordx; % length
                undeformedCoordinates(counter,2) = coordy; % width
                undeformedCoordinates(counter,3) = coordz; % depth (height)

            end

        end

    end
    
end    
% ----------------------------- END CODE ----------------------------------


end
