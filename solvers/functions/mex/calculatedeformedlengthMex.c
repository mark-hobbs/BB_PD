
/*
 * ==========================================================================================================================================
 * calculatedeformedlengthMex.c 
 * Calculate deformed length of bonds in a 3D peridynamic simulation
 * 
 * [] = calculatedeformedlengthMex(deformedCoordinates, BONDLIST, undeformedLength, deformedLength, deformedX, deformedY, deformedZ, stretch)
 * 
 * Compile Linux:
 * module load gcc-6.3.0-gcc-4.8.5-2e3eatd
 * mex calculatedeformedlengthMex.c CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"
 *  
 * Compile Windows:
 * mex COMPFLAGS="$COMPFLAGS /openmp" calculatedeformedlengthMex.c
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
void calculatedeformedlength(double *deformedCoordinates, double *bl_ptr, double *undeformedLength, int nBonds, int nNodes, double *length_ptr, double *deformedX, double *deformedY, double *deformedZ, double *stretch)
{
    int kBond, nodei, nodej;

#pragma omp parallel for default(none) shared(bl_ptr, nNodes, nBonds, deformedX, deformedY, deformedZ, deformedCoordinates, length_ptr, stretch, undeformedLength) private(kBond, nodei, nodej)
    for (kBond = 0; kBond < nBonds; kBond++)
    {
        nodei = *(bl_ptr + kBond);              // BONDLIST[kBond][0];
        nodej = *(bl_ptr + nBonds + kBond);     // BONDLIST[kBond][1];

        deformedX[kBond] = deformedCoordinates[nodej - 1] - deformedCoordinates[nodei - 1];
        deformedY[kBond] = deformedCoordinates[nodej + nNodes - 1] - deformedCoordinates[nodei + nNodes - 1];
        deformedZ[kBond] = deformedCoordinates[nodej + nNodes * 2 - 1] - deformedCoordinates[nodei + nNodes * 2 - 1];

        length_ptr[kBond] = sqrt(deformedX[kBond] * deformedX[kBond] + deformedY[kBond] * deformedY[kBond] + deformedZ[kBond] * deformedZ[kBond]);

        stretch[kBond] = (length_ptr[kBond] - undeformedLength[kBond]) / undeformedLength[kBond];
    }


}

// Gateway routine
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

    // Declare variables
    int nNodes, nBonds, NOD;
    double *defCo_ptr, *bl_ptr, *ul_ptr, *length_ptr, *defx_ptr, *defy_ptr, *defz_ptr, *stretch_ptr;

    // Check for proper number of input and output arguments
    if (nrhs != 8)
    {
        mexErrMsgTxt("Eight input arguments required \n");
    }

    nNodes = mxGetM(prhs[0]); // Number of rows in deformedCoordinates
    nBonds = mxGetM(prhs[1]); // Number of rows in BONDLIST (mxGetN to find the number of columns)
    NOD = 3;

    defCo_ptr = mxGetPr(prhs[0]);   // deformed coordinates pointer
    bl_ptr = mxGetPr(prhs[1]);      // bond list pointer
    ul_ptr = mxGetPr(prhs[2]);      // undeformed length pointer
    length_ptr = mxGetPr(prhs[3]);  // deformed length pointer
    defx_ptr = mxGetPr(prhs[4]);    // deformedX pointer
    defy_ptr = mxGetPr(prhs[5]);    // deformedY pointer
    defz_ptr = mxGetPr(prhs[6]);    // deformedZ pointer
    stretch_ptr = mxGetPr(prhs[7]); // stretch pointer

    // printf("Memory address: \t %p \n", defCo_ptr);  // Check the memory address of pointer

    calculatedeformedlength(defCo_ptr, bl_ptr, ul_ptr, nBonds, nNodes, length_ptr, defx_ptr, defy_ptr, defz_ptr, stretch_ptr);
}
