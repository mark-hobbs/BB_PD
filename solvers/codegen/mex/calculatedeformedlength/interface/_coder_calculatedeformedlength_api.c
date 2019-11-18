/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_calculatedeformedlength_api.c
 *
 * Code generation for function '_coder_calculatedeformedlength_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "calculatedeformedlength.h"
#include "_coder_calculatedeformedlength_api.h"
#include "calculatedeformedlength_emxutil.h"
#include "calculatedeformedlength_data.h"

/* Variable Definitions */
static emlrtRTEInfo emlrtRTEI = { 1,   /* lineNo */
  1,                                   /* colNo */
  "_coder_calculatedeformedlength_api",/* fName */
  ""                                   /* pName */
};

/* Function Declarations */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *deformedX,
  const char_T *identifier, emxArray_real_T *y);
static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static real_T e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *nBonds,
  const char_T *identifier);
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray
  *deformedCoordinates, const char_T *identifier, emxArray_real_T *y);
static void emlrt_marshallOut(const emxArray_real_T *u, const mxArray *y);
static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *BONDLIST,
  const char_T *identifier, emxArray_real_T *y);
static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static void i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);
static void j_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);
static real_T k_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId);
static void l_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);

/* Function Definitions */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  i_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *deformedX,
  const char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  d_emlrt_marshallIn(sp, emlrtAlias(deformedX), &thisId, y);
  emlrtDestroyArray(&deformedX);
}

static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  j_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static real_T e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *nBonds,
  const char_T *identifier)
{
  real_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = f_emlrt_marshallIn(sp, emlrtAlias(nBonds), &thisId);
  emlrtDestroyArray(&nBonds);
  return y;
}

static void emlrt_marshallIn(const emlrtStack *sp, const mxArray
  *deformedCoordinates, const char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  b_emlrt_marshallIn(sp, emlrtAlias(deformedCoordinates), &thisId, y);
  emlrtDestroyArray(&deformedCoordinates);
}

static void emlrt_marshallOut(const emxArray_real_T *u, const mxArray *y)
{
  emlrtMxSetData((mxArray *)y, &u->data[0]);
  emlrtSetDimensions((mxArray *)y, u->size, 1);
}

static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = k_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *BONDLIST,
  const char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  h_emlrt_marshallIn(sp, emlrtAlias(BONDLIST), &thisId, y);
  emlrtDestroyArray(&BONDLIST);
}

static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  l_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  static const int32_T dims[2] = { -1, 3 };

  const boolean_T bv0[2] = { true, false };

  int32_T iv1[2];
  int32_T i0;
  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, dims, &bv0[0],
    iv1);
  ret->allocatedSize = iv1[0] * iv1[1];
  i0 = ret->size[0] * ret->size[1];
  ret->size[0] = iv1[0];
  ret->size[1] = iv1[1];
  emxEnsureCapacity_real_T(sp, ret, i0, (emlrtRTEInfo *)NULL);
  ret->data = (real_T *)emlrtMxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

static void j_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  static const int32_T dims[1] = { -1 };

  const boolean_T bv1[1] = { true };

  int32_T iv2[1];
  int32_T i1;
  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 1U, dims, &bv1[0],
    iv2);
  ret->allocatedSize = iv2[0];
  i1 = ret->size[0];
  ret->size[0] = iv2[0];
  emxEnsureCapacity_real_T(sp, ret, i1, (emlrtRTEInfo *)NULL);
  ret->data = (real_T *)emlrtMxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

static real_T k_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId)
{
  real_T ret;
  static const int32_T dims = 0;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 0U, &dims);
  ret = *(real_T *)emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static void l_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  static const int32_T dims[2] = { -1, 2 };

  const boolean_T bv2[2] = { true, false };

  int32_T iv3[2];
  int32_T i2;
  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, dims, &bv2[0],
    iv3);
  ret->allocatedSize = iv3[0] * iv3[1];
  i2 = ret->size[0] * ret->size[1];
  ret->size[0] = iv3[0];
  ret->size[1] = iv3[1];
  emxEnsureCapacity_real_T(sp, ret, i2, (emlrtRTEInfo *)NULL);
  ret->data = (real_T *)emlrtMxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

void calculatedeformedlength_api(const mxArray *prhs[6], int32_T nlhs, const
  mxArray *plhs[3])
{
  emxArray_real_T *deformedCoordinates;
  emxArray_real_T *deformedX;
  emxArray_real_T *deformedY;
  emxArray_real_T *deformedZ;
  emxArray_real_T *BONDLIST;
  const mxArray *prhs_copy_idx_1;
  const mxArray *prhs_copy_idx_2;
  const mxArray *prhs_copy_idx_3;
  real_T nBonds;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  emxInit_real_T(&st, &deformedCoordinates, 2, &emlrtRTEI, true);
  emxInit_real_T(&st, &deformedX, 1, &emlrtRTEI, true);
  emxInit_real_T(&st, &deformedY, 1, &emlrtRTEI, true);
  emxInit_real_T(&st, &deformedZ, 1, &emlrtRTEI, true);
  emxInit_real_T(&st, &BONDLIST, 2, &emlrtRTEI, true);
  prhs_copy_idx_1 = emlrtProtectR2012b(prhs[1], 1, true, -1);
  prhs_copy_idx_2 = emlrtProtectR2012b(prhs[2], 2, true, -1);
  prhs_copy_idx_3 = emlrtProtectR2012b(prhs[3], 3, true, -1);

  /* Marshall function inputs */
  deformedCoordinates->canFreeData = false;
  emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "deformedCoordinates",
                   deformedCoordinates);
  deformedX->canFreeData = false;
  c_emlrt_marshallIn(&st, emlrtAlias(prhs_copy_idx_1), "deformedX", deformedX);
  deformedY->canFreeData = false;
  c_emlrt_marshallIn(&st, emlrtAlias(prhs_copy_idx_2), "deformedY", deformedY);
  deformedZ->canFreeData = false;
  c_emlrt_marshallIn(&st, emlrtAlias(prhs_copy_idx_3), "deformedZ", deformedZ);
  nBonds = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[4]), "nBonds");
  BONDLIST->canFreeData = false;
  g_emlrt_marshallIn(&st, emlrtAlias(prhs[5]), "BONDLIST", BONDLIST);

  /* Invoke the target function */
  calculatedeformedlength(&st, deformedCoordinates, deformedX, deformedY,
    deformedZ, nBonds, BONDLIST);

  /* Marshall function outputs */
  deformedX->canFreeData = false;
  emlrt_marshallOut(deformedX, prhs_copy_idx_1);
  plhs[0] = prhs_copy_idx_1;
  emxFree_real_T(&BONDLIST);
  emxFree_real_T(&deformedX);
  emxFree_real_T(&deformedCoordinates);
  if (nlhs > 1) {
    deformedY->canFreeData = false;
    emlrt_marshallOut(deformedY, prhs_copy_idx_2);
    plhs[1] = prhs_copy_idx_2;
  }

  emxFree_real_T(&deformedY);
  if (nlhs > 2) {
    deformedZ->canFreeData = false;
    emlrt_marshallOut(deformedZ, prhs_copy_idx_3);
    plhs[2] = prhs_copy_idx_3;
  }

  emxFree_real_T(&deformedZ);
  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

/* End of code generation (_coder_calculatedeformedlength_api.c) */
