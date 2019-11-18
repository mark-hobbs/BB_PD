/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * norm.c
 *
 * Code generation for function 'norm'
 *
 */

/* Include files */
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "calculatestraintensor.h"
#include "norm.h"

/* Function Definitions */
real_T b_norm(const real_T x[9])
{
  real_T y;
  int32_T j;
  boolean_T exitg1;
  real_T s;
  y = 0.0;
  j = 0;
  exitg1 = false;
  while ((!exitg1) && (j < 3)) {
    s = (muDoubleScalarAbs(x[3 * j]) + muDoubleScalarAbs(x[1 + 3 * j])) +
      muDoubleScalarAbs(x[2 + 3 * j]);
    if (muDoubleScalarIsNaN(s)) {
      y = rtNaN;
      exitg1 = true;
    } else {
      if (s > y) {
        y = s;
      }

      j++;
    }
  }

  return y;
}

/* End of code generation (norm.c) */
