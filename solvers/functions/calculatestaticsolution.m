function []=calculatestaticsolution()
% Calculate the static solution by setting the acceleration term in the
% peridynamic EOM to 0, building the global stiffness matrix, and then
% solving the set of linear equations in the form Ku=F (Ax=b).

% Incremental-iterative procedure. See the following links for more
% details: 31.1.1 Iterative Procedures and 31.1.5 Incremental Procedures
% https://dianafea.com/manuals/d944/Analys/node392.html#sec:iterat
% https://dianafea.com/manuals/d944/Analys/node396.html

%% Load step for-loop

    for iLoadStep=1:10

        []=newtonraphson();

    end

end


