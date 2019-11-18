/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_calculatenodalforces_mex.c
 *
 * Code generation for function '_coder_calculatenodalforces_mex'
 *
 */

/* Include files */
#include "calculatenodalforces.h"
#include "_coder_calculatenodalforces_mex.h"
#include "calculatenodalforces_terminate.h"
#include "_coder_calculatenodalforces_api.h"
#include "calculatenodalforces_initialize.h"
#include "calculatenodalforces_data.h"

/* Function Declarations */
static void c_calculatenodalforces_mexFunct(int32_T nlhs, mxArray *plhs[1],
  int32_T nrhs, const mxArray *prhs[7]);

/* Function Definitions */
static void c_calculatenodalforces_mexFunct(int32_T nlhs, mxArray *plhs[1],
  int32_T nrhs, const mxArray *prhs[7])
{
  const mxArray *outputs[1];
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 7) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 7, 4,
                        20, "calculatenodalforces");
  }

  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 20,
                        "calculatenodalforces");
  }

  /* Call the function. */
  calculatenodalforces_api(prhs, nlhs, outputs);

  /* Copy over outputs to the caller. */
  emlrtReturnArrays(1, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(calculatenodalforces_atexit);

  /* Module initialization. */
  calculatenodalforces_initialize();

  /* Dispatch the entry-point. */
  c_calculatenodalforces_mexFunct(nlhs, plhs, nrhs, prhs);

  /* Module termination. */
  calculatenodalforces_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_calculatenodalforces_mex.c) */
