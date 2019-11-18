/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * calculatestraintensor.c
 *
 * Code generation for function 'calculatestraintensor'
 *
 */

/* Include files */
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "calculatestraintensor.h"
#include "calculatestraintensor_emxutil.h"
#include "warning.h"
#include "norm.h"
#include "det.h"
#include "calculatestraintensor_data.h"

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 145,   /* lineNo */
  "calculatestraintensor",             /* fcnName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m"/* pathName */
};

static emlrtRSInfo b_emlrtRSI = { 147, /* lineNo */
  "calculatestraintensor",             /* fcnName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m"/* pathName */
};

static emlrtRSInfo l_emlrtRSI = { 49,  /* lineNo */
  "mpower",                            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2019a\\toolbox\\eml\\lib\\matlab\\ops\\mpower.m"/* pathName */
};

static emlrtRSInfo m_emlrtRSI = { 78,  /* lineNo */
  "matrix_to_scalar_power",            /* fcnName */
  "C:\\Program Files\\MATLAB\\R2019a\\toolbox\\eml\\lib\\matlab\\ops\\mpower.m"/* pathName */
};

static emlrtRSInfo n_emlrtRSI = { 13,  /* lineNo */
  "matrix_to_integer_power",           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2019a\\toolbox\\eml\\lib\\matlab\\ops\\private\\matrix_to_integer_power.m"/* pathName */
};

static emlrtRSInfo o_emlrtRSI = { 75,  /* lineNo */
  "matrix_to_small_integer_power",     /* fcnName */
  "C:\\Program Files\\MATLAB\\R2019a\\toolbox\\eml\\lib\\matlab\\ops\\private\\matrix_to_integer_power.m"/* pathName */
};

static emlrtRSInfo p_emlrtRSI = { 31,  /* lineNo */
  "inv",                               /* fcnName */
  "C:\\Program Files\\MATLAB\\R2019a\\toolbox\\eml\\lib\\matlab\\matfun\\inv.m"/* pathName */
};

static emlrtRSInfo q_emlrtRSI = { 42,  /* lineNo */
  "checkcond",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2019a\\toolbox\\eml\\lib\\matlab\\matfun\\inv.m"/* pathName */
};

static emlrtRSInfo r_emlrtRSI = { 46,  /* lineNo */
  "checkcond",                         /* fcnName */
  "C:\\Program Files\\MATLAB\\R2019a\\toolbox\\eml\\lib\\matlab\\matfun\\inv.m"/* pathName */
};

static emlrtRTEInfo b_emlrtRTEI = { 53,/* lineNo */
  27,                                  /* colNo */
  "flt2str",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2019a\\toolbox\\eml\\eml\\+coder\\+internal\\flt2str.m"/* pName */
};

static emlrtRTEInfo c_emlrtRTEI = { 1, /* lineNo */
  27,                                  /* colNo */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m"/* pName */
};

static emlrtMCInfo c_emlrtMCI = { 53,  /* lineNo */
  19,                                  /* colNo */
  "flt2str",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2019a\\toolbox\\eml\\eml\\+coder\\+internal\\flt2str.m"/* pName */
};

static emlrtRTEInfo d_emlrtRTEI = { 60,/* lineNo */
  1,                                   /* colNo */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m"/* pName */
};

static emlrtRTEInfo e_emlrtRTEI = { 61,/* lineNo */
  1,                                   /* colNo */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m"/* pName */
};

static emlrtRTEInfo f_emlrtRTEI = { 59,/* lineNo */
  16,                                  /* colNo */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m"/* pName */
};

static emlrtDCInfo emlrtDCI = { 113,   /* lineNo */
  18,                                  /* colNo */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo emlrtBCI = { -1,    /* iFirst */
  -1,                                  /* iLast */
  113,                                 /* lineNo */
  18,                                  /* colNo */
  "matX",                              /* aName */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo b_emlrtDCI = { 113, /* lineNo */
  34,                                  /* colNo */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo b_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  113,                                 /* lineNo */
  34,                                  /* colNo */
  "matX",                              /* aName */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo c_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  114,                                 /* lineNo */
  18,                                  /* colNo */
  "matY",                              /* aName */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo d_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  114,                                 /* lineNo */
  34,                                  /* colNo */
  "matY",                              /* aName */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo e_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  142,                                 /* lineNo */
  26,                                  /* colNo */
  "YX",                                /* aName */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo f_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  143,                                 /* lineNo */
  26,                                  /* colNo */
  "XX",                                /* aName */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo g_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  151,                                 /* lineNo */
  22,                                  /* colNo */
  "strainTensor",                      /* aName */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo h_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  164,                                 /* lineNo */
  23,                                  /* colNo */
  "strainTensor",                      /* aName */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo i_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  110,                                 /* lineNo */
  17,                                  /* colNo */
  "BONDLIST",                          /* aName */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo j_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  111,                                 /* lineNo */
  17,                                  /* colNo */
  "BONDLIST",                          /* aName */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo k_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  118,                                 /* lineNo */
  17,                                  /* colNo */
  "fail",                              /* aName */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo l_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  125,                                 /* lineNo */
  17,                                  /* colNo */
  "XX",                                /* aName */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo m_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  125,                                 /* lineNo */
  40,                                  /* colNo */
  "XX",                                /* aName */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo n_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  126,                                 /* lineNo */
  17,                                  /* colNo */
  "XX",                                /* aName */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo o_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  126,                                 /* lineNo */
  40,                                  /* colNo */
  "XX",                                /* aName */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo p_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  129,                                 /* lineNo */
  17,                                  /* colNo */
  "YX",                                /* aName */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo q_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  129,                                 /* lineNo */
  40,                                  /* colNo */
  "YX",                                /* aName */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo r_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  130,                                 /* lineNo */
  17,                                  /* colNo */
  "YX",                                /* aName */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo s_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  130,                                 /* lineNo */
  40,                                  /* colNo */
  "YX",                                /* aName */
  "calculatestraintensor",             /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatestraintensor.m",/* pName */
  0                                    /* checkKind */
};

static emlrtRSInfo s_emlrtRSI = { 53,  /* lineNo */
  "flt2str",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2019a\\toolbox\\eml\\eml\\+coder\\+internal\\flt2str.m"/* pathName */
};

/* Function Declarations */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, char_T y[14]);
static const mxArray *b_sprintf(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, emlrtMCInfo *location);
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray
  *a__output_of_sprintf_, const char_T *identifier, char_T y[14]);
static void i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, char_T ret[14]);

/* Function Definitions */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, char_T y[14])
{
  i_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static const mxArray *b_sprintf(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, emlrtMCInfo *location)
{
  const mxArray *pArrays[2];
  const mxArray *m11;
  pArrays[0] = b;
  pArrays[1] = c;
  return emlrtCallMATLABR2012b(sp, 1, &m11, 2, pArrays, "sprintf", true,
    location);
}

static void emlrt_marshallIn(const emlrtStack *sp, const mxArray
  *a__output_of_sprintf_, const char_T *identifier, char_T y[14])
{
  emlrtMsgIdentifier thisId;
  emlrtAssertMATLABThread(sp, &c_emlrtRTEI);
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  b_emlrt_marshallIn(sp, emlrtAlias(a__output_of_sprintf_), &thisId, y);
  emlrtDestroyArray(&a__output_of_sprintf_);
}

static void i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, char_T ret[14])
{
  static const int32_T dims[2] = { 1, 14 };

  emlrtCheckBuiltInR2012b(sp, msgId, src, "char", false, 2U, dims);
  emlrtImportCharArrayR2015b(sp, src, &ret[0], 14);
  emlrtDestroyArray(&src);
}

void calculatestraintensor(const emlrtStack *sp, const emxArray_real_T
  *COORDINATES, const emxArray_real_T *disp, const emxArray_real_T *BONDLIST,
  const emxArray_real_T *fail, emxArray_real_T *strainTensor)
{
  emxArray_real_T *XX;
  int32_T i0;
  int32_T loop_ub;
  emxArray_real_T *YX;
  int32_T kBond;
  int32_T i1;
  real_T nodei;
  int32_T kNode;
  real_T F[9];
  real_T nodej;
  int32_T b_nodei;
  int32_T p1;
  int32_T p2;
  int32_T b_nodej;
  real_T X[3];
  real_T Y[3];
  int32_T p3;
  real_T absx11;
  real_T absx21;
  real_T absx31;
  int32_T itmp;
  real_T c[9];
  const mxArray *y;
  const mxArray *m0;
  static const int32_T iv0[2] = { 1, 6 };

  static const char_T rfmt[6] = { '%', '1', '4', '.', '6', 'e' };

  const mxArray *b_y;
  const mxArray *m1;
  char_T cv0[14];
  static const int8_T b_I[9] = { 1, 0, 0, 0, 1, 0, 0, 0, 1 };

  jmp_buf * volatile emlrtJBStack;
  emlrtStack st;
  jmp_buf b_emlrtJBEnviron;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  emlrtStack f_st;
  emlrtStack g_st;
  emlrtStack h_st;
  emlrtStack i_st;
  boolean_T emlrtHadParallelError = false;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  emxInit_real_T(sp, &XX, 3, &d_emlrtRTEI, true);

  /*  calculatestraintensor - returns the strain tensor at every node of a */
  /*  given set using state based theory with correspondency strategy. */
  /*  */
  /*  [strainTensor] = calculatestraintensor(COORDINATES,disp,nFAMILYMEMBERS,NODEFAMILY,NODEFAMILYPOINTERS,BONDLIST,fail) */
  /*  */
  /*  ------------------------------------------------------------------------- */
  /*  */
  /*  INPUT: */
  /*    undeformedCoordinates - matrix with the intial coordinates of the */
  /*    particles */
  /*    deformedCoordinates - matrix with the deformed coordinates of the */
  /*    particles */
  /*  */
  /*  OUTPUT: */
  /*    strainTensor - strain tensor for every particle */
  /*  */
  /*  ------------------------------------------------------------------------- */
  /*    [Input]  */
  /*    The first index of the input arrays corresponds to a particle number. */
  /*    matX: matrix with the initial coordinates of the particles */
  /*    matY: matrix with the deformed coordinates of the particles */
  /*    matFamilies: matrix with the node ID of the particles within  */
  /*    the material horizon of each point */
  /*    vecNFamily: number of particles in each family */
  /*    horizon_delta: material horizon (this is only necessary if the */
  /*    influence function is not constant) */
  /*     */
  /*    [Output] */
  /*    The first index of the output array corresponds to a particle number. */
  /*    vecmatEps: 3D array, where vecmatEps(k,:,:) is the strain tensor at */
  /*    the point k. */
  /*  */
  /*    Original Author: */
  /*    H. David Miranda */
  /*    University of Cambridge */
  /*    May 2018 */
  /*     */
  /*    Mark Hobbs (mch61@cam.ac.uk) */
  /*    University of Cambridge */
  /*    May 2019 */
  /*  */
  /*    References: */
  /*    "Peridynamic states and constitutive modeling" */
  /*    SA Silling, M Epton, O Weckner, J Xu, E Askari */
  /*    Journal of Elasticity 88 (2), 151-184 */
  /*  TODO: Include failure of bonds */
  /*  matX contains the initial coordinates of a particle */
  /*  matY contains the deformed coordinates of a particle */
  /*  number of particles */
  /*  number of dimensions */
  /*  number of bonds */
  i0 = XX->size[0] * XX->size[1] * XX->size[2];
  XX->size[0] = COORDINATES->size[0];
  XX->size[1] = 3;
  XX->size[2] = 3;
  emxEnsureCapacity_real_T(sp, XX, i0, &d_emlrtRTEI);
  loop_ub = COORDINATES->size[0] * 3 * 3;
  for (i0 = 0; i0 < loop_ub; i0++) {
    XX->data[i0] = 0.0;
  }

  emxInit_real_T(sp, &YX, 3, &e_emlrtRTEI, true);
  i0 = YX->size[0] * YX->size[1] * YX->size[2];
  YX->size[0] = COORDINATES->size[0];
  YX->size[1] = 3;
  YX->size[2] = 3;
  emxEnsureCapacity_real_T(sp, YX, i0, &e_emlrtRTEI);
  loop_ub = COORDINATES->size[0] * 3 * 3;
  for (i0 = 0; i0 < loop_ub; i0++) {
    YX->data[i0] = 0.0;
  }

  /*  identity matrix */
  /*  Node lists */
  /*  tic */
  /*  for nodei = 1 : nNODES % loop all particles */
  /*           */
  /*      % loop all the points within the family of node i */
  /*      XX = zeros(NOD); % tensor product X * X */
  /*      YX = zeros(NOD); % tensor product Y * Y */
  /*   */
  /*      for j = 1 : nFAMILYMEMBERS(nodei) */
  /*           */
  /*          nodej = NODEFAMILY(NODEFAMILYPOINTERS(nodei)+(j-1),1); */
  /*          X = matX(nodej,:) - matX(nodei,:); */
  /*          Y = matY(nodej,:) - matY(nodei,:); */
  /*           */
  /*          % Compute the influence function omega(X), here I'll simply assume: */
  /*          omega = 1;  %kn = 2; omega = (1-norm(X)/ delta)^kn; % example of a quadratic function  */
  /*   */
  /*          % compute XX and XY by assemblage */
  /*          for row=1:NOD */
  /*              for column=1:NOD */
  /*                  % XX is the shape tensor K */
  /*                  XX(row,column) = XX(row,column) + (X(row) * X(column) * omega); */
  /*                  YX(row,column) = YX(row,column) + (Y(row) * X(column) * omega); */
  /*              end */
  /*          end */
  /*   */
  /*      end */
  /*   */
  /*      if det(XX) > 1e-20 % this is to avoid singularities */
  /*          F = YX*XX^-1; % calculate deformation gradient */
  /*           */
  /*          % convert deformation gradient into small strains - Operator ' complex conjugate transpose */
  /*          % See this webpage http://www.continuummechanics.org/smallstrain.html */
  /*          strainTensor(nodei,:,:) = 0.5 * (F + F') - I;      */
  /*      end */
  /*           */
  /*  end */
  /*  toc     */
  /*  Bond lists  */
  /*  Loop bond list */
  i0 = BONDLIST->size[0];
  for (kBond = 0; kBond < i0; kBond++) {
    i1 = BONDLIST->size[0];
    loop_ub = 1 + kBond;
    if ((loop_ub < 1) || (loop_ub > i1)) {
      emlrtDynamicBoundsCheckR2012b(loop_ub, 1, i1, &i_emlrtBCI, sp);
    }

    nodei = BONDLIST->data[loop_ub - 1];

    /*  Node i */
    i1 = BONDLIST->size[0];
    loop_ub = 1 + kBond;
    if ((loop_ub < 1) || (loop_ub > i1)) {
      emlrtDynamicBoundsCheckR2012b(loop_ub, 1, i1, &j_emlrtBCI, sp);
    }

    nodej = BONDLIST->data[(loop_ub + BONDLIST->size[0]) - 1];

    /*  Node j */
    if (nodei != (int32_T)muDoubleScalarFloor(nodei)) {
      emlrtIntegerCheckR2012b(nodei, &emlrtDCI, sp);
    }

    i1 = COORDINATES->size[0];
    b_nodei = (int32_T)nodei;
    if ((b_nodei < 1) || (b_nodei > i1)) {
      emlrtDynamicBoundsCheckR2012b(b_nodei, 1, i1, &emlrtBCI, sp);
    }

    if (nodej != (int32_T)muDoubleScalarFloor(nodej)) {
      emlrtIntegerCheckR2012b(nodej, &b_emlrtDCI, sp);
    }

    i1 = COORDINATES->size[0];
    b_nodej = (int32_T)nodej;
    if ((b_nodej < 1) || (b_nodej > i1)) {
      emlrtDynamicBoundsCheckR2012b(b_nodej, 1, i1, &b_emlrtBCI, sp);
    }

    X[0] = COORDINATES->data[b_nodei - 1] - COORDINATES->data[b_nodej - 1];
    X[1] = COORDINATES->data[(b_nodei + COORDINATES->size[0]) - 1] -
      COORDINATES->data[(b_nodej + COORDINATES->size[0]) - 1];
    X[2] = COORDINATES->data[(b_nodei + (COORDINATES->size[0] << 1)) - 1] -
      COORDINATES->data[(b_nodej + (COORDINATES->size[0] << 1)) - 1];

    /*  matX contains the initial coordinates of a particle  */
    i1 = disp->size[0];
    if ((b_nodei < 1) || (b_nodei > i1)) {
      emlrtDynamicBoundsCheckR2012b(b_nodei, 1, i1, &c_emlrtBCI, sp);
    }

    i1 = disp->size[0];
    if ((b_nodej < 1) || (b_nodej > i1)) {
      emlrtDynamicBoundsCheckR2012b(b_nodej, 1, i1, &d_emlrtBCI, sp);
    }

    Y[0] = disp->data[b_nodei - 1] - disp->data[b_nodej - 1];
    Y[1] = disp->data[(b_nodei + disp->size[0]) - 1] - disp->data[(b_nodej +
      disp->size[0]) - 1];
    Y[2] = disp->data[(b_nodei + (disp->size[0] << 1)) - 1] - disp->data
      [(b_nodej + (disp->size[0] << 1)) - 1];

    /*  matY contains the deformed coordinates of a particle */
    /*  Compute the influence function omega(X) */
    /* kn = 2; omega = (1-norm(X)/ delta)^kn; % example of a quadratic function  */
    i1 = fail->size[0];
    loop_ub = 1 + kBond;
    if ((loop_ub < 1) || (loop_ub > i1)) {
      emlrtDynamicBoundsCheckR2012b(loop_ub, 1, i1, &k_emlrtBCI, sp);
    }

    nodei = fail->data[loop_ub - 1];

    /*  Exclude damaged bonds from the calculation of the deformation gradient  */
    for (loop_ub = 0; loop_ub < 3; loop_ub++) {
      /*  XX - Shape Tensor (see Definition 3.4 Eq 17)    */
      i1 = XX->size[0];
      if ((b_nodei < 1) || (b_nodei > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodei, 1, i1, &l_emlrtBCI, sp);
      }

      i1 = XX->size[0];
      if ((b_nodei < 1) || (b_nodei > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodei, 1, i1, &m_emlrtBCI, sp);
      }

      nodej = X[loop_ub] * X[0] * nodei;
      XX->data[(b_nodei + XX->size[0] * loop_ub) - 1] += nodej;
      i1 = XX->size[0];
      if ((b_nodej < 1) || (b_nodej > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodej, 1, i1, &n_emlrtBCI, sp);
      }

      i1 = XX->size[0];
      if ((b_nodej < 1) || (b_nodej > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodej, 1, i1, &o_emlrtBCI, sp);
      }

      XX->data[(b_nodej + XX->size[0] * loop_ub) - 1] += nodej;

      /*  YX -  */
      i1 = YX->size[0];
      if ((b_nodei < 1) || (b_nodei > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodei, 1, i1, &p_emlrtBCI, sp);
      }

      i1 = YX->size[0];
      if ((b_nodei < 1) || (b_nodei > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodei, 1, i1, &q_emlrtBCI, sp);
      }

      nodej = Y[loop_ub] * X[0] * nodei;
      YX->data[(b_nodei + YX->size[0] * loop_ub) - 1] += nodej;
      i1 = YX->size[0];
      if ((b_nodej < 1) || (b_nodej > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodej, 1, i1, &r_emlrtBCI, sp);
      }

      i1 = YX->size[0];
      if ((b_nodej < 1) || (b_nodej > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodej, 1, i1, &s_emlrtBCI, sp);
      }

      YX->data[(b_nodej + YX->size[0] * loop_ub) - 1] += nodej;
      if (*emlrtBreakCheckR2012bFlagVar != 0) {
        emlrtBreakCheckR2012b(sp);
      }

      /*  XX - Shape Tensor (see Definition 3.4 Eq 17)    */
      i1 = XX->size[0];
      if ((b_nodei < 1) || (b_nodei > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodei, 1, i1, &l_emlrtBCI, sp);
      }

      i1 = XX->size[0];
      if ((b_nodei < 1) || (b_nodei > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodei, 1, i1, &m_emlrtBCI, sp);
      }

      nodej = X[loop_ub] * X[1] * nodei;
      XX->data[((b_nodei + XX->size[0] * loop_ub) + XX->size[0] * 3) - 1] +=
        nodej;
      i1 = XX->size[0];
      if ((b_nodej < 1) || (b_nodej > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodej, 1, i1, &n_emlrtBCI, sp);
      }

      i1 = XX->size[0];
      if ((b_nodej < 1) || (b_nodej > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodej, 1, i1, &o_emlrtBCI, sp);
      }

      XX->data[((b_nodej + XX->size[0] * loop_ub) + XX->size[0] * 3) - 1] +=
        nodej;

      /*  YX -  */
      i1 = YX->size[0];
      if ((b_nodei < 1) || (b_nodei > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodei, 1, i1, &p_emlrtBCI, sp);
      }

      i1 = YX->size[0];
      if ((b_nodei < 1) || (b_nodei > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodei, 1, i1, &q_emlrtBCI, sp);
      }

      nodej = Y[loop_ub] * X[1] * nodei;
      YX->data[((b_nodei + YX->size[0] * loop_ub) + YX->size[0] * 3) - 1] +=
        nodej;
      i1 = YX->size[0];
      if ((b_nodej < 1) || (b_nodej > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodej, 1, i1, &r_emlrtBCI, sp);
      }

      i1 = YX->size[0];
      if ((b_nodej < 1) || (b_nodej > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodej, 1, i1, &s_emlrtBCI, sp);
      }

      YX->data[((b_nodej + YX->size[0] * loop_ub) + YX->size[0] * 3) - 1] +=
        nodej;
      if (*emlrtBreakCheckR2012bFlagVar != 0) {
        emlrtBreakCheckR2012b(sp);
      }

      /*  XX - Shape Tensor (see Definition 3.4 Eq 17)    */
      i1 = XX->size[0];
      if ((b_nodei < 1) || (b_nodei > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodei, 1, i1, &l_emlrtBCI, sp);
      }

      i1 = XX->size[0];
      if ((b_nodei < 1) || (b_nodei > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodei, 1, i1, &m_emlrtBCI, sp);
      }

      nodej = X[loop_ub] * X[2] * nodei;
      XX->data[((b_nodei + XX->size[0] * loop_ub) + ((XX->size[0] * 3) << 1)) -
        1] += nodej;
      i1 = XX->size[0];
      if ((b_nodej < 1) || (b_nodej > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodej, 1, i1, &n_emlrtBCI, sp);
      }

      i1 = XX->size[0];
      if ((b_nodej < 1) || (b_nodej > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodej, 1, i1, &o_emlrtBCI, sp);
      }

      XX->data[((b_nodej + XX->size[0] * loop_ub) + ((XX->size[0] * 3) << 1)) -
        1] += nodej;

      /*  YX -  */
      i1 = YX->size[0];
      if ((b_nodei < 1) || (b_nodei > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodei, 1, i1, &p_emlrtBCI, sp);
      }

      i1 = YX->size[0];
      if ((b_nodei < 1) || (b_nodei > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodei, 1, i1, &q_emlrtBCI, sp);
      }

      nodej = Y[loop_ub] * X[2] * nodei;
      YX->data[((b_nodei + YX->size[0] * loop_ub) + ((YX->size[0] * 3) << 1)) -
        1] += nodej;
      i1 = YX->size[0];
      if ((b_nodej < 1) || (b_nodej > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodej, 1, i1, &r_emlrtBCI, sp);
      }

      i1 = YX->size[0];
      if ((b_nodej < 1) || (b_nodej > i1)) {
        emlrtDynamicBoundsCheckR2012b(b_nodej, 1, i1, &s_emlrtBCI, sp);
      }

      YX->data[((b_nodej + YX->size[0] * loop_ub) + ((YX->size[0] * 3) << 1)) -
        1] += nodej;
      if (*emlrtBreakCheckR2012bFlagVar != 0) {
        emlrtBreakCheckR2012b(sp);
      }

      if (*emlrtBreakCheckR2012bFlagVar != 0) {
        emlrtBreakCheckR2012b(sp);
      }
    }

    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(sp);
    }
  }

  i0 = COORDINATES->size[0];
  i1 = strainTensor->size[0] * strainTensor->size[1] * strainTensor->size[2];
  strainTensor->size[0] = COORDINATES->size[0];
  strainTensor->size[1] = 3;
  strainTensor->size[2] = 3;
  emxEnsureCapacity_real_T(sp, strainTensor, i1, &f_emlrtRTEI);
  loop_ub = i0 - 1;
  emlrtEnterParallelRegion(sp, omp_in_parallel());
  emlrtPushJmpBuf(sp, &emlrtJBStack);

#pragma omp parallel \
 num_threads(emlrtAllocRegionTLSs(sp->tls, omp_in_parallel(), omp_get_max_threads(), omp_get_num_procs())) \
 private(F,b_emlrtJBEnviron,i_st,p1,p2,p3,absx11,absx21,absx31,itmp,c,y,m0,b_y,m1,cv0) \
 firstprivate(st,b_st,c_st,d_st,e_st,f_st,g_st,h_st,emlrtHadParallelError)

  {
    if (setjmp(b_emlrtJBEnviron) == 0) {
      st.prev = sp;
      st.tls = emlrtAllocTLS(sp, omp_get_thread_num());
      st.site = NULL;
      emlrtSetJmpBuf(&st, &b_emlrtJBEnviron);
      b_st.prev = &st;
      b_st.tls = st.tls;
      c_st.prev = &b_st;
      c_st.tls = b_st.tls;
      d_st.prev = &c_st;
      d_st.tls = c_st.tls;
      e_st.prev = &d_st;
      e_st.tls = d_st.tls;
      f_st.prev = &e_st;
      f_st.tls = e_st.tls;
      g_st.prev = &f_st;
      g_st.tls = f_st.tls;
      h_st.prev = &g_st;
      h_st.tls = g_st.tls;
      i_st.prev = &h_st;
      i_st.tls = h_st.tls;
    } else {
      emlrtHadParallelError = true;
    }

#pragma omp for nowait

    for (kNode = 0; kNode <= loop_ub; kNode++) {
      if (emlrtHadParallelError)
        continue;
      if (setjmp(b_emlrtJBEnviron) == 0) {
        /*  Loop nodes - runs faster in parfor loop */
        p1 = YX->size[0];
        p2 = 1 + kNode;
        if ((p2 < 1) || (p2 > p1)) {
          emlrtDynamicBoundsCheckR2012b(p2, 1, p1, &e_emlrtBCI, &st);
        }

        /*  Remove dimensions of length 1 */
        p1 = XX->size[0];
        p2 = 1 + kNode;
        if ((p2 < 1) || (p2 > p1)) {
          emlrtDynamicBoundsCheckR2012b(p2, 1, p1, &f_emlrtBCI, &st);
        }

        /*  Remove dimensions of length 1 */
        for (p1 = 0; p1 < 3; p1++) {
          F[3 * p1] = XX->data[kNode + XX->size[0] * 3 * p1];
          F[1 + 3 * p1] = XX->data[(kNode + XX->size[0]) + XX->size[0] * 3 * p1];
          F[2 + 3 * p1] = XX->data[(kNode + (XX->size[0] << 1)) + XX->size[0] *
            3 * p1];
        }

        b_st.site = &emlrtRSI;
        if (det(&b_st, F) > 1.0E-20) {
          /*  this is to avoid singularities % damage(kNode) < 0.1  */
          b_st.site = &b_emlrtRSI;
          c_st.site = &l_emlrtRSI;
          d_st.site = &m_emlrtRSI;
          e_st.site = &n_emlrtRSI;
          f_st.site = &o_emlrtRSI;
          for (p1 = 0; p1 < 3; p1++) {
            F[3 * p1] = XX->data[kNode + XX->size[0] * 3 * p1];
            F[1 + 3 * p1] = XX->data[(kNode + XX->size[0]) + XX->size[0] * 3 *
              p1];
            F[2 + 3 * p1] = XX->data[(kNode + (XX->size[0] << 1)) + XX->size[0] *
              3 * p1];
          }

          p1 = 0;
          p2 = 3;
          p3 = 6;
          absx11 = muDoubleScalarAbs(XX->data[kNode]);
          absx21 = muDoubleScalarAbs(XX->data[kNode + XX->size[0]]);
          absx31 = muDoubleScalarAbs(XX->data[kNode + (XX->size[0] << 1)]);
          if ((absx21 > absx11) && (absx21 > absx31)) {
            p1 = 3;
            p2 = 0;
            F[0] = XX->data[kNode + XX->size[0]];
            F[1] = XX->data[kNode];
            F[3] = XX->data[(kNode + XX->size[0]) + XX->size[0] * 3];
            F[4] = XX->data[kNode + XX->size[0] * 3];
            F[6] = XX->data[(kNode + XX->size[0]) + ((XX->size[0] * 3) << 1)];
            F[7] = XX->data[kNode + ((XX->size[0] * 3) << 1)];
          } else {
            if (absx31 > absx11) {
              p1 = 6;
              p3 = 0;
              F[0] = XX->data[kNode + (XX->size[0] << 1)];
              F[2] = XX->data[kNode];
              F[3] = XX->data[(kNode + (XX->size[0] << 1)) + XX->size[0] * 3];
              F[5] = XX->data[kNode + XX->size[0] * 3];
              F[6] = XX->data[(kNode + (XX->size[0] << 1)) + ((XX->size[0] * 3) <<
                1)];
              F[8] = XX->data[kNode + ((XX->size[0] * 3) << 1)];
            }
          }

          F[1] /= F[0];
          F[2] /= F[0];
          F[4] -= F[1] * F[3];
          F[5] -= F[2] * F[3];
          F[7] -= F[1] * F[6];
          F[8] -= F[2] * F[6];
          if (muDoubleScalarAbs(F[5]) > muDoubleScalarAbs(F[4])) {
            itmp = p2;
            p2 = p3;
            p3 = itmp;
            absx11 = F[1];
            F[1] = F[2];
            F[2] = absx11;
            absx11 = F[4];
            F[4] = F[5];
            F[5] = absx11;
            absx11 = F[7];
            F[7] = F[8];
            F[8] = absx11;
          }

          F[5] /= F[4];
          F[8] -= F[5] * F[7];
          absx11 = (F[5] * F[1] - F[2]) / F[8];
          absx21 = -(F[1] + F[7] * absx11) / F[4];
          c[p1] = ((1.0 - F[3] * absx21) - F[6] * absx11) / F[0];
          c[p1 + 1] = absx21;
          c[p1 + 2] = absx11;
          absx11 = -F[5] / F[8];
          absx21 = (1.0 - F[7] * absx11) / F[4];
          c[p2] = -(F[3] * absx21 + F[6] * absx11) / F[0];
          c[p2 + 1] = absx21;
          c[p2 + 2] = absx11;
          absx11 = 1.0 / F[8];
          absx21 = -F[7] * absx11 / F[4];
          c[p3] = -(F[3] * absx21 + F[6] * absx11) / F[0];
          c[p3 + 1] = absx21;
          c[p3 + 2] = absx11;
          g_st.site = &p_emlrtRSI;
          for (p1 = 0; p1 < 3; p1++) {
            F[3 * p1] = XX->data[kNode + XX->size[0] * 3 * p1];
            F[1 + 3 * p1] = XX->data[(kNode + XX->size[0]) + XX->size[0] * 3 *
              p1];
            F[2 + 3 * p1] = XX->data[(kNode + (XX->size[0] << 1)) + XX->size[0] *
              3 * p1];
          }

          absx11 = b_norm(F);
          absx21 = b_norm(c);
          absx31 = 1.0 / (absx11 * absx21);
          if ((absx11 == 0.0) || (absx21 == 0.0) || (absx31 == 0.0)) {
            if (!emlrtSetWarningFlag(&g_st)) {
              h_st.site = &q_emlrtRSI;
              warning(&h_st);
            }
          } else {
            if ((muDoubleScalarIsNaN(absx31) || (absx31 < 2.2204460492503131E-16))
                && (!emlrtSetWarningFlag(&g_st))) {
              h_st.site = &r_emlrtRSI;
              emlrtAssertMATLABThread(&h_st, &b_emlrtRTEI);
              y = NULL;
              m0 = emlrtCreateCharArray(2, iv0);
              emlrtInitCharArrayR2013a(&h_st, 6, m0, &rfmt[0]);
              emlrtAssign(&y, m0);
              b_y = NULL;
              m1 = emlrtCreateDoubleScalar(absx31);
              emlrtAssign(&b_y, m1);
              i_st.site = &s_emlrtRSI;
              emlrt_marshallIn(&i_st, b_sprintf(&i_st, y, b_y, &c_emlrtMCI),
                               "<output of sprintf>", cv0);
              h_st.site = &r_emlrtRSI;
              b_warning(&h_st, cv0);
            }
          }

          for (p1 = 0; p1 < 3; p1++) {
            for (p2 = 0; p2 < 3; p2++) {
              absx11 = YX->data[kNode + YX->size[0] * p1] * c[3 * p2];
              absx11 += YX->data[(kNode + YX->size[0] * p1) + YX->size[0] * 3] *
                c[1 + 3 * p2];
              absx11 += YX->data[(kNode + YX->size[0] * p1) + ((YX->size[0] * 3)
                << 1)] * c[2 + 3 * p2];
              p3 = p1 + 3 * p2;
              F[p3] = absx11 + (real_T)b_I[p3];
            }
          }

          /*  calculate deformation gradient */
          /*  convert deformation gradient into small strains - Operator ' complex conjugate transpose */
          /*  See this webpage http://www.continuummechanics.org/smallstrain.html */
          p1 = strainTensor->size[0];
          p2 = 1 + kNode;
          if ((p2 < 1) || (p2 > p1)) {
            emlrtDynamicBoundsCheckR2012b(p2, 1, p1, &g_emlrtBCI, &st);
          }

          for (p1 = 0; p1 < 3; p1++) {
            strainTensor->data[kNode + strainTensor->size[0] * 3 * p1] = 0.5 *
              (F[3 * p1] + F[p1]) - (real_T)b_I[3 * p1];
            p2 = 1 + 3 * p1;
            strainTensor->data[(kNode + strainTensor->size[0]) +
              strainTensor->size[0] * 3 * p1] = 0.5 * (F[p2] + F[p1 + 3]) -
              (real_T)b_I[p2];
            p2 = 2 + 3 * p1;
            strainTensor->data[(kNode + (strainTensor->size[0] << 1)) +
              strainTensor->size[0] * 3 * p1] = 0.5 * (F[p2] + F[p1 + 6]) -
              (real_T)b_I[p2];
          }

          /*  Small deformations */
          /* strainTensor(kNode,:,:) = 0.5 * (I - inv(F') * inv(F));  % Large deformations (need to check the correct formula) */
          /*          if damage(kNode) > 0.5 */
          /*               */
          /*              strainTensor(kNode,:,:) = zeros(3); */
          /*               */
          /*          end */
        } else {
          p1 = strainTensor->size[0];
          p2 = 1 + kNode;
          if ((p2 < 1) || (p2 > p1)) {
            emlrtDynamicBoundsCheckR2012b(p2, 1, p1, &h_emlrtBCI, &st);
          }

          for (p1 = 0; p1 < 3; p1++) {
            strainTensor->data[kNode + strainTensor->size[0] * 3 * p1] = 0.0;
            strainTensor->data[(kNode + strainTensor->size[0]) +
              strainTensor->size[0] * 3 * p1] = 0.0;
            strainTensor->data[(kNode + (strainTensor->size[0] << 1)) +
              strainTensor->size[0] * 3 * p1] = 0.0;
          }

          /*  Small deformations */
        }

        if (*emlrtBreakCheckR2012bFlagVar != 0) {
          emlrtBreakCheckR2012b(&st);
        }
      } else {
        emlrtHadParallelError = true;
      }
    }
  }

  emlrtPopJmpBuf(sp, &emlrtJBStack);
  emlrtExitParallelRegion(sp, omp_in_parallel());
  emxFree_real_T(&YX);
  emxFree_real_T(&XX);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (calculatestraintensor.c) */
