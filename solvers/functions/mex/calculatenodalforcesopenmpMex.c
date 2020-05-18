
/*
 * ==========================================================================================================================================
 * calculatenodalforcesopenmpMex.c 
 * Calculate nodal forces in a 3D peridynamic simulation
 * 
 * [] = calculatenodalforcesopenmpMex(BONDLIST, nodalForce, bForceX, bForceY, bForceZ, nodalForceX, nodalForceY, nodalForceZ)
 * 
 * Compile Linux:
 * module load gcc-6.3.0-gcc-4.8.5-2e3eatd
 * mex calculatenodalforcesopenmpMex.c CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"
 *  
 * Compile Windows:
 * mex COMPFLAGS="$COMPFLAGS /openmp" calculatenodalforcesopenmpMex.c
 * 
 * ==========================================================================================================================================
 */

#include "mex.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

// Row/Col major order in mex function
// https://www.mathworks.com/matlabcentral/answers/89945-row-col-major-order-in-mex-function

// Computational routine
void calculatenodalforces(int nBonds, int nNodes, double *bl_ptr, double *nodalForce, double *bForceX, double *bForceY, double *bForceZ, double *nfSharedX, double *nfSharedY, double *nfSharedZ)
{

    // Remember that nodal forces need to be initialised for every time step - This is currently performed within
    // the MATLAB code

    int kBond, kNode, nodei, nodej, nThreads, iThread, kThread;

    // See the following forum for more details; http://forum.openmp.org/forum/viewtopic.php?f=3&t=1693

#pragma omp parallel shared(bl_ptr, nBonds, nNodes, nodalForce, bForceX, bForceY, bForceZ, nfSharedX, nfSharedY, nfSharedZ) private(kBond, kNode, kThread, nodei, nodej, nThreads, iThread)
    {
        
        nThreads = omp_get_num_threads();   // Number of threads
        iThread = omp_get_thread_num();     // Thread rank (numbering starts at 0, range [0 - (nThreads-1)])

        // Allocate a temporary shared array with dimensions nNodes x nThreads (allocating a temporary array for every iteration will be slow)
        // Better performance can be achieved by rounding the size of each threads chunk to a multiple of the system's memory page size

#pragma omp for
        for (kBond = 0; kBond < nBonds; kBond++)
        {
            nodei = *(bl_ptr + kBond);          // BONDLIST[kBond][0];
            nodej = *(bl_ptr + nBonds + kBond); // BONDLIST[kBond][1];

            nfSharedX[(nodei - 1) + (nNodes * iThread)] += bForceX[kBond];
            nfSharedX[(nodej - 1) + (nNodes * iThread)] -= bForceX[kBond];

            nfSharedY[(nodei - 1) + (nNodes * iThread)] += bForceY[kBond];
            nfSharedY[(nodej - 1) + (nNodes * iThread)] -= bForceY[kBond];

            nfSharedZ[(nodei - 1) + (nNodes * iThread)] += bForceZ[kBond];
            nfSharedZ[(nodej - 1) + (nNodes * iThread)] -= bForceZ[kBond];


        }

    
#pragma omp for
        for (kNode = 0; kNode < nNodes; kNode++)
        {
            for (kThread = 0; kThread < nThreads; kThread++)
            {

                nodalForce[kNode] += nfSharedX[kNode + (nNodes * kThread)];                     // nodal force x-component
                nodalForce[kNode + nNodes] += nfSharedY[kNode + (nNodes * kThread)];            // nodal force y-component
                nodalForce[kNode + (nNodes * 2)] += nfSharedZ[kNode + (nNodes * kThread)];      // nodal force z-component

            }

        }
    }
    

}

// Gateway routine
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

    // Declare variables
    int nNodes, nBonds, NOD;
    double *bl_ptr, *nf_ptr, *bfX_ptr, *bfY_ptr, *bfZ_ptr, *nfX_ptr, *nfY_ptr, *nfZ_ptr;

    // Check for proper number of input and output arguments
    if (nrhs != 8)
    {
        mexErrMsgTxt("Eight input arguments required \n");
    }

    nNodes = mxGetM(prhs[1]); // Number of rows in nodalForce
    nBonds = mxGetM(prhs[0]); // Number of rows in BONDLIST
    NOD = 3;

    bl_ptr = mxGetPr(prhs[0]);     // bond list pointer
    nf_ptr = mxGetPr(prhs[1]);     // nodal force pointer
    bfX_ptr = mxGetPr(prhs[2]);    // bond force X-component pointer
    bfY_ptr = mxGetPr(prhs[3]);    // bond force Y-component pointer
    bfZ_ptr = mxGetPr(prhs[4]);    // bond force Z-component pointer
    nfX_ptr = mxGetPr(prhs[5]);    // nodal force X-component pointer (nNodes x nThreads)
    nfY_ptr = mxGetPr(prhs[6]);    // nodal force Y-component pointer (nNodes x nThreads)
    nfZ_ptr = mxGetPr(prhs[7]);    // nodal force Z-component pointer (nNodes x nThreads)

    
    calculatenodalforces(nBonds, nNodes, bl_ptr, nf_ptr, bfX_ptr, bfY_ptr, bfZ_ptr, nfX_ptr, nfY_ptr, nfZ_ptr);

}
