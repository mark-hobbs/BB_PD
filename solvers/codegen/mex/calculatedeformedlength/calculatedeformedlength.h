/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * calculatedeformedlength.h
 *
 * Code generation for function 'calculatedeformedlength'
 *
 */

#ifndef CALCULATEDEFORMEDLENGTH_H
#define CALCULATEDEFORMEDLENGTH_H

/* Include files */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "rtwtypes.h"
#include "calculatedeformedlength_types.h"

/* Function Declarations */
extern void calculatedeformedlength(const emlrtStack *sp, const emxArray_real_T *
  deformedCoordinates, emxArray_real_T *deformedX, emxArray_real_T *deformedY,
  emxArray_real_T *deformedZ, real_T nBonds, const emxArray_real_T *BONDLIST);

#endif

/* End of code generation (calculatedeformedlength.h) */
