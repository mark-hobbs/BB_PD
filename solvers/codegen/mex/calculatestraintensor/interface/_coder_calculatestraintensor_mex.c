/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_calculatestraintensor_mex.c
 *
 * Code generation for function '_coder_calculatestraintensor_mex'
 *
 */

/* Include files */
#include "calculatestraintensor.h"
#include "_coder_calculatestraintensor_mex.h"
#include "calculatestraintensor_terminate.h"
#include "_coder_calculatestraintensor_api.h"
#include "calculatestraintensor_initialize.h"
#include "calculatestraintensor_data.h"

/* Variable Definitions */
static jmp_buf emlrtJBEnviron;

/* Function Declarations */
static void c_calculatestraintensor_mexFunc(int32_T nlhs, mxArray *plhs[1],
  int32_T nrhs, const mxArray *prhs[4]);

/* Function Definitions */
static void c_calculatestraintensor_mexFunc(int32_T nlhs, mxArray *plhs[1],
  int32_T nrhs, const mxArray *prhs[4])
{
  const mxArray *outputs[1];
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 4) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 4, 4,
                        21, "calculatestraintensor");
  }

  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 21,
                        "calculatestraintensor");
  }

  /* Call the function. */
  calculatestraintensor_api(prhs, nlhs, outputs);

  /* Copy over outputs to the caller. */
  emlrtReturnArrays(1, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexAtExit(calculatestraintensor_atexit);

  /* Initialize the memory manager. */
  omp_init_lock(&emlrtLockGlobal);
  omp_init_nest_lock(&emlrtNestLockGlobal);

  /* Module initialization. */
  calculatestraintensor_initialize();
  st.tls = emlrtRootTLSGlobal;
  emlrtSetJmpBuf(&st, &emlrtJBEnviron);
  if (setjmp(emlrtJBEnviron) == 0) {
    /* Dispatch the entry-point. */
    c_calculatestraintensor_mexFunc(nlhs, plhs, nrhs, prhs);

    /* Module termination. */
    calculatestraintensor_terminate();
    omp_destroy_lock(&emlrtLockGlobal);
    omp_destroy_nest_lock(&emlrtNestLockGlobal);
  } else {
    omp_destroy_lock(&emlrtLockGlobal);
    omp_destroy_nest_lock(&emlrtNestLockGlobal);
    emlrtReportParallelRunTimeError(&st);
  }
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal,
                     emlrtLockerFunction, omp_get_num_procs());
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_calculatestraintensor_mex.c) */
