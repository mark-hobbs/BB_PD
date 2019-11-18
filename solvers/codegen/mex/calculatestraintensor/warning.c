/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * warning.c
 *
 * Code generation for function 'warning'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "calculatestraintensor.h"
#include "warning.h"

/* Variable Definitions */
static emlrtRTEInfo emlrtRTEI = { 14,  /* lineNo */
  15,                                  /* colNo */
  "warning",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2019a\\toolbox\\shared\\coder\\coder\\+coder\\+internal\\warning.m"/* pName */
};

static emlrtMCInfo emlrtMCI = { 14,    /* lineNo */
  25,                                  /* colNo */
  "warning",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2019a\\toolbox\\shared\\coder\\coder\\+coder\\+internal\\warning.m"/* pName */
};

static emlrtMCInfo b_emlrtMCI = { 14,  /* lineNo */
  9,                                   /* colNo */
  "warning",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2019a\\toolbox\\shared\\coder\\coder\\+coder\\+internal\\warning.m"/* pName */
};

static emlrtRSInfo t_emlrtRSI = { 14,  /* lineNo */
  "warning",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2019a\\toolbox\\shared\\coder\\coder\\+coder\\+internal\\warning.m"/* pathName */
};

/* Function Declarations */
static void b_feval(const emlrtStack *sp, const mxArray *b, const mxArray *c,
                    emlrtMCInfo *location);
static const mxArray *c_feval(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, const mxArray *d, emlrtMCInfo *location);
static const mxArray *feval(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, emlrtMCInfo *location);

/* Function Definitions */
static void b_feval(const emlrtStack *sp, const mxArray *b, const mxArray *c,
                    emlrtMCInfo *location)
{
  const mxArray *pArrays[2];
  pArrays[0] = b;
  pArrays[1] = c;
  emlrtCallMATLABR2012b(sp, 0, NULL, 2, pArrays, "feval", true, location);
}

static const mxArray *c_feval(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, const mxArray *d, emlrtMCInfo *location)
{
  const mxArray *pArrays[3];
  const mxArray *m12;
  pArrays[0] = b;
  pArrays[1] = c;
  pArrays[2] = d;
  return emlrtCallMATLABR2012b(sp, 1, &m12, 3, pArrays, "feval", true, location);
}

static const mxArray *feval(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, emlrtMCInfo *location)
{
  const mxArray *pArrays[2];
  const mxArray *m10;
  pArrays[0] = b;
  pArrays[1] = c;
  return emlrtCallMATLABR2012b(sp, 1, &m10, 2, pArrays, "feval", true, location);
}

void b_warning(const emlrtStack *sp, const char_T varargin_1[14])
{
  const mxArray *y;
  const mxArray *m5;
  static const int32_T iv4[2] = { 1, 7 };

  static const char_T u[7] = { 'w', 'a', 'r', 'n', 'i', 'n', 'g' };

  const mxArray *b_y;
  const mxArray *m6;
  static const int32_T iv5[2] = { 1, 7 };

  static const char_T b_u[7] = { 'm', 'e', 's', 's', 'a', 'g', 'e' };

  const mxArray *c_y;
  const mxArray *m7;
  static const int32_T iv6[2] = { 1, 33 };

  static const char_T msgID[33] = { 'C', 'o', 'd', 'e', 'r', ':', 'M', 'A', 'T',
    'L', 'A', 'B', ':', 'i', 'l', 'l', 'C', 'o', 'n', 'd', 'i', 't', 'i', 'o',
    'n', 'e', 'd', 'M', 'a', 't', 'r', 'i', 'x' };

  const mxArray *d_y;
  const mxArray *m8;
  static const int32_T iv7[2] = { 1, 14 };

  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  emlrtAssertMATLABThread(sp, &emlrtRTEI);
  y = NULL;
  m5 = emlrtCreateCharArray(2, iv4);
  emlrtInitCharArrayR2013a(sp, 7, m5, &u[0]);
  emlrtAssign(&y, m5);
  b_y = NULL;
  m6 = emlrtCreateCharArray(2, iv5);
  emlrtInitCharArrayR2013a(sp, 7, m6, &b_u[0]);
  emlrtAssign(&b_y, m6);
  c_y = NULL;
  m7 = emlrtCreateCharArray(2, iv6);
  emlrtInitCharArrayR2013a(sp, 33, m7, &msgID[0]);
  emlrtAssign(&c_y, m7);
  d_y = NULL;
  m8 = emlrtCreateCharArray(2, iv7);
  emlrtInitCharArrayR2013a(sp, 14, m8, &varargin_1[0]);
  emlrtAssign(&d_y, m8);
  st.site = &t_emlrtRSI;
  b_feval(&st, y, c_feval(&st, b_y, c_y, d_y, &emlrtMCI), &b_emlrtMCI);
}

void warning(const emlrtStack *sp)
{
  const mxArray *y;
  const mxArray *m2;
  static const int32_T iv1[2] = { 1, 7 };

  static const char_T u[7] = { 'w', 'a', 'r', 'n', 'i', 'n', 'g' };

  const mxArray *b_y;
  const mxArray *m3;
  static const int32_T iv2[2] = { 1, 7 };

  static const char_T b_u[7] = { 'm', 'e', 's', 's', 'a', 'g', 'e' };

  const mxArray *c_y;
  const mxArray *m4;
  static const int32_T iv3[2] = { 1, 21 };

  static const char_T msgID[21] = { 'M', 'A', 'T', 'L', 'A', 'B', ':', 's', 'i',
    'n', 'g', 'u', 'l', 'a', 'r', 'M', 'a', 't', 'r', 'i', 'x' };

  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  emlrtAssertMATLABThread(sp, &emlrtRTEI);
  y = NULL;
  m2 = emlrtCreateCharArray(2, iv1);
  emlrtInitCharArrayR2013a(sp, 7, m2, &u[0]);
  emlrtAssign(&y, m2);
  b_y = NULL;
  m3 = emlrtCreateCharArray(2, iv2);
  emlrtInitCharArrayR2013a(sp, 7, m3, &b_u[0]);
  emlrtAssign(&b_y, m3);
  c_y = NULL;
  m4 = emlrtCreateCharArray(2, iv3);
  emlrtInitCharArrayR2013a(sp, 21, m4, &msgID[0]);
  emlrtAssign(&c_y, m4);
  st.site = &t_emlrtRSI;
  b_feval(&st, y, feval(&st, b_y, c_y, &emlrtMCI), &b_emlrtMCI);
}

/* End of code generation (warning.c) */
