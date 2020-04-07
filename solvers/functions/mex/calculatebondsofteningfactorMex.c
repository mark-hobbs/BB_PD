
/*
 * ==========================================================================================================================================
 * calculatebondsofteningfactorMex.c 
 * Calculate bond softening factor for concrete bonds in a 3D peridynamic simulation
 * 
 * [] = calculatebondsofteningfactorMex(stretch, linearElasticLimit, criticalStretchConcrete, flagBondSoftening, bondSofteningFactor, BONDTYPE)
 * 
 * Compile Linux:
 * module load gcc-6.3.0-gcc-4.8.5-2e3eatd
 * mex calculatebondsofteningfactorMex.c CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"
 *  
 * Compile Windows:
 * mex COMPFLAGS="$COMPFLAGS /openmp" calculatebondsofteningfactorMex.c
 * 
 * ==========================================================================================================================================
 */

#include "mex.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

// Computational routine
void calculatebondsofteningfactor(double *stretch, double linearElasticLimit, double criticalStretchConcrete, double *flagBondSoftening, double *bondSofteningFactor, double *BONDTYPE, int nBonds)
{
    int kBond;

    #pragma omp parallel for shared(stretch, linearElasticLimit, BONDTYOE, flagBondSoftening, bsf, criticalStretchConcrete, bondSofteningFactor) private(kBond)
    for (kBond = 0; kBond < nBonds; kBond++)
    {

        if (stretch[kBond] > linearElasticLimit && BONDTYPE[kBond] == 0) // Concrete Bond BONDTYPE == 0 
        {

            flagBondSoftening[kBond] = 1;   // flag == 1 when a concrete bond has exceeded the linear elastic limit

        }

        if (flagBondSoftening[kBond] == 1) // TODO: bsf isn't defined anywhere
        {

            bsf[kBond] = ((stretch[kBond] - linearElasticLimit) / stretch[kBond]) * (criticalStretchConcrete / (criticalStretchConcrete - linearElasticLimit));

        }

        if ( bsf[kBond] > bondSofteningFactor[kBond] ) { bondSofteningFactor[kBond] = bsf[kBond]; }             // bond softening factor can only increase (damage is irreversible)
        if ( bondSofteningFactor[kBond] > 1 ) { bondSofteningFactor[kBond] = 1; }                               // bond softening factor should not exceed 1 
        if ( bondSofteningFactor[kBond] != bondSofteningFactor[kBond] ) { bondSofteningFacrtor[kBond] = 0.0; }  // Dividing by 0 will produce NaN. NaN will compare false to everything, including itself. This line replaces NaN with 0.0

     
    }


}

// Gateway routine
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

    // Declare variables
    int nBonds;
    double *stretch_ptr, lel, csc, *fbs_ptr, *bsf_ptr, *BT_ptr;

    // Check for proper number of input and output arguments
    if (nrhs != 6)
    {
        mexErrMsgTxt("Six input arguments required \n");
    }

    nBonds = mxGetM(prhs[0]);         // Number of rows in stretch

    stretch_ptr = mxGetPr(prhs[0]);   // stretch pointer
    lel = mxGetScalar(prhs[1]);       // linear elastic limit
    csc = mxGetScalar(prhs[2]);       // concrete critical stretch
    fbs_ptr = mxGetPr(prhs[3]);       // flag bond softening pointer
    bsf_ptr = mxGetPr(prhs[4]);       // bond softening factor pointer
    BT_ptr = mxGetPr(prhs[5]);        // bond type pointer

    calculatebondsofteningfactor(stretch_ptr, lel, csc, fbs_ptr, bsf_ptr, BT_ptr, nBonds);
}
