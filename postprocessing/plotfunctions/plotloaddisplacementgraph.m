function plotLoadDisplacementGraph(nodeDisplacement,stressHistory)
% Plot load-displacement graph

figure;
plot(nodeDisplacement,stressHistory,'-o','MarkerSize',4)
xlabel('Displacement (m)')
ylabel('Load (N)')

end 