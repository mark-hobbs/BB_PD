
/*
 * ==========================================================================================================================================
 * calculatebondfailureMex.c 
 * Determine if a bond has failed
 * 
 * [fail] = calculatebondfailureMex(fail, failureFunctionality, BONDTYPE, stretch, criticalStretchConcrete, criticalStretchSteel)
 * 
 * Compile Linux:
 * module load gcc-6.3.0-gcc-4.8.5-2e3eatd
 * mex calculatebondfailureMex.c CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"
 *  
 * Compile Windows:
 * mex COMPFLAGS="$COMPFLAGS /openmp" calculatebondfailureMex.c
 * 
 * ==========================================================================================================================================
 */

#include "mex.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

// Computational routine
void calculatebondfailure(double *fail, double failureFunctionality, double *BONDTYPE, double *stretch, double criticalStretchConcrete, double criticalStretchSteel, int nBonds)
{
    int kBond;

    #pragma omp parallel for shared(fail, BONDTYPE, stretch, criticalStretchConcrete, failureFunctionality, criticalStretchSteel) private(kBond)
    for (kBond = 0; kBond < nBonds; kBond++)
    {

        // fail = 0 when a bond has failed

        if ( fail[kBond] == 1 && BONDTYPE[kBond] == 0 && stretch[kBond] > criticalStretchConcrete ) { fail[kBond] = failureFunctionality }       // concrete bond
        if ( fail[kBond] == 1 && BONDTYPE[kBond] == 1 && stretch[kBond] > 3 * criticalStretchConcrete ) { fail[kBond] = failureFunctionality }   // concrete-steel interface bond
        if ( fail[kBond] == 1 && BONDTYPE[kBond] == 2 && stretch[kBond] > criticalStretchSteel ) { fail[kBond] = failureFunctionality }          // steel bond
        
     
    }


}

// Gateway routine
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

    // Declare variables
    int nBonds;
    double *fail_ptr, ff, *BT_ptr, *stretch_ptr, csc, css;

    // Check for proper number of input and output arguments
    if (nrhs != 6)
    {
        mexErrMsgTxt("Six input arguments required \n");
    }

    nBonds = mxGetM(prhs[0]);           // Number of rows in fail

    fail_ptr = mxGetPr(prhs[0]);        // fail pointer
    ff = mxGetScalar(prhs[1]);          // failure functionality
    BT_ptr = mxGetPr(prhs[2]);          // bond type pointer
    stretch_ptr = mxGetPr(prhs[3]);     // stretch pointer
    csc = mxGetScalar(prhs[4]);         // critical stretch concrete
    css = mxGetScalar(prhs[5]);         // critical stretch steel


    calculatebondfailure(fail_ptr, ff, BT_ptr, stretch_ptr, csc, css, nBonds);
}
