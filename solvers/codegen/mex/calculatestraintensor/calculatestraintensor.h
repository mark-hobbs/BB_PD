/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * calculatestraintensor.h
 *
 * Code generation for function 'calculatestraintensor'
 *
 */

#ifndef CALCULATESTRAINTENSOR_H
#define CALCULATESTRAINTENSOR_H

/* Include files */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "rtwtypes.h"
#include "omp.h"
#include "calculatestraintensor_types.h"

/* Function Declarations */
extern void calculatestraintensor(const emlrtStack *sp, const emxArray_real_T
  *COORDINATES, const emxArray_real_T *disp, const emxArray_real_T *BONDLIST,
  const emxArray_real_T *fail, emxArray_real_T *strainTensor);

#endif

/* End of code generation (calculatestraintensor.h) */
