
function plotdisplacementtimegraph(NT,nodeDisplacement)
% Plot Displacement-Time graph for selected node
time(:,1)=1:NT;

figure;
plot(time,nodeDisplacement)
xlabel('Time step') 
ylabel('Displacement (m)')

end 