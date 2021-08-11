function [] = createanimation()

% Load main input file
fprintf('\nSelect input file...\n')
[fileName, filePath] = uigetfile;
inputFile = fullfile(filePath, fileName);
% inputFile = 'D:\Model Validation\3 Stuttgart Shear Tests\Input files\StuttgartBeam7_fine.mat';
load(inputFile);

% Load output files
fprintf('\nSelect directory containing output files...\n\n')
outputDir = uigetdir;                               % Get output directory
% outputDir = 'D:\Model Validation\3 Stuttgart Shear Tests\Beam 7\Damage_fine_mesh';
outputF = dir(fullfile(outputDir,'*.mat'));         % Gets all .mat files in output directory

outputFiles = {outputF.name}';
outputFiles = sort_nat(outputFiles);

nFiles = length(outputFiles);

% Figure
figure, set(gcf, 'Color','white')

% Preallocate
% nFrames = nFiles;
% f = getframe(gca);
% [f,map] = rgb2ind(f.cdata, 256, 'nodither');
% mov = repmat(f, [1 1 1 nFrames]);

sz = 50;     % 5
dsf = 12.5;   % 20

for kFile = 1 : nFiles
    
  baseFileName = outputFiles(kFile);
  fullFileName = fullfile(outputDir, baseFileName);
  fprintf('Now reading %s\n', fullFileName{:});
  load(fullFileName{:});
  
  % Plotting
  % damage = calculatedamage(BONDLIST, fail, nFAMILYMEMBERS);
  damage = calculatedamage(BONDLIST, 1 - flagBondSoftening, nFAMILYMEMBERS);
  
  ucReduced = undeformedCoordinates(:,:);
  dcReduced = deformedCoordinates(:,:);
  damageReduced = damage(:,:);
  
  logicCondition1 = damage > 0.9;    % Discard detached nodes 
  ucReduced(logicCondition1,:) = [];
  dcReduced(logicCondition1,:) = [];
  damageReduced(logicCondition1,:) = []; 
  
  % plotbonddamage(undeformedCoordinates, deformedCoordinates, damage, DX , sz, dsf)
  plotnodaldata(ucReduced, (dcReduced - ucReduced), damageReduced, 'damage', sz, dsf)
  
  axis tight
  set(gca,'visible','off')
  set(gca,'xtick',[],'ytick',[])
  colorbar off 
  drawnow
  
  % Get frame as an indexed image with a map
  I = frame2im(getframe(gcf));
  [Ind, map] = rgb2ind(I,256,'nodither');
  
  if kFile == 1
    
    % First iteration, set up GIF properties: loop count and delay time
    imwrite(Ind,map,'SB7_.gif','gif', 'LoopCount',Inf,'DelayTime',0);
    
    
  else
      
    % All other iterations, append new frame
    imwrite(Ind,map,'SB7_.gif','gif', 'WriteMode','append','DelayTime',0);
    
  end
  
    
end


end

