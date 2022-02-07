function [] = forceCMODdistribution()

m_to_mm = 1000;
N_to_kN = 1E-3;
xmin = 0;
xmax = 0.25;
sample_points = linspace(xmin, xmax, 500);  % Interpolate - xvariable (sample points)


% % =========================================================================
% %                          Beam 4 Unnotched
% % =========================================================================
% 
% load('/Users/mark/Documents/PhD/11 Model Validation/11.1 Results and Figures/Gregoire size effect tests/1 Unnotched/2 experimental results/Beam_4_un_exp.mat');
% load('/Users/mark/Documents/PhD/11 Model Validation/11.1 Results and Figures/Gregoire size effect tests/1 Unnotched/3 numerical results/Beam_4_UN_num.mat');
%  
% cmod = Beam_4_un_exp(1:20000,1)';      
% Force_mean = Beam_4_un_exp(1:20000,2)';
% Force_min = Beam_4_un_exp(1:20000,3)';
% Force_max = Beam_4_un_exp(1:20000,4)';
% 
% load_cmod(1, cmod, Force_mean, Force_min, Force_max, [0.8 0.8 0.8])

% % =========================================================================
% %                        Beam 4 half-notched
% % =========================================================================
% 
% load('/Users/mark/Documents/PhD/11 Model Validation/11.1 Results and Figures/Gregoire size effect tests/3 Half-notched/2 experimental results/Beam_4_hn_exp.mat')
% load('/Users/mark/Documents/PhD/11 Model Validation/11.1 Results and Figures/Gregoire size effect tests/3 Half-notched/3 numerical results/Beam_4_HN_num.mat')
% 
% cmod = Beam_4_hn_exp(:,1)';      
% Force_mean = Beam_4_hn_exp(:,2)';
% Force_min = Beam_4_hn_exp(:,3)';
% Force_max = Beam_4_hn_exp(:,4)';
% 
% load_cmod(1, cmod, Force_mean, Force_min, Force_max, [0.8 0.8 0.8])

% =========================================================================
%                         d = 80mm  e = 0.625d 
% =========================================================================

load('/Users/mark/Documents/PhD/11 Model Validation/11.1 Results and Figures/Garcia-Alvarez mixed-mode tests/Graphs low resolution/mixed_mode_exp.mat')
load('/Users/mark/Documents/PhD/11 Model Validation/11.1 Results and Figures/Garcia-Alvarez mixed-mode tests/Numerical results/e_pt625d_num.mat')

maxCMOD = max(d_80mm_e_pt625d_exp_2(:,1));

[CMOD_max, Force_max] = processgraphdata(maxCMOD, d_80mm_e_pt625d_exp_1(:,1), d_80mm_e_pt625d_exp_1(:,2) * N_to_kN, 'linear');
[CMOD_min, Force_min] = processgraphdata(maxCMOD, d_80mm_e_pt625d_exp_2(:,1), d_80mm_e_pt625d_exp_2(:,2) * N_to_kN, 'linear');

load_cmod(1, CMOD_min ./ m_to_mm, Force_min, Force_min, Force_max, [0.8 0.8 0.8])
plot(d_80mm_e_pt625d_exp_1(:,1) ./ m_to_mm, d_80mm_e_pt625d_exp_1(:,2) * N_to_kN, 'color', [0.8 0.8 0.8], 'LineWidth', 2, 'HandleVisibility', 'off')
plot(d_80mm_e_pt625d_num(:,7), d_80mm_e_pt625d_num(:,2) * N_to_kN, 'k--', 'LineWidth' , 1);

% =========================================================================
%                         Load output files
% =========================================================================

fprintf('\nSelect directory containing output files...\n\n')
outputDir = uigetdir;                               % Get output directory
outputF = dir(fullfile(outputDir,'*.mat'));         % Gets all .mat files in output directory

outputFiles = {outputF.name}';
outputFiles = sort_nat(outputFiles);

nFiles = length(outputFiles);

for kFile = 1 : nFiles
    
    baseFileName = outputFiles(kFile);
    fullFileName = fullfile(outputDir, baseFileName);
    fprintf('Now reading %s\n', fullFileName{:});
    load(fullFileName{:});
    
    [CMOD, idx] = unique(loadCMOD(2,:) * m_to_mm);
    force = loadCMOD(1,idx) * N_to_kN;
  
    plot(CMOD, force, 'LineWidth', 0.5, 'Color', [0, 0.4470, 0.7410, 0.5])
    hold on
        
    y_sampled = interp1(CMOD, force, sample_points);
    gather_data(kFile,:) = y_sampled;
  
end

mean_force = mean(gather_data);

grid on
xlabel('CMOD [mm]', 'interpreter', 'latex', 'FontSize', 10)
ylabel('Load [kN]', 'interpreter', 'latex', 'FontSize', 10)
xlim([0 0.25])

set(gca,'TickLabelInterpreter', 'latex') % gca returns the current axes (get current axis handle)
set(gca,'fontsize', 8)                   % Default is 10
set(gcf, 'Units', 'centimeters', 'Position', [2, 2, 12, 8], 'PaperUnits', 'centimeters', 'PaperSize', [12, 8])


plot(sample_points, mean_force, 'k', 'LineWidth', 1)

% plot(Decaying_exponential_FEC(:,7), Decaying_exponential_FEC(:,2) * N_to_kN, 'k--', 'LineWidth' , 1)                   % Decaying exponential damage model - fracture energy corrections


end

% =========================================================================
%                          Sub-functions
% =========================================================================

function load_cmod(newfigureflag, cmod, Force_mean, Force_min, Force_max, line_colour)

if newfigureflag == 1
    figure
end

plot(cmod, Force_mean, 'Color', line_colour , 'LineWidth' , 1.5)
hold on
CMOD = [cmod, fliplr(cmod)];
inBetween = [Force_min, fliplr(Force_max)];
errorRange = fill(CMOD, inBetween, [0.8 0.8 0.8], 'HandleVisibility', 'off');
errorRange.EdgeColor = 'none';
uistack(errorRange, 'bottom')

grid on
xlabel('CMOD [mm]', 'interpreter', 'latex', 'FontSize', 10)
ylabel('Load [kN]', 'interpreter', 'latex', 'FontSize', 10)

set(gca,'TickLabelInterpreter', 'latex') % gca returns the current axes (get current axis handle)
set(gca,'fontsize', 8)                   % Default is 10
set(gcf, 'Units', 'centimeters', 'Position', [2, 2, 12, 8], 'PaperUnits', 'centimeters', 'PaperSize', [12, 8])

end


function determine_mean_line(xvariable, yvariable, xmin, xmax)


end



