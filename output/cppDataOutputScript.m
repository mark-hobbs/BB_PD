
% C++ data output script


%% Create bond data file

fileID = fopen('bond_data.txt','w');

for i = 1:size(BONDLIST,1)
    
    fprintf(fileID,'%d \t %d \t %f\n', BONDLIST(i,1), BONDLIST(i,2), UNDEFORMEDLENGTH(i,1));
    
end

fclose(fileID);

%% Create nodal data file

fileID = fopen('nodal_data.txt','w');

for i = 1:size(undeformedCoordinates,1)
    
    fprintf(fileID,'%f \t %f \t %f\n', undeformedCoordinates(i,1), undeformedCoordinates(i,2), undeformedCoordinates(i,3));
    
end

fclose(fileID);