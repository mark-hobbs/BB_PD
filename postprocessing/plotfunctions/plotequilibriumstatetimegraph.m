
function plotequilibriumstatetimegraph(NT,equilibrium)
% Plot Equilibrium State-Time graph for selected node
time(:,1)=1:NT;

figure;
plot(time,equilibrium)
xlabel('Time step') 
ylabel('Equilibrium state')

end 