
/*
 * ==========================================================================================================================================
 * calculatebsfexponentialMex.c 
 * Calculate bond softening factor using a decaying exponential model for concrete bonds in a 3D peridynamic simulation
 * 
 * [] = calculatebsfexponentialMex(stretch, s0, sc, k, alpha, bondSofteningFactor, BONDTYPE, flagBondSoftening)
 * 
 * Compile Linux:
 * module load gcc-6.3.0-gcc-4.8.5-2e3eatd
 * mex calculatebsfexponentialMex.c CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"
 *  
 * Compile Windows:
 * mex COMPFLAGS="$COMPFLAGS /openmp" calculatebsfexponentialMex.c
 * 
 * ==========================================================================================================================================
 */

#include "mex.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

// Computational routine
void calculatebsfexponential(double *stretch, double *s0, double *sc, double k, double alpha, double *bsf, double *bondSofteningFactor, double *BONDTYPE, double *flagBondSoftening, int nBonds)
{
    int kBond;
    double numerator, denominator, residual;

    #pragma omp parallel for default(none) shared(nBonds, stretch, s0, sc, k, alpha, bsf, bondSofteningFactor, BONDTYPE, flagBondSoftening) private(kBond, numerator, denominator, residual)
    for (kBond = 0; kBond < nBonds; kBond++)
    {

        if ( BONDTYPE[kBond] == 0)  // only consider concrete bonds
        {

            if (s0[kBond] < stretch[kBond] && stretch[kBond] <= sc[kBond])
            {

                flagBondSoftening[kBond] = 1;   // flag == 1 when a concrete bond has exceeded the linear elastic limit

                numerator = 1 - exp(-k * (stretch[kBond] - s0[kBond]) / (sc[kBond] - s0[kBond]));
                denominator = 1 - exp(-k);
                residual = alpha * (1 - (stretch[kBond] - s0[kBond]) / (sc[kBond] - s0[kBond]));
                bsf[kBond] = 1 - (s0[kBond] / stretch[kBond]) * ((1 - (numerator / denominator)) + residual) / (1 + alpha); 

            }
            else if ( stretch[kBond] > sc[kBond] )
            {

                bsf[kBond] = 1;
            
            }

            if ( bsf[kBond] > bondSofteningFactor[kBond] ) { bondSofteningFactor[kBond] = bsf[kBond]; }            // bond softening factor can only increase (damage is irreversible)          
            if ( bondSofteningFactor[kBond] > 1 ) { bondSofteningFactor[kBond] = 1; }                              // bond softening factor should not exceed 1 
            if ( bondSofteningFactor[kBond] != bondSofteningFactor[kBond] ) { bondSofteningFactor[kBond] = 0.0; }  // Dividing by 0 will produce NaN. NaN will compare false to everything, including itself. This line replaces NaN with 0.0
      
        }
        
     
    }


}

// Gateway routine
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

    // Declare variables
    int nBonds;
    double *stretch_ptr, *s0_ptr, *sc_ptr, k, alpha, *bsf_ptr, *bondSofteningFactor_ptr, *BT_ptr, *fbs_ptr;

    // Check for proper number of input and output arguments
    if (nrhs != 9)
    {
        mexErrMsgTxt("Nine input arguments required \n");
    }

    nBonds = mxGetM(prhs[0]);                          // Number of rows in stretch

    stretch_ptr = mxGetPr(prhs[0]);                    // stretch pointer
    s0_ptr = mxGetPr(prhs[1]);                         // linear elastic limit
    sc_ptr = mxGetPr(prhs[2]);                         // concrete critical stretch
    k = mxGetScalar(prhs[3]);                          // rate of decay
    alpha = mxGetScalar(prhs[4]);                      // residual bond force factor
    bsf_ptr = mxGetPr(prhs[5]);                        // bsf pointer (array initialised to zero for every time step)
    bondSofteningFactor_ptr = mxGetPr(prhs[6]);        // bond softening factor pointer
    BT_ptr = mxGetPr(prhs[7]);                         // bond type pointer
    fbs_ptr = mxGetPr(prhs[8]);                        // flag bond softening pointer
       

    calculatebsfexponential(stretch_ptr, s0_ptr, sc_ptr, k, alpha, bsf_ptr, bondSofteningFactor_ptr, BT_ptr, fbs_ptr, nBonds);
}
