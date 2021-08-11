
/*
 * ==========================================================================================================================================
 * calculatebondforcesMex.c 
 * Calculate bond forces in a 3D peridynamic simulation
 * 
 * [] = calculatebondforcesMex(bForceX,bForceY,bForceZ,fail,deformedX,deformedY,deformedZ,deformedLength,stretch,stretchPlastic,BONDSTIFFNESS,cellVolume,VOLUMECORRECTIONFACTORS,bondSofteningFactor)
 * 
 * Compile Linux:
 * module load gcc-6.3.0-gcc-4.8.5-2e3eatd
 * mex calculatebondforcesMex.c CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"
 *  
 * Compile Windows:
 * mex COMPFLAGS="$COMPFLAGS /openmp" calculatebondforcesMex.c
 * 
 * ==========================================================================================================================================
 */

#include "mex.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

// Computational routine
void calculatebondforces(double *bForceX, double *bForceY, double *bForceZ, double *fail, double *deformedX, double *deformedY, double *deformedZ, double *deformedLength, double *stretch, double *stretchPlastic, double *BONDSTIFFNESS, double cellVolume, double *VOLUMECORRECTIONFACTORS, double *bondSofteningFactor, int nBonds)
{
    int kBond;

#pragma omp parallel for default(none) shared(nBonds, bForceX, bForceY, bForceZ, fail, BONDSTIFFNESS, bondSofteningFactor, stretch, stretchPlastic, cellVolume, VOLUMECORRECTIONFACTORS, deformedX, deformedY, deformedZ, deformedLength) private(kBond)
    for (kBond = 0; kBond < nBonds; kBond++)
    {
     
        bForceX[kBond] = fail[kBond] * BONDSTIFFNESS[kBond] * (1 - bondSofteningFactor[kBond]) * (stretch[kBond] - stretchPlastic[kBond]) * cellVolume * VOLUMECORRECTIONFACTORS[kBond] * (deformedX[kBond] / deformedLength[kBond]); 
        bForceY[kBond] = fail[kBond] * BONDSTIFFNESS[kBond] * (1 - bondSofteningFactor[kBond]) * (stretch[kBond] - stretchPlastic[kBond]) * cellVolume * VOLUMECORRECTIONFACTORS[kBond] * (deformedY[kBond] / deformedLength[kBond]);
        bForceZ[kBond] = fail[kBond] * BONDSTIFFNESS[kBond] * (1 - bondSofteningFactor[kBond]) * (stretch[kBond] - stretchPlastic[kBond]) * cellVolume * VOLUMECORRECTIONFACTORS[kBond] * (deformedZ[kBond] / deformedLength[kBond]);

        if( bForceX[kBond] != bForceX[kBond] ) { bForceX[kBond] = 0.0; } // Dividing by 0 will produce NaN. NaN will compare false to everything, including itself. This line replaces NaN with 0.0
        if( bForceY[kBond] != bForceY[kBond] ) { bForceY[kBond] = 0.0; }
        if( bForceZ[kBond] != bForceZ[kBond] ) { bForceZ[kBond] = 0.0; }

    }


}

// Gateway routine
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

    // Declare variables
    int nBonds;
    double *bfx_ptr, *bfy_ptr, *bfz_ptr, *fail_ptr, *defx_ptr, *defy_ptr, *defz_ptr, *dl_ptr, *stretch_ptr, *sp_ptr, *bs_ptr, cv, *vcf_ptr, *bsf_ptr;

    // Check for proper number of input and output arguments
    if (nrhs != 14)
    {
        mexErrMsgTxt("Fourteen input arguments required \n");
    }

    nBonds = mxGetM(prhs[0]);       // Get number of rows in bForceX

    bfx_ptr = mxGetPr(prhs[0]);     // bForceX pointer
    bfy_ptr = mxGetPr(prhs[1]);     // bForceY pointer
    bfz_ptr = mxGetPr(prhs[2]);     // bForceZ pointer
    fail_ptr = mxGetPr(prhs[3]);    // fail pointer
    defx_ptr = mxGetPr(prhs[4]);    // deformedX pointer
    defy_ptr = mxGetPr(prhs[5]);    // deformedY pointer
    defz_ptr = mxGetPr(prhs[6]);    // deformedZ pointer
    dl_ptr = mxGetPr(prhs[7]);      // deformed length pointer
    stretch_ptr = mxGetPr(prhs[8]); // stretch pointer
    sp_ptr = mxGetPr(prhs[9]);      // stretch plastic pointer
    bs_ptr = mxGetPr(prhs[10]);     // bond stiffness pointer
    cv = mxGetScalar(prhs[11]);     // cell volume 
    vcf_ptr = mxGetPr(prhs[12]);    // volume correction factor pointer
    bsf_ptr = mxGetPr(prhs[13]);    // bond softening factor pointer

    calculatebondforces(bfx_ptr, bfy_ptr, bfz_ptr, fail_ptr, defx_ptr, defy_ptr, defz_ptr, dl_ptr, stretch_ptr, sp_ptr, bs_ptr, cv, vcf_ptr, bsf_ptr, nBonds);

}
