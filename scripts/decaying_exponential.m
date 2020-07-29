% ===============================
%   Decaying exponential model
% ===============================

clear all
% close all

s = [0 : 0.00000001 : 1E-2]';
k = 20;              % Rate of decay
k_new = 1000;        % Rate of decay
alpha = 1/3;         % Asymptote
s0 = 9.46E-5; % / ( 1 + alpha );
sc = 2.19E-3;
    
GF = 133.496;
c = 2.3214e18;
delta = 15.708 / 1000;

% Abaqus CZM
% sc = (GF + (pi * c * delta^5 * s0^2)/(5 * k) - (pi * c * delta^5 * s0^2 * (alpha - alpha * exp(k) + 1)) / (5 * (exp(k) - 1))) / ((pi * c * delta^5 * s0)/(5 * k) - (pi * c * delta^5 * s0 * (alpha - alpha * exp(k) + 1)) / (5 * (exp(k) - 1)));
% sc = (10 * GF * k - 10 * GF * k * exp(k) + 2 * pi * c * delta^5 * s0^2 + 2 * pi * c * delta^5 * k * s0^2 - 2 * pi * c * delta^5 * s0^2 * exp(k) + pi * alpha * c * delta^5 * k * s0^2 - pi * alpha * c * delta^5 * k * s0^2 * exp(k))/(c * delta^5 * s0 * pi * (2 * k - 2 * exp(k) + alpha * k - alpha * k * exp(k) + 2));
sc = (10 * GF * k + 10 * GF * alpha * k - 10 * GF * k * exp(k) - 10 * GF * alpha * k * exp(k) + 2 * pi * c * delta^5 * s0^2 + 2 * pi * c * delta^5 * k * s0^2 - 2 * pi * c * delta^5 * s0^2 * exp(k) + pi * alpha * c * delta^5 * k * s0^2 - pi * alpha * c * delta^5 * k * s0^2 * exp(k)) / (c * delta^5 * s0 * pi * (2 * k - 2 * exp(k) + alpha * k - alpha * k * exp(k) + 2));

% Tong model
% s0 = sqrt((10 * material.concrete.fractureEnergy)/(pi * bond.concrete.stiffness * delta^5)) / sqrt(1 + (2/k));


for i = 1 : size(s,1)
    
        
    % =============================
    %     Decaying Exponential
    % =============================
   
    if s(i) <= s0
        
        
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
        residual = (alpha * (1 - (s(i) - s0) / (sc - s0)));
        bsf(i,1) = 1 - (s0 / s(i)) * (((1 - (numerator / denominator))) + residual)/(1 + alpha);
        force(i,1) = (1 - bsf(i,1)) * s(i);
        
        % ==============================
        %       Tong et al., 2020
        % ==============================
        % bsf(i,1) = (s0 / s(i)) * (exp(-k_Tong * ((s(i) - s0) / s0)) + (alpha_Tong * (s(i) - s0) / s(i))); 
        % force(i,1) = (1 - bsf(i,1)) * s(i);
                
        % ==============================
        %  Standard exponential function
        % ==============================
        bsf_(i,1) = 1 - (s0 / s(i)) * (exp(-(s(i) - s0) / (s0 * k)) + (alpha * (s(i) - s0)/s(i)));   % bsf
        f(i,1) = (1 - bsf_(i,1)) * s(i);                                                             % force
 
        
    elseif s(i) > sc
        
        
        bsf(i,1) = 1;
        force(i,1) = (1 - bsf(i,1)) * s(i);
                
        
        bsf_(i,1) =  1;                     % bsf
        f(i,1) = (1 - bsf_(i,1)) * s(i);    % force
        
    end
    
    % numerator = 1 - exp(-k * (s(i) - s0) / (sc - s0));
    % denominator = 1 - exp(-k);
    % bsf(i,1) = 1 - (s0 / s(i)) * ((1 - (numerator / denominator)) + alpha ); % * (s(i) - s0) / (sc - s0)
    % force(i,1) = (1 - bsf(i,1)) * s(i);
    
        
end

plot(s, force , 'LineWidth', 1.5)
hold on
% plot(s, f, 'k--', 'LineWidth', 1.5)

xlabel('stretch', 'interpreter', 'latex', 'FontSize', 10)
ylabel('force', 'interpreter', 'latex', 'FontSize', 10)
text1 = ['Abaqus CZM \(k\) = ', num2str(k), ' \(s_c\) = ', num2str(sc), ' \(s_c/s_0\) = ', num2str(sc/s0)];
text2 = ['Standard exponential function \(k\) = ', num2str(k)];
legend(text1, text2 , 'interpreter' , 'latex', 'FontSize' , 8)
set(gca,'TickLabelInterpreter', 'latex') % gca returns the current axes (get current axis handle)
set(gca,'fontsize', 8)                   % Default is 10





