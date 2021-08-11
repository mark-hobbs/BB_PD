
/*
 * ==========================================================================================================================================
 * timeintegrationeulercromerMex_clang.c 
 * Time integration using an Euler-Cromer scheme for a three-dimensional peridynamic body
 * 
 * This code is optimised for compilation with Clang on macOS. The nested for-loop that iterates over the spatial dimensions has
 * been removed. This produces a 10 - 20% speedup. Note that the original code compiled with icc (Intel C Compiler) is
 * approximately 10x faster.
 * 
 * 
 * [] = timeintegrationeulercromerMex_clang(nodalAcceleration, nodalForce, DAMPING, nodalVelocity, DENSITY, constraintFLAG, DT, nodalDisplacement, deformedCoordinates, undeformedCoordinates)
 * 
 * 
 * ==========================================================================================================================================
 */

#include "mex.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

// Computational routine
void timeintegrationeulercromer(double *nodalAcceleration, double *nodalForce, double DAMPING, double *nodalVelocity, double *DENSITY, double *constraintFlag, double DT, double *nodalDisplacement, double *deformedCoordinates, double *undeformedCoordinates, int nNodes, int NOD)
{

    int i, j; 
    j = 0;

    #pragma omp parallel for default(none) shared(nNodes, j, NOD, DT, nodalAcceleration, nodalForce, DAMPING, nodalVelocity, DENSITY, constraintFlag, nodalDisplacement, deformedCoordinates, undeformedCoordinates) private(i)
    for(i = 0; i < nNodes * NOD; i++)
    {
        if ( i % NOD == 0 ) { j++; }                                                          // Iterator for DENSITY vector

        nodalAcceleration[i] = (nodalForce[i] - DAMPING * nodalVelocity[i]) / DENSITY[j];     // Acceleration for time:-   tt
            
        if ( constraintFlag[i] == 1 ) { nodalAcceleration[i] = 0; }                           // Apply boundary conditions

        nodalVelocity[i] = nodalVelocity[i] + (nodalAcceleration[i] * DT);                    // Velocity for time:-       tt + 1dt

        nodalDisplacement[i] = nodalDisplacement[i] + (nodalVelocity[i] * DT);                // Displacement for time:-   tt + 1dt

        deformedCoordinates[i] = undeformedCoordinates[i] + nodalDisplacement[i];             // Deformed coordinates of all nodes

    }


}

// Gateway routine
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

    // Declare variables
    int nNodes, NOD;
    double *u_ptr, *nf_ptr, DAMPING, *v_ptr, *dens_ptr, *cons_ptr, DT, *disp_ptr, *def_ptr, *undef_ptr;

    // Check for proper number of input and output arguments
    if (nrhs != 10)
    {
        mexErrMsgTxt("Ten input arguments required \n");
    }

    nNodes = mxGetM(prhs[0]);           // Number of rows in nodalAcceleration
    NOD = mxGetN(prhs[0]);              // Number of columns in nodalAcceleration

    u_ptr = mxGetPr(prhs[0]);           // nodal acceleration pointer
    nf_ptr = mxGetPr(prhs[1]);          // nodal force pointer
    DAMPING = mxGetScalar(prhs[2]);     // damping
    v_ptr = mxGetPr(prhs[3]);           // nodal velocity pointer
    dens_ptr = mxGetPr(prhs[4]);        // nodal density 
    cons_ptr = mxGetPr(prhs[5]);        // constraint flag pointer
    DT = mxGetScalar(prhs[6]);          // Time step size
    disp_ptr = mxGetPr(prhs[7]);        // nodal displacement pointer
    def_ptr = mxGetPr(prhs[8]);         // deformed coordinates pointer
    undef_ptr = mxGetPr(prhs[9]);       // undeformed coordinates pointer

    timeintegrationeulercromer(u_ptr, nf_ptr, DAMPING, v_ptr, dens_ptr, cons_ptr, DT, disp_ptr, def_ptr, undef_ptr, nNodes, NOD);

}
