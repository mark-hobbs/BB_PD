/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_calculatenodalforces_api.c
 *
 * Code generation for function '_coder_calculatenodalforces_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "calculatenodalforces.h"
#include "_coder_calculatenodalforces_api.h"
#include "calculatenodalforces_emxutil.h"
#include "calculatenodalforces_data.h"

/* Variable Definitions */
static emlrtRTEInfo emlrtRTEI = { 1,   /* lineNo */
  1,                                   /* colNo */
  "_coder_calculatenodalforces_api",   /* fName */
  ""                                   /* pName */
};

/* Function Declarations */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *nodalForce,
  const char_T *identifier, emxArray_real_T *y);
static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *bForceX,
  const char_T *identifier, emxArray_real_T *y);
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *BONDLIST,
  const char_T *identifier, emxArray_real_T *y);
static void emlrt_marshallOut(const emxArray_real_T *u, const mxArray *y);
static void f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static real_T g_emlrt_marshallIn(const emlrtStack *sp, const mxArray
  *MAXBODYFORCE, const char_T *identifier);
static real_T h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static void i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);
static void j_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);
static void k_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);
static real_T l_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId);

/* Function Definitions */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  i_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *nodalForce,
  const char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  d_emlrt_marshallIn(sp, emlrtAlias(nodalForce), &thisId, y);
  emlrtDestroyArray(&nodalForce);
}

static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  j_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *bForceX,
  const char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  f_emlrt_marshallIn(sp, emlrtAlias(bForceX), &thisId, y);
  emlrtDestroyArray(&bForceX);
}

static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *BONDLIST,
  const char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  b_emlrt_marshallIn(sp, emlrtAlias(BONDLIST), &thisId, y);
  emlrtDestroyArray(&BONDLIST);
}

static void emlrt_marshallOut(const emxArray_real_T *u, const mxArray *y)
{
  emlrtMxSetData((mxArray *)y, &u->data[0]);
  emlrtSetDimensions((mxArray *)y, u->size, 2);
}

static void f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  k_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static real_T g_emlrt_marshallIn(const emlrtStack *sp, const mxArray
  *MAXBODYFORCE, const char_T *identifier)
{
  real_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = h_emlrt_marshallIn(sp, emlrtAlias(MAXBODYFORCE), &thisId);
  emlrtDestroyArray(&MAXBODYFORCE);
  return y;
}

static real_T h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = l_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static void i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  static const int32_T dims[2] = { -1, 2 };

  const boolean_T bv0[2] = { true, false };

  int32_T iv0[2];
  int32_T i0;
  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, dims, &bv0[0],
    iv0);
  ret->allocatedSize = iv0[0] * iv0[1];
  i0 = ret->size[0] * ret->size[1];
  ret->size[0] = iv0[0];
  ret->size[1] = iv0[1];
  emxEnsureCapacity_real_T(sp, ret, i0, (emlrtRTEInfo *)NULL);
  ret->data = (real_T *)emlrtMxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

static void j_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  static const int32_T dims[2] = { -1, 3 };

  const boolean_T bv1[2] = { true, false };

  int32_T iv1[2];
  int32_T i1;
  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, dims, &bv1[0],
    iv1);
  ret->allocatedSize = iv1[0] * iv1[1];
  i1 = ret->size[0] * ret->size[1];
  ret->size[0] = iv1[0];
  ret->size[1] = iv1[1];
  emxEnsureCapacity_real_T(sp, ret, i1, (emlrtRTEInfo *)NULL);
  ret->data = (real_T *)emlrtMxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

static void k_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  static const int32_T dims[1] = { -1 };

  const boolean_T bv2[1] = { true };

  int32_T iv2[1];
  int32_T i2;
  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 1U, dims, &bv2[0],
    iv2);
  ret->allocatedSize = iv2[0];
  i2 = ret->size[0];
  ret->size[0] = iv2[0];
  emxEnsureCapacity_real_T(sp, ret, i2, (emlrtRTEInfo *)NULL);
  ret->data = (real_T *)emlrtMxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

static real_T l_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId)
{
  real_T ret;
  static const int32_T dims = 0;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 0U, &dims);
  ret = *(real_T *)emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

void calculatenodalforces_api(const mxArray *prhs[7], int32_T nlhs, const
  mxArray *plhs[1])
{
  emxArray_real_T *BONDLIST;
  emxArray_real_T *nodalForce;
  emxArray_real_T *bForceX;
  emxArray_real_T *bForceY;
  emxArray_real_T *bForceZ;
  emxArray_real_T *BODYFORCEFLAG;
  const mxArray *prhs_copy_idx_1;
  real_T MAXBODYFORCE;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  (void)nlhs;
  st.tls = emlrtRootTLSGlobal;
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  emxInit_real_T(&st, &BONDLIST, 2, &emlrtRTEI, true);
  emxInit_real_T(&st, &nodalForce, 2, &emlrtRTEI, true);
  emxInit_real_T(&st, &bForceX, 1, &emlrtRTEI, true);
  emxInit_real_T(&st, &bForceY, 1, &emlrtRTEI, true);
  emxInit_real_T(&st, &bForceZ, 1, &emlrtRTEI, true);
  emxInit_real_T(&st, &BODYFORCEFLAG, 2, &emlrtRTEI, true);
  prhs_copy_idx_1 = emlrtProtectR2012b(prhs[1], 1, true, -1);

  /* Marshall function inputs */
  BONDLIST->canFreeData = false;
  emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "BONDLIST", BONDLIST);
  nodalForce->canFreeData = false;
  c_emlrt_marshallIn(&st, emlrtAlias(prhs_copy_idx_1), "nodalForce", nodalForce);
  bForceX->canFreeData = false;
  e_emlrt_marshallIn(&st, emlrtAlias(prhs[2]), "bForceX", bForceX);
  bForceY->canFreeData = false;
  e_emlrt_marshallIn(&st, emlrtAlias(prhs[3]), "bForceY", bForceY);
  bForceZ->canFreeData = false;
  e_emlrt_marshallIn(&st, emlrtAlias(prhs[4]), "bForceZ", bForceZ);
  BODYFORCEFLAG->canFreeData = false;
  c_emlrt_marshallIn(&st, emlrtAlias(prhs[5]), "BODYFORCEFLAG", BODYFORCEFLAG);
  MAXBODYFORCE = g_emlrt_marshallIn(&st, emlrtAliasP(prhs[6]), "MAXBODYFORCE");

  /* Invoke the target function */
  calculatenodalforces(&st, BONDLIST, nodalForce, bForceX, bForceY, bForceZ,
                       BODYFORCEFLAG, MAXBODYFORCE);

  /* Marshall function outputs */
  nodalForce->canFreeData = false;
  emlrt_marshallOut(nodalForce, prhs_copy_idx_1);
  plhs[0] = prhs_copy_idx_1;
  emxFree_real_T(&BODYFORCEFLAG);
  emxFree_real_T(&bForceZ);
  emxFree_real_T(&bForceY);
  emxFree_real_T(&bForceX);
  emxFree_real_T(&nodalForce);
  emxFree_real_T(&BONDLIST);
  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

/* End of code generation (_coder_calculatenodalforces_api.c) */
