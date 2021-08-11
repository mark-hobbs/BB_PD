function plotvariablehistory(nTimeSteps,variablehistory,variablelabel)
% plotvariablehistory - Plot a defined variable against time

time(:,1) = 1 : nTimeSteps;

figure
plot(time, variablehistory)
xlabel('Time step') 
ylabel(variablelabel)
str = sprintf('%s against Time', variablelabel);
title(str)

end 