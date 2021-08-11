 

prompt = '\nCompile on Linux [L], Windows [W] or macOS [M]? L/W/M: ';
str = input(prompt,'s');

if str == 'L'
    
    % =========================================================================
    %                          Compile on Linux
    % =========================================================================

    fprintf('Ensure that the following compiler is loaded: \n')
    fprintf('\t module load gcc-6.3.0-gcc-4.8.5-2e3eatd \n')

    fprintf('\nBuild calculatedeformedlengthMex.c \n')
    mex calculatedeformedlengthMex.c CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"

    fprintf('\nBuild calculatebsfexponentialMex.c \n')
    mex calculatebsfexponentialMex.c CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"

    fprintf('\nBuild calculatebondforcesMex.c \n')
    mex calculatebondforcesMex.c CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"

    fprintf('\nBuild calculatenodalforcesopenmpMex.c \n')
    mex calculatenodalforcesopenmpMex.c CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"

    fprintf('\nBuild timeintegrationeulercromerMex.c \n')
    mex timeintegrationeulercromerMex.c CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"

elseif str == 'W'
    
    % =========================================================================
    %                          Compile on Windows
    % =========================================================================

    fprintf('\nBuild calculatedeformedlengthMex.c \n')
    mex COMPFLAGS="$COMPFLAGS /openmp" calculatedeformedlengthMex.c

    fprintf('\nBuild calculatebsfexponentialMex.c \n')
    mex COMPFLAGS="$COMPFLAGS /openmp" calculatebsfexponentialMex.c

    fprintf('\nBuild calculatebondforcesMex.c \n')
    mex COMPFLAGS="$COMPFLAGS /openmp" calculatebondforcesMex.c

    fprintf('\nBuild calculatenodalforcesopenmpMex.c \n')
    mex COMPFLAGS="$COMPFLAGS /openmp" calculatenodalforcesopenmpMex.c

    fprintf('\nBuild timeintegrationeulercromerMex.c \n')
    mex COMPFLAGS="$COMPFLAGS /openmp" timeintegrationeulercromerMex.c
   
elseif str == 'M'
    
    % =========================================================================
    %                          Compile on Mac OS
    % =========================================================================
    
    fprintf("\nSee the following link for details on using OpenMP with Mex files on macOS: \n")
    fprintf("https://stackoverflow.com/questions/37362414/openmp-with-mex-in-matlab-on-mac \n")
    
    fprintf("\nThe number of physical cores must be defined in calculatenodalforcesopenmpMex.c \n")
    fprintf("\t- this is to avoid issues with hyperthreading and OpenMP \n")

    fprintf('\nBuild calculatedeformedlengthMex.c \n')
    mex calculatedeformedlengthMex.c

    fprintf('\nBuild calculatebsfexponentialMex.c \n')
    mex calculatebsfexponentialMex.c

    fprintf('\nBuild calculatebondforcesMex.c \n')
    mex calculatebondforcesMex.c

    fprintf('\nBuild calculatenodalforcesopenmpMex.c \n')
    mex calculatenodalforcesopenmpMex.c

    fprintf('\nBuild timeintegrationeulercromerMex.c \n')
    mex timeintegrationeulercromerMex.c

else
    
   fprintf('ERROR: enter a valid string \n')
    
end

clear prompt str