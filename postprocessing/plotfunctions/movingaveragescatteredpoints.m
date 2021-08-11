function [x_unique, y_avg] = movingaveragescatteredpoints(x, y, windowSize, weight)
% movingaveragescatteredpoints - 
% 
% https://www.mathworks.com/matlabcentral/fileexchange/57945-scatstat1-local-statistics-of-scattered-1d-data
%
%
% Syntax: [] = movingaveragescatteredpoints()
%
% Inputs:
%   input1      - input data 1
%
% Outputs:
%   output1     - output data 1
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none
%
% Mark Hobbs 
% mch61@cam.ac.uk
% Department of Engineering
% Cambridge University
% January 2021

% ------------------------ BEGIN CODE -------------------------------------

x_unique = 0;       % Preallocate 
counter = 0;


for k = 1 : length(x)   % Loop through each x value
    
   y_sum = 0;
   denominator = 0; 
   
   if ismember(x(k), x_unique) == 0
       
       counter = counter + 1;
    
       % Record unique x value for every sliding window
       x_unique(counter,1) = x(k);

       % Indicies of all points within specified window size (sliding window): 
       ind = abs(x - x(k)) <= windowSize; 

       for i = 1 : size(ind,1)
           
           y_sum = y_sum + (y(i,1) * ind(i,1) * weight(i,1));
           denominator = denominator + (ind(i,1) * weight(i,1));

       end
       
       % Mean of y values within radius  
       y_avg(counter,1) = y_sum / denominator; % mean(y(ind));
       
   end 
   
end


% ------------------------- END CODE --------------------------------------

end