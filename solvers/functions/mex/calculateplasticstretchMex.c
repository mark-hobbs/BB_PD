
/*
 * ==========================================================================================================================================
 * calculatplasticstretchMex.c 
 * Calculate plastic stretch of steel bonds in a 3D peridynamic simulation
 * 
 * [] = calculateplasticstretchMex(stretchPlastic,yieldingLength,flagBondYield,stretch,BONDTYPE,deformedLength)
 * 
 * Compile Linux:
 * module load gcc-6.3.0-gcc-4.8.5-2e3eatd
 * mex calculateplasticstretchMex.c CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"
 *  
 * Compile Windows:
 * mex COMPFLAGS="$COMPFLAGS /openmp" calculateplasticstretchMex.c
 * 
 * ==========================================================================================================================================
 */

#include "mex.h"
#include "matrix.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

// Computational routine
void calculateplasticstretch(double *stretchPlastic, double *yieldingLength, double *flagBondYield, double *stretch, double *BONDTYPE, double *deformedLength, int nBonds)
{
    int kBond;
    double yieldStretchSteel = 0.002;

    #pragma omp parallel for default(none) shared(nBonds, BONDTYPE, stretch, yieldStretchSteel, flagBondYield, yieldingLength, deformedLength, stretchPlastic) private(kBond)
    for (kBond = 0; kBond < nBonds; kBond++)
    {

        if (BONDTYPE[kBond] == 2 && stretch[kBond] > yieldStretchSteel && flagBondYield == 0)
        {

            yieldingLength[kBond] = deformedLength[kBond];
            flagBondYield[kBond] = 1;

        }

        if (flagBondYield == 1)
        {

            stretchPlastic[kBond] = (deformedLength[kBond] - yieldingLength[kBond]) / yieldingLength[kBond];

        }

     
    }


}

// Gateway routine
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

    // Declare variables
    int nBonds;
    double *sp_ptr, *yl_ptr, *ul_ptr, *stretch_ptr, *bt_ptr, *dl_ptr;

    // Check for proper number of input and output arguments
    if (nrhs != 6)
    {
        mexErrMsgTxt("Six input arguments required \n");
    }

    nBonds = mxGetM(prhs[0]);       // Number of rows in stretchPlastic

    sp_ptr = mxGetPr(prhs[0]);      // stretch plastic pointer
    yl_ptr = mxGetPr(prhs[1]);      // yielding length pointer
    ul_ptr = mxGetPr(prhs[2]);      // flag bond yield pointer
    stretch_ptr = mxGetPr(prhs[3]); // stretch pointer
    bt_ptr = mxGetPr(prhs[4]);      // bond type pointer
    dl_ptr = mxGetPr(prhs[5]);      // deformed length pointer

    calculateplasticstretch(sp_ptr, yl_ptr, ul_ptr, stretch_ptr, bt_ptr, dl_ptr, nBonds);
}
