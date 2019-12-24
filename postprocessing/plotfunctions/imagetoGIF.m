function [] = imagetoGIF(filename,frameCounter)
% createGIF - 
%
% Syntax: 
%
% Inputs:
%   filename     - 
%   figureID     -
%   frameCounter -
%
%
% Outputs:
%
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
% August 2019

% ----------------------------- BEGIN CODE --------------------------------

% Pass in filename - don't overwrite this file 


% Create the plot (or pass the plot into the function)


% Capture the plot as an image
frame = getframe(gcf); % (figureID)
image = frame2im(frame);

% Convert RGB image to indexed image
[imind,colormap] = rgb2ind(image,256); 

% Save image as specific resolution
% https://stackoverflow.com/questions/39375620/save-image-in-specific-resolution-in-matlab

% Write to file - GIF 
if frameCounter == 1 
    
    imwrite(imind,colormap,filename,'gif', 'Loopcount',inf);      % First frame
    
else 
    
    imwrite(imind,colormap,filename,'gif','WriteMode','append');  % All subsequent frames
    
end
    
% ------------------------------ END CODE ---------------------------------
end

