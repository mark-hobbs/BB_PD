
/*
 * ==========================================================================================================================================
 * calculatenodalforcesMex.c 
 * Calculate nodal forces in a 3D peridynamic simulation - serial code
 * 
 * [] = calculatenodalforcesMex(BONDLIST, nodalForce, bForceX, bForceY, bForceZ)
 * 
 * ==========================================================================================================================================
 */

#include "mex.h"
#include "matrix.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// Computational routine
void calculatenodalforces(int nBonds, int nNodes, double *bl_ptr, double *nodalForce, double *bForceX, double *bForceY, double *bForceZ)
{

    // Remember that nodal forces need to be initialised for every time step - This is currently performed within
    // the MATLAB code

    int kBond, nodei, nodej;

    for (kBond = 0; kBond < nBonds; kBond++)
    {

        nodei = *(bl_ptr + kBond);          // BONDLIST[kBond][0];
        nodej = *(bl_ptr + nBonds + kBond); // BONDLIST[kBond][1];

        // X-component
        nodalForce[nodei - 1] += bForceX[kBond];
        nodalForce[nodej - 1] -= bForceX[kBond];

        // Y-component
        nodalForce[nodei + nNodes - 1] += bForceY[kBond];
        nodalForce[nodej + nNodes - 1] -= bForceY[kBond];

        // Z-component
        nodalForce[nodei + nNodes * 2 - 1] += bForceZ[kBond];
        nodalForce[nodej + nNodes * 2 - 1] -= bForceZ[kBond];
    }

}

// Gateway routine
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

    // Declare variables
    int nNodes, nBonds, NOD;
    double *bl_ptr, *nf_ptr, *bfX_ptr, *bfY_ptr, *bfZ_ptr;

    // Check for proper number of input and output arguments
    if (nrhs != 5)
    {
        mexErrMsgTxt("Five input arguments required \n");
    }

    nNodes = mxGetM(prhs[1]); // Number of rows in nodalForce
    nBonds = mxGetM(prhs[0]); // Number of rows in BONDLIST
    NOD = 3;

    bl_ptr = mxGetPr(prhs[0]);  // bond list pointer
    nf_ptr = mxGetPr(prhs[1]);  // nodal force pointer
    bfX_ptr = mxGetPr(prhs[2]); // bond force X-component pointer
    bfY_ptr = mxGetPr(prhs[3]); // bond force Y-component pointer
    bfZ_ptr = mxGetPr(prhs[4]); // bond force Z-component pointer

    calculatenodalforces(nBonds, nNodes, bl_ptr, nf_ptr, bfX_ptr, bfY_ptr, bfZ_ptr);
}
