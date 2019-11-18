/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * calculatenodalforces_initialize.c
 *
 * Code generation for function 'calculatenodalforces_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "calculatenodalforces.h"
#include "calculatenodalforces_initialize.h"
#include "_coder_calculatenodalforces_mex.h"
#include "calculatenodalforces_data.h"

/* Function Definitions */
void calculatenodalforces_initialize(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (calculatenodalforces_initialize.c) */
