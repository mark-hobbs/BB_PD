/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * calculatedeformedlength_terminate.c
 *
 * Code generation for function 'calculatedeformedlength_terminate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "calculatedeformedlength.h"
#include "calculatedeformedlength_terminate.h"
#include "_coder_calculatedeformedlength_mex.h"
#include "calculatedeformedlength_data.h"

/* Function Definitions */
void calculatedeformedlength_atexit(void)
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

void calculatedeformedlength_terminate(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (calculatedeformedlength_terminate.c) */
