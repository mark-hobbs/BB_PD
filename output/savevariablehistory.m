function [variablehistory] = savevariablehistory(nTimeSteps,iTimeStep,variable,variablehistory)
% savevariablehistory - this function saves a defined variable at
% every time step

if iTimeStep == 1
    variablehistory = zeros(nTimeSteps, 1);
end

variablehistory(iTimeStep,1) = variable;

end

