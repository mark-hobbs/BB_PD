% ===============================
%        Trilinear model
% ===============================

clear all
% close all


s = [0 : 0.0000001 : 1E-2]';
lambda = 0.25;
beta = 0.25; 
s0 = 9.46E-5;
gamma = (3 + 2 * beta) / (2 * beta * (1 - beta));

GF = 133.496;
c = 2.3214e18;
delta = 15.708 / 1000;

sc = ((10 * GF * gamma + pi * c * delta^5 * s0^2 + pi * beta * c * delta^5 * gamma * s0^2) / (c * delta^5 * s0 * pi * (beta * gamma + 1)));     % Equation derived by myself
sc_ = ((10 * GF * gamma) / (c * delta^5 * s0 * pi * (beta * gamma + 1))) + s0;                                                                  % Equation from Yang paper
s1 = ((sc - s0)/gamma) + s0;
eta = s1/s0;

a = (s1 - s0*lambda) / (s1 - s0);
b1 = (sc - s1*lambda);
b2 = (sc - s1);
b = b1/b2;

gradient_s0s1 = ((1 - lambda) * s0) / (s1 - s0);
gradient_s1sc = (lambda * s0) / (sc - s1); 

for i = 1 : size(s,1)
    
    
    % =============================
    %           Trilinear
    % =============================
    % https://www.hindawi.com/journals/sv/2017/8329545/
    % A Damaged Constitutive Model for Rock under Dynamic and High Stress State
    
    if s(i) < s0 
        
        bsf(i,1) = 0;
        force(i,1) = (1 - bsf(i,1)) * s(i);
        stretch(i,1) = s(i);
    
    elseif s(i) > s0 && s(i) <= s1
        
        bsf(i,1) = 1 - ( (eta - lambda) / (eta - 1) * (s0 / s(i)) ) + ( (1 - lambda) / (eta - 1) ); 
        force(i,1) = (1 - bsf(i,1)) * s(i);
        stretch(i,1) = s(i);

    elseif s(i) > s1 && s(i) <= sc
        
        % bsf(i,1) = 1 - (lambda * s0 / s(i)); % + ( (lambda * s0) / (sc - s1) );
        bsf(i,1) = 1 - ( (s0 * lambda) / s(i) ) * ( (sc - s(i)) / (sc - s1) );
        force(i,1) = (1 - bsf(i,1)) * s(i);
        stretch(i,1) = s(i);
        % fprintf('%.10f \t %.10f \t %.10f \n', force(i,1), bsf(i,1), stretch(i))
        % fprintf('%f \n', s0/s(i)) 
        
    elseif s(i) > sc
        
        bsf(i,1) = 1;
        force(i,1) = (1 - bsf(i,1)) * s(i);
        stretch(i,1) = s(i);
        
    end

    % =============================
    %           Bilinear
    % =============================
    
%     if (s0 < s(i)) && (s(i) <= sc)
% 
%         bsf(i,1) = ( (s(i) - s0) / s(i) ) * ( sc / (sc - s0) );
%         force(i,1) = (1 - bsf(i,1)) * s(i);
%         stretch(i,1) = s(i);
% 
%     end

%     if s(i) > s0 && s(i) <= s1
%         
%         bsf(i,1) = (s(i) - s0) * ( (1 - beta) / (s1 - s0) );
%         force(i,1) = (1 - bsf(i,1)) * s(i);
%         stretch(i,1) = s(i);
%         
%     elseif s(i) > s1 && s(i) <= sc
%         
%         bsf(i,1) = (1 - beta) + ( (s(i) - s1) * ( beta / (sc - s1) ) );
%         force(i,1) = (1 - bsf(i,1)) * s(i);
%         stretch(i,1) = s(i);
%         
%     elseif s(i) > sc
%         
%         bsf(i,1) = 1;
%         force(i,1) = (1 - bsf(i,1)) * s(i);
%         stretch(i,1) = s(i);
%         
%     end
    
end


plot(stretch, force , 'LineWidth', 2)
% plot(1:size(bsf,1), bsf , 'LineWidth', 2)
% hold on
% xline(s0)
% xline(s1)
% xline(sc)
% yline(1 - beta)
% yline(1)
xlabel('stretch')
% ylabel('bond softening factor')
ylabel('force')