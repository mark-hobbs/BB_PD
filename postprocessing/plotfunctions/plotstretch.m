function plotstretch(stretch,fail,BONDLIST,undeformedCoordinates,nodalDisplacement,DX,dsf,sz)
% Maximum bond stretch for every node - absolute, tension, compression

plotOnOff = [true, true, true]; % true = on, false = off [absolute, tension, compression]
nBonds = size(BONDLIST,1);
nNodes = size(undeformedCoordinates,1);

%% Maximum absolute bond stretch - Tension or compression

if plotOnOff(1) == true % Logic condition to turn plot on/off

    maxStretchAbsolute = zeros(nNodes,1); 
    stretchAbsolute = abs(stretch); % Return the absolute value of every element of Stretch vector  

    % For every node, iterate over all connected bonds and find the bond with
    % the largest stretch value. If the maximum stretch value currently stored
    % for node i or j is less than the absolute stretch value for the current
    % bond, replace maxStretch with this value.

    for kBond = 1 : nBonds
        
        if fail(kBond,1) == 1

            nodei = BONDLIST(kBond,1);
            nodej = BONDLIST(kBond,2);

            % Iterate over column 1 of bondlist - nodei

            if maxStretchAbsolute(nodei,1) < stretchAbsolute(kBond)

                maxStretchAbsolute(nodei,1) = stretchAbsolute(kBond);

            end

            % Iterate over column 2 of bondlist - nodej

            if maxStretchAbsolute(nodej,1) < stretchAbsolute(kBond)

                maxStretchAbsolute(nodej,1) = stretchAbsolute(kBond);

            end
        
        end

    end

    maxStretchAbsolute = log(maxStretchAbsolute);
    
    % Plot data
    figure
    scatter3(undeformedCoordinates(:,1)+(nodalDisplacement(:,1,1)*dsf),undeformedCoordinates(:,2)+(nodalDisplacement(:,2,1)*dsf),undeformedCoordinates(:,3)+(nodalDisplacement(:,3,1)*dsf),sz,maxStretchAbsolute(:,1),'filled')
    axis equal
    title('Maximum Absolute Bond Stretch')
    xlabel('x')
    ylabel('y')
    zlabel('z')
    %view([0,-90,0]) % View in 2D
    view(40,35)    % View in 3D
    colormap jet 
    colorbar
    h = colorbar;
    ylabel(h, 'Stretch')

end

%% Maximum bond stretch - Tension

if plotOnOff(2) == true
    
    maxStretchTension = zeros(nNodes,1); 

    for kBond = 1 : nBonds
        
        if fail(kBond,1) == 1

            nodei = BONDLIST(kBond,1);
            nodej = BONDLIST(kBond,2);

            % Iterate over column 1 of bondlist - nodei

            if maxStretchTension(nodei,1) < stretch(kBond)  % Bonds under tension have positive stretch values

                maxStretchTension(nodei,1) = stretch(kBond);

            end

            % Iterate over column 2 of bondlist - nodej

            if maxStretchTension(nodej,1) < stretch(kBond)

                maxStretchTension(nodej,1) = stretch(kBond);

            end
        
        end

    end

    % maxStretchTension = log(maxStretchTension);
    [~,outliers] = rmoutliers(maxStretchTension);
    maxStretchTension(outliers) = 0;

    % Plot data
    figure
    scatter3(undeformedCoordinates(:,1)+(nodalDisplacement(:,1,1)*dsf),undeformedCoordinates(:,2)+(nodalDisplacement(:,2,1)*dsf),undeformedCoordinates(:,3)+(nodalDisplacement(:,3,1)*dsf),sz,maxStretchTension(:,1),'filled')
    axis equal
    title('Maximum Bond Stretch - Tension')
    xlabel('x')
    ylabel('y')
    zlabel('z')
    %view([0,-90,0]) % View in 2D
    view(40,35)    % View in 3D
    colormap jet 
    colorbar
    h = colorbar;
    ylabel(h, 'Stretch')
    
    [coordCrossSection] = extractcrosssection(undeformedCoordinates, undeformedCoordinates, DX*6);
    [dispCrossSection] = extractcrosssection(undeformedCoordinates, nodalDisplacement, DX*6);
    [stretchCrossSection] = extractcrosssection(undeformedCoordinates, maxStretchTension, DX*6);
    
    figure
    scatter(coordCrossSection(:,1) + (dispCrossSection(:,1,1) * dsf), coordCrossSection(:,3) + (dispCrossSection(:,3,1) * dsf), sz, stretchCrossSection, 'filled')
    axis equal
    xlabel('x') % length
    ylabel('y') % depth
    colormap jet 
    colorbar
    h = colorbar;
    ylabel(h, 'Stretch')

end

%% Maximum bond stretch - Compression

if plotOnOff(3) == true
    
    maxStretchCompression = zeros(nNodes,1); 

    for kBond = 1 : nBonds
        
        if fail(kBond,1) == 1

            nodei = BONDLIST(kBond,1);
            nodej = BONDLIST(kBond,2);

            % Iterate over column 1 of bondlist - nodei

            if maxStretchCompression(nodei,1) > stretch(kBond)  % Bonds under tension have positive stretch values

                maxStretchCompression(nodei,1) = stretch(kBond);

            end

            % Iterate over column 2 of bondlist - nodej

            if maxStretchCompression(nodej,1) > stretch(kBond)

                maxStretchCompression(nodej,1) = stretch(kBond);

            end
        
        end

    end
    
    % maxStretchCompression = log(maxStretchCompression);
    [~,outliers] = rmoutliers(maxStretchCompression);
    maxStretchCompression(outliers) = 0;
    
    % Plot data
    figure
    scatter3(undeformedCoordinates(:,1)+(nodalDisplacement(:,1,1)*dsf),undeformedCoordinates(:,2)+(nodalDisplacement(:,2,1)*dsf),undeformedCoordinates(:,3)+(nodalDisplacement(:,3,1)*dsf),sz,maxStretchCompression(:,1),'filled')
    axis equal
    title('Maximum Bond Stretch - Compression')
    xlabel('x')
    ylabel('y')
    zlabel('z')
    %view([0,-90,0]) % View in 2D
    view(40,35)    % View in 3D
    colormap jet 
    colorbar
    h = colorbar;
    ylabel(h, 'Stretch')
    
    [coordCrossSection] = extractcrosssection(undeformedCoordinates, undeformedCoordinates, DX*6);
    [dispCrossSection] = extractcrosssection(undeformedCoordinates, nodalDisplacement, DX*6);
    [stretchCrossSection] = extractcrosssection(undeformedCoordinates, maxStretchCompression, DX*6);
    
    figure
    scatter(coordCrossSection(:,1) + (dispCrossSection(:,1,1) * dsf), coordCrossSection(:,3) + (dispCrossSection(:,3,1) * dsf), sz, stretchCrossSection, 'filled')
    axis equal
    xlabel('x') % length
    ylabel('y') % depth
    colormap jet 
    colorbar
    h = colorbar;
    ylabel(h, 'Stretch')

end

end 