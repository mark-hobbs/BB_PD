% This program creates a movie/slideshow from a set of images, and save it as an animated GIF file.
% Notice that the quality an image may decrease due to the GIF format.
%
% Written by Moshe Lindner , Bar-Ilan University, Israel.
% September 2010 (C)
clear all

[file_name file_path] = uigetfile({'*.jpeg;*.jpg;*.bmp;*.tif;*.tiff;*.png;*.gif' , 'Image Files (JPEG, BMP, TIFF, PNG and GIF)'} , 'Select Images' , 'multiselect' , 'on');
% file_name = sort(file_name);
file_name = sort_nat(file_name);
[file_name2 file_path2] = uiputfile('*.gif' , 'Save as animated GIF' , file_path);

lps=questdlg('How many loops?','Loops','Forever','None','Other','Forever');
switch lps
    case 'Forever'
        loops = 65535;
    case 'None'
        loops = 1;
    case 'Other'
        loops = inputdlg('Enter number of loops? (must be an integer between 1-65535)        .' , 'Loops');
        loops = str2num(loops{1});
end

delay = inputdlg('What is the delay time? (in seconds)        .','Delay');
delay = str2num(delay{1});
dly = questdlg('Different delay for the first image?' , 'Delay' , 'Yes' , 'No' , 'No');

if strcmp(dly,'Yes')
    delay1=inputdlg('What is the delay time for the first image? (in seconds)        .','Delay');
    delay1=str2num(delay1{1});
else
    delay1=delay;
end
dly=questdlg('Different delay for the last image?','Delay','Yes','No','No');
if strcmp(dly,'Yes')
    delay2=inputdlg('What is the delay time for the last image? (in seconds)        .','Delay');
    delay2=str2num(delay2{1});
else
    delay2=delay;
end

h = waitbar(0,['0% done'],'name','Progress');

for i=1:length(file_name)
 
    if strcmpi('gif',file_name{i}(end-2:end))
        [M  c_map]=imread([file_path,file_name{i}]);
    else
        a=imread([file_path,file_name{i}]);
        [M  c_map]= rgb2ind(a,256);
    end
    
    if i==1
        imwrite(M,c_map,[file_path2,file_name2],'gif','LoopCount',loops,'DelayTime',delay1)
    elseif i==length(file_name)
        imwrite(M,c_map,[file_path2,file_name2],'gif','WriteMode','append','DelayTime',delay2)
    else
        imwrite(M,c_map,[file_path2,file_name2],'gif','WriteMode','append','DelayTime',delay)
    end
    
    waitbar(i/length(file_name),h,[num2str(round(100*i/length(file_name))),'% done']);
    
end

close(h);
msgbox('Finished Successfully!')