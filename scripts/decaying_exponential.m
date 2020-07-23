% ===============================
%   Decaying exponential model
% ===============================

clear all
% close all

s0 = 8.75E-5;
sc = 2.19E-3;
s = [0 : 0.000001 : 1E-2]';
k = 100;             % Rate of decay
k_new = 1000;       % Rate of decay
alpha = 0.02;       % Asymptote

load('Beam_4_UN_DX5mm.mat')
GF = material.concrete.fractureEnergy;
c = bond.concrete.stiffness;
delta = horizon;

% Abaqus CZM
% sc = -(5 * k * (exp(k) - 1) * (GF - (pi * c * delta^5 * s0^2 * (k - exp(k) + 1))/(5 * k * (exp(k) - 1)))) / (c * delta^5 * s0 * pi * (k - exp(k) + 1)); % 2.19E-3
sc = (GF + (pi * c * delta^5 * s0^2)/(5 * k) - (pi * c * delta^5 * s0^2 * (alpha - alpha * exp(k) + 1)) / (5 * (exp(k) - 1))) / ((pi * c * delta^5 * s0)/(5 * k) - (pi * c * delta^5 * s0 * (alpha - alpha * exp(k) + 1)) / (5 * (exp(k) - 1)));

% Tong model
% s0 = sqrt((10 * material.concrete.fractureEnergy)/(pi * bond.concrete.stiffness * delta^5)) / sqrt(1 + (2/k));


for i = 1 : size(s,1)
    
        
    % =============================
    %     Decaying Exponential
    % =============================
   
    if s(i) < s0 
        
        
        bsf(i,1) = 0;
        force(i,1) = (1 - bsf(i,1)) * s(i);
        
               
        bsf_(i,1) =  0;                      % bsf
        f(i,1) = (1 - bsf_(i,1)) * s(i);     % force
        
    elseif s(i) > s0 && s(i) <= sc
        
    
        % ==============================
        %          Abaqus CZM
        % ==============================
        numerator = 1 - exp(-k * (s(i) - s0) / (sc - s0));
        denominator = 1 - exp(-k);
        bsf(i,1) = 1 - ((s0 / s(i)) * (((1 - (numerator / denominator))) + ( -alpha * (s(i) - sc)/ (sc - s(i)))));
        force(i,1) = (1 - bsf(i,1)) * s(i);
        
        % ==============================
        %       Tong et al., 2020
        % ==============================
        % bsf(i,1) = (s0 / s(i)) * (exp(-k * ((s(i) - s0) / s0)) + (alpha * (s(i) - s0) / s(i))); 
        % force(i,1) = (1 - bsf(i,1)) * s(i);
                
        % ==============================
        %  Standard exponential function
        % ==============================
        bsf_(i,1) = 1 - (s0 / s(i)) * (exp(-(s(i) - s0) / (s0 * k)) + (0.05 * (s(i) - s0)/s(i)));   % bsf
        f(i,1) = (1 - bsf_(i,1)) * s(i);                                % force
 
        
    elseif s(i) > sc
        
        
        bsf(i,1) = 1;
        force(i,1) = (1 - bsf(i,1)) * s(i);
                
        
        bsf_(i,1) =  1;   % bsf
        f(i,1) = (1 - bsf_(i,1)) * s(i);                    % force
        
    end
    
    % bsf_(i,1) =  (1 - (s0 / s(i)) * (alpha + (1 - alpha) * exp(-k_new * s(i))));   % bsf
    % f(i,1) = (1 - bsf_(i,1)) * s(i);  
    
    % numerator = 1 - exp(-k * (s(i) - s0) / (sc - s0));
    % denominator = 1 - exp(-k);
    % bsf(i,1) = 1 - (s0 / s(i)) * (((1 - (numerator / denominator)))  + (- alpha * (s(i) - sc)/ (sc - s(i))));
    % force(i,1) = (1 - bsf(i,1)) * s(i);
    
    
end


plot(s, force , 'b', 'LineWidth', 1.5)
hold on
% plot(s, f, 'k--', 'LineWidth', 1.5)

xlabel('stretch', 'interpreter', 'latex', 'FontSize', 10)
ylabel('force', 'interpreter', 'latex', 'FontSize', 10)
text1 = ['Abaqus CZM \(k\) = ', num2str(k), ' \(s_c\) = ', num2str(sc), ' \(s_c/s_0\) = ', num2str(sc/s0)];
text2 = ['Standard exponential function \(k\) = ', num2str(k)];
legend(text1, text2 , 'interpreter' , 'latex', 'FontSize' , 8)
set(gca,'TickLabelInterpreter', 'latex') % gca returns the current axes (get current axis handle)
set(gca,'fontsize', 8)                   % Default is 10





