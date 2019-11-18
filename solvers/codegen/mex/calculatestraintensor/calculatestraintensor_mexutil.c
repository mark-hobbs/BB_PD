/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * calculatestraintensor_mexutil.c
 *
 * Code generation for function 'calculatestraintensor_mexutil'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "calculatestraintensor.h"
#include "calculatestraintensor_mexutil.h"
#include "calculatestraintensor_data.h"

/* Function Definitions */
emlrtCTX emlrtGetRootTLSGlobal(void)
{
  return emlrtRootTLSGlobal;
}

void emlrtLockerFunction(EmlrtLockeeFunction aLockee, const emlrtConstCTX aTLS,
  void *aData)
{
  omp_set_lock(&emlrtLockGlobal);
  emlrtCallLockeeFunction(aLockee, aTLS, aData);
  omp_unset_lock(&emlrtLockGlobal);
}

/* End of code generation (calculatestraintensor_mexutil.c) */
