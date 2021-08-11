% ===============================
%        Trilinear model
% ===============================

s = [0 : 0.0000001 : 1E-2]';
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

a = (s1 - s0*beta) / (s1 - s0);
b1 = (sc - s1*beta);
b2 = (sc - s1);
b = b1/b2;

gradient_s0s1 = ((1 - beta) * s0) / (s1 - s0);
gradient_s1sc = (beta * s0) / (sc - s1); 

for i = 1 : size(s,1)
    
    
    % =============================
    %           Trilinear
    % =============================
    % See the following papers for the equations that capture the damage variable:
    % A Damaged Constitutive Model for Rock under Dynamic and High Stress State - hindawi.com/journals/sv/2017/8329545/
    % Appropriate shape of cohesive zone model for delamination propagation in ENF specimens with R-curve effects - sciencedirect.com/science/article/pii/S0167844216302671
    
    if s(i) < s0 
        
        bsf(i,1) = 0;
        force(i,1) = (1 - bsf(i,1)) * s(i);
        stretch(i,1) = s(i);
    
    elseif s(i) > s0 && s(i) <= s1
        
        bsf(i,1) = 1 - ( (eta - beta) / (eta - 1) * (s0 / s(i)) ) + ( (1 - beta) / (eta - 1) ); 
        force(i,1) = (1 - bsf(i,1)) * s(i);
        stretch(i,1) = s(i);

    elseif s(i) > s1 && s(i) <= sc
        
        bsf(i,1) = 1 - ( (s0 * beta) / s(i) ) * ( (sc - s(i)) / (sc - s1) );
        force(i,1) = (1 - bsf(i,1)) * s(i);
        stretch(i,1) = s(i);
        
    elseif s(i) > sc
        
        bsf(i,1) = 1;
        force(i,1) = (1 - bsf(i,1)) * s(i);
        stretch(i,1) = s(i);
        
    end

     
end

plot(stretch, force , 'LineWidth', 2)
xlabel('stretch')
ylabel('force')

