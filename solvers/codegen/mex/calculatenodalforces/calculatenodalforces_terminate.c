/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * calculatenodalforces_terminate.c
 *
 * Code generation for function 'calculatenodalforces_terminate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "calculatenodalforces.h"
#include "calculatenodalforces_terminate.h"
#include "_coder_calculatenodalforces_mex.h"
#include "calculatenodalforces_data.h"

/* Function Definitions */
void calculatenodalforces_atexit(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void calculatenodalforces_terminate(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (calculatenodalforces_terminate.c) */
