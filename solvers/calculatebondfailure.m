function [fail] = calculatebondfailure(fail,failureFunctionality,BONDTYPE,stretch,criticalStretchConcrete,criticalStretchSteel)
% Determine if a bond has failed, make use of logical indexing

% Determine if a bond has failed (failure == 1 when failure functionality
% is turned off)
fail(fail == 1 & BONDTYPE == 0 & stretch > criticalStretchConcrete) = failureFunctionality;         % Deactivate concrete bond if stretch exceeds critical stretch   Bond has failed = 0 
fail(fail == 1 & BONDTYPE == 1 & stretch > 1000 * criticalStretchConcrete) = failureFunctionality;     % EMU user manual recommends that the critical stretch and bond force are multiplied by a factor of 3 for concrete to steel bonds 
fail(fail == 1 & BONDTYPE == 2 & stretch > criticalStretchSteel) = 1;%failureFunctionality;         % Deactivate steel bond if stretch exceeds critical stretch (need to include yield stretch)

end

