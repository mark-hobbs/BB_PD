
/*
 * ==========================================================================================================================================
 * timeintegrationeulercromerMex.c 
 * Time integration using an Euler-Cromer scheme for a three-dimensional peridynamic body
 * 
 * [] = timeintegrationeulercromerMex(nodalAcceleration, nodalForce, DAMPING, nodalVelocity, DENSITY, constraintFLAG, DT, nodalDisplacement, deformedCoordinates, undeformedCoordinates)
 * 
 * Compile Linux:
 * module load gcc-6.3.0-gcc-4.8.5-2e3eatd
 * mex timeintegrationeulercromerMex.c CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"
 *  
 * Compile Windows:
 * mex COMPFLAGS="$COMPFLAGS /openmp" timeintegrationeulercromerMex.c
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

    int kNode, dof;

    
    #pragma omp parallel for default(none) shared(nNodes, dof, NOD, DT, nodalAcceleration, nodalForce, DAMPING, nodalVelocity, DENSITY, constraintFlag, nodalDisplacement, deformedCoordinates, undeformedCoordinates) private(kNode)
    for(kNode = 0; kNode < nNodes; kNode++)
    {
        for(dof = 0; dof < NOD; dof++)
        {

            nodalAcceleration[kNode + (nNodes * dof)] = (nodalForce[kNode + (nNodes * dof)] - DAMPING * nodalVelocity[kNode + (nNodes * dof)]) / DENSITY[kNode];  // Acceleration for time:-   tt
            
            if ( constraintFlag[kNode + (nNodes * dof)] == 1 ) { nodalAcceleration[kNode + (nNodes * dof)] = 0; }                                                // Apply boundary conditions

            nodalVelocity[kNode + (nNodes * dof)] = nodalVelocity[kNode + (nNodes * dof)] + (nodalAcceleration[kNode + (nNodes * dof)] * DT);                    // Velocity for time:-       tt + 1dt

            nodalDisplacement[kNode + (nNodes * dof)] = nodalDisplacement[kNode + (nNodes * dof)] + (nodalVelocity[kNode + (nNodes * dof)] * DT);                // Displacement for time:-   tt + 1dt

            deformedCoordinates[kNode + (nNodes * dof)] = undeformedCoordinates[kNode + (nNodes * dof)] + nodalDisplacement[kNode + (nNodes * dof)];             // Deformed coordinates of all nodes

        }

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
