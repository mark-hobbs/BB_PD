/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_calculatedeformedlength_mex.c
 *
 * Code generation for function '_coder_calculatedeformedlength_mex'
 *
 */

/* Include files */
#include "calculatedeformedlength.h"
#include "_coder_calculatedeformedlength_mex.h"
#include "calculatedeformedlength_terminate.h"
#include "_coder_calculatedeformedlength_api.h"
#include "calculatedeformedlength_initialize.h"
#include "calculatedeformedlength_data.h"

/* Function Declarations */
static void c_calculatedeformedlength_mexFu(int32_T nlhs, mxArray *plhs[3],
  int32_T nrhs, const mxArray *prhs[6]);

/* Function Definitions */
static void c_calculatedeformedlength_mexFu(int32_T nlhs, mxArray *plhs[3],
  int32_T nrhs, const mxArray *prhs[6])
{
  const mxArray *outputs[3];
  int32_T b_nlhs;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 6) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 6, 4,
                        23, "calculatedeformedlength");
  }

  if (nlhs > 3) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 23,
                        "calculatedeformedlength");
  }

  /* Call the function. */
  calculatedeformedlength_api(prhs, nlhs, outputs);

  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    b_nlhs = 1;
  } else {
    b_nlhs = nlhs;
  }

  emlrtReturnArrays(b_nlhs, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(calculatedeformedlength_atexit);

  /* Module initialization. */
  calculatedeformedlength_initialize();

  /* Dispatch the entry-point. */
  c_calculatedeformedlength_mexFu(nlhs, plhs, nrhs, prhs);

  /* Module termination. */
  calculatedeformedlength_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_calculatedeformedlength_mex.c) */
