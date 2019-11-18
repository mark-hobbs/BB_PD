/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * calculatenodalforces.h
 *
 * Code generation for function 'calculatenodalforces'
 *
 */

#ifndef CALCULATENODALFORCES_H
#define CALCULATENODALFORCES_H

/* Include files */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "rtwtypes.h"
#include "calculatenodalforces_types.h"

/* Function Declarations */
extern void calculatenodalforces(const emlrtStack *sp, const emxArray_real_T
  *BONDLIST, emxArray_real_T *nodalForce, const emxArray_real_T *bForceX, const
  emxArray_real_T *bForceY, const emxArray_real_T *bForceZ, const
  emxArray_real_T *BODYFORCEFLAG, real_T MAXBODYFORCE);

#endif

/* End of code generation (calculatenodalforces.h) */
