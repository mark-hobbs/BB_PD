/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * calculatestraintensor_emxutil.h
 *
 * Code generation for function 'calculatestraintensor_emxutil'
 *
 */

#ifndef CALCULATESTRAINTENSOR_EMXUTIL_H
#define CALCULATESTRAINTENSOR_EMXUTIL_H

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
extern void emxEnsureCapacity_real_T(const emlrtStack *sp, emxArray_real_T
  *emxArray, int32_T oldNumel, const emlrtRTEInfo *srcLocation);
extern void emxFree_real_T(emxArray_real_T **pEmxArray);
extern void emxInit_real_T(const emlrtStack *sp, emxArray_real_T **pEmxArray,
  int32_T numDimensions, const emlrtRTEInfo *srcLocation, boolean_T doPush);

#endif

/* End of code generation (calculatestraintensor_emxutil.h) */
