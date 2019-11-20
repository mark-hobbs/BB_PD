% This scipt saves the workspace with a unique file name. The file name
% should have a unique job ID, the date, the applied load, problem type
% (cantilever with point load etc), job name. Code based on following
% answer:-
% https://uk.mathworks.com/matlabcentral/answers/54688-how-to-check-the-existence-of-a-file-and-rename-it

% Unique file name is saved using the following convention:-
% Output_JobID_{date}_{job number suffix}_{applied load}



%% 
% Find the full path of the output folder located within the BB_PD root
% directory. 'what' is a built-in matlab function that will locate any
% folder on the matlab search path and return its contents.
outputFolderContentList = what('BB_PD/output'); 
outputFolderPath = outputFolderContentList.path;
%pointLoad=-MAXBODYFORCE*bodyforceCounter*VOLUME*bodyforceMultiplier;
%outputDestination=strcat(pwd,'/Output/'); % Determine output destination folder

dateFormat = 'yyyymmdd';
baseFileName = sprintf('Output_JobID_%s_1_%.0fN.mat' , datestr(now , dateFormat) , pointLoad);
fullFileName = fullfile(outputFolderPath , baseFileName);
jobNumberSuffix = 2; % Start at 2. First file is saved above

if isfile(fullFileName)  % if file name already exists

    baseFileName = sprintf('Output_JobID_%s_%d_%.0fN.mat' , datestr(now , dateFormat) , jobNumberSuffix , pointLoad);
    fullFileName = fullfile(outputFolderPath , baseFileName);

    % Prepare for next time, in case this name also exists
    jobNumberSuffix = jobNumberSuffix + 1;

end % File does not exist

save(fullFileName); % Save workspace