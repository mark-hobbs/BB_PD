/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_calculatestraintensor_api.c
 *
 * Code generation for function '_coder_calculatestraintensor_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "calculatestraintensor.h"
#include "_coder_calculatestraintensor_api.h"
#include "calculatestraintensor_emxutil.h"
#include "calculatestraintensor_data.h"

/* Variable Definitions */
static emlrtRTEInfo g_emlrtRTEI = { 1, /* lineNo */
  1,                                   /* colNo */
  "_coder_calculatestraintensor_api",  /* fName */
  ""                                   /* pName */
};

/* Function Declarations */
static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *COORDINATES,
  const char_T *identifier, emxArray_real_T *y);
static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *BONDLIST,
  const char_T *identifier, emxArray_real_T *y);
static const mxArray *emlrt_marshallOut(const emxArray_real_T *u);
static void f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *fail, const
  char_T *identifier, emxArray_real_T *y);
static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static void j_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);
static void k_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);
static void l_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);

/* Function Definitions */
static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *COORDINATES,
  const char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  d_emlrt_marshallIn(sp, emlrtAlias(COORDINATES), &thisId, y);
  emlrtDestroyArray(&COORDINATES);
}

static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  j_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *BONDLIST,
  const char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  f_emlrt_marshallIn(sp, emlrtAlias(BONDLIST), &thisId, y);
  emlrtDestroyArray(&BONDLIST);
}

static const mxArray *emlrt_marshallOut(const emxArray_real_T *u)
{
  const mxArray *y;
  const mxArray *m9;
  static const int32_T iv8[3] = { 0, 0, 0 };

  y = NULL;
  m9 = emlrtCreateNumericArray(3, iv8, mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m9, &u->data[0]);
  emlrtSetDimensions((mxArray *)m9, u->size, 3);
  emlrtAssign(&y, m9);
  return y;
}

static void f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  k_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *fail, const
  char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  h_emlrt_marshallIn(sp, emlrtAlias(fail), &thisId, y);
  emlrtDestroyArray(&fail);
}

static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  l_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void j_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  static const int32_T dims[2] = { -1, 3 };

  const boolean_T bv0[2] = { true, false };

  int32_T iv9[2];
  int32_T i2;
  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, dims, &bv0[0],
    iv9);
  ret->allocatedSize = iv9[0] * iv9[1];
  i2 = ret->size[0] * ret->size[1];
  ret->size[0] = iv9[0];
  ret->size[1] = iv9[1];
  emxEnsureCapacity_real_T(sp, ret, i2, (emlrtRTEInfo *)NULL);
  ret->data = (real_T *)emlrtMxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

static void k_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  static const int32_T dims[2] = { -1, 2 };

  const boolean_T bv1[2] = { true, false };

  int32_T iv10[2];
  int32_T i3;
  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, dims, &bv1[0],
    iv10);
  ret->allocatedSize = iv10[0] * iv10[1];
  i3 = ret->size[0] * ret->size[1];
  ret->size[0] = iv10[0];
  ret->size[1] = iv10[1];
  emxEnsureCapacity_real_T(sp, ret, i3, (emlrtRTEInfo *)NULL);
  ret->data = (real_T *)emlrtMxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

static void l_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  static const int32_T dims[1] = { -1 };

  const boolean_T bv2[1] = { true };

  int32_T iv11[1];
  int32_T i4;
  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 1U, dims, &bv2[0],
    iv11);
  ret->allocatedSize = iv11[0];
  i4 = ret->size[0];
  ret->size[0] = iv11[0];
  emxEnsureCapacity_real_T(sp, ret, i4, (emlrtRTEInfo *)NULL);
  ret->data = (real_T *)emlrtMxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

void calculatestraintensor_api(const mxArray * const prhs[4], int32_T nlhs,
  const mxArray *plhs[1])
{
  emxArray_real_T *COORDINATES;
  emxArray_real_T *disp;
  emxArray_real_T *BONDLIST;
  emxArray_real_T *fail;
  emxArray_real_T *strainTensor;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  (void)nlhs;
  st.tls = emlrtRootTLSGlobal;
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  emxInit_real_T(&st, &COORDINATES, 2, &g_emlrtRTEI, true);
  emxInit_real_T(&st, &disp, 2, &g_emlrtRTEI, true);
  emxInit_real_T(&st, &BONDLIST, 2, &g_emlrtRTEI, true);
  emxInit_real_T(&st, &fail, 1, &g_emlrtRTEI, true);
  emxInit_real_T(&st, &strainTensor, 3, &g_emlrtRTEI, true);

  /* Marshall function inputs */
  COORDINATES->canFreeData = false;
  c_emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "COORDINATES", COORDINATES);
  disp->canFreeData = false;
  c_emlrt_marshallIn(&st, emlrtAlias(prhs[1]), "disp", disp);
  BONDLIST->canFreeData = false;
  e_emlrt_marshallIn(&st, emlrtAlias(prhs[2]), "BONDLIST", BONDLIST);
  fail->canFreeData = false;
  g_emlrt_marshallIn(&st, emlrtAlias(prhs[3]), "fail", fail);

  /* Invoke the target function */
  calculatestraintensor(&st, COORDINATES, disp, BONDLIST, fail, strainTensor);

  /* Marshall function outputs */
  strainTensor->canFreeData = false;
  plhs[0] = emlrt_marshallOut(strainTensor);
  emxFree_real_T(&strainTensor);
  emxFree_real_T(&fail);
  emxFree_real_T(&BONDLIST);
  emxFree_real_T(&disp);
  emxFree_real_T(&COORDINATES);
  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

/* End of code generation (_coder_calculatestraintensor_api.c) */
