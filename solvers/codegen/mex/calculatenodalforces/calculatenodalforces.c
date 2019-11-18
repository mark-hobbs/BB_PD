/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * calculatenodalforces.c
 *
 * Code generation for function 'calculatenodalforces'
 *
 */

/* Include files */
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "calculatenodalforces.h"
#include "calculatenodalforces_emxutil.h"
#include "calculatenodalforces_data.h"

/* Variable Definitions */
static emlrtRTEInfo b_emlrtRTEI = { 27,/* lineNo */
  38,                                  /* colNo */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m"/* pName */
};

static emlrtRTEInfo c_emlrtRTEI = { 27,/* lineNo */
  19,                                  /* colNo */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m"/* pName */
};

static emlrtECInfo emlrtECI = { 2,     /* nDims */
  27,                                  /* lineNo */
  19,                                  /* colNo */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m"/* pName */
};

static emlrtECInfo b_emlrtECI = { -1,  /* nDims */
  27,                                  /* lineNo */
  1,                                   /* colNo */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m"/* pName */
};

static emlrtBCInfo emlrtBCI = { -1,    /* iFirst */
  -1,                                  /* iLast */
  9,                                   /* lineNo */
  13,                                  /* colNo */
  "BONDLIST",                          /* aName */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo b_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  10,                                  /* lineNo */
  13,                                  /* colNo */
  "BONDLIST",                          /* aName */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo c_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  13,                                  /* lineNo */
  27,                                  /* colNo */
  "nodalForce",                        /* aName */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo emlrtDCI = { 13,    /* lineNo */
  27,                                  /* colNo */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo d_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  13,                                  /* lineNo */
  49,                                  /* colNo */
  "bForceX",                           /* aName */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo e_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  13,                                  /* lineNo */
  5,                                   /* colNo */
  "nodalForce",                        /* aName */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo b_emlrtDCI = { 13,  /* lineNo */
  5,                                   /* colNo */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo f_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  14,                                  /* lineNo */
  27,                                  /* colNo */
  "nodalForce",                        /* aName */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo c_emlrtDCI = { 14,  /* lineNo */
  27,                                  /* colNo */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo g_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  14,                                  /* lineNo */
  49,                                  /* colNo */
  "bForceX",                           /* aName */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo h_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  14,                                  /* lineNo */
  5,                                   /* colNo */
  "nodalForce",                        /* aName */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo d_emlrtDCI = { 14,  /* lineNo */
  5,                                   /* colNo */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo i_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  17,                                  /* lineNo */
  27,                                  /* colNo */
  "nodalForce",                        /* aName */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo j_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  17,                                  /* lineNo */
  49,                                  /* colNo */
  "bForceY",                           /* aName */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo k_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  17,                                  /* lineNo */
  5,                                   /* colNo */
  "nodalForce",                        /* aName */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo l_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  18,                                  /* lineNo */
  27,                                  /* colNo */
  "nodalForce",                        /* aName */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo m_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  18,                                  /* lineNo */
  49,                                  /* colNo */
  "bForceY",                           /* aName */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo n_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  18,                                  /* lineNo */
  5,                                   /* colNo */
  "nodalForce",                        /* aName */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo o_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  21,                                  /* lineNo */
  27,                                  /* colNo */
  "nodalForce",                        /* aName */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo p_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  21,                                  /* lineNo */
  49,                                  /* colNo */
  "bForceZ",                           /* aName */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo q_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  21,                                  /* lineNo */
  5,                                   /* colNo */
  "nodalForce",                        /* aName */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo r_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  22,                                  /* lineNo */
  27,                                  /* colNo */
  "nodalForce",                        /* aName */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo s_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  22,                                  /* lineNo */
  49,                                  /* colNo */
  "bForceZ",                           /* aName */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo t_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  22,                                  /* lineNo */
  5,                                   /* colNo */
  "nodalForce",                        /* aName */
  "calculatenodalforces",              /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void calculatenodalforces(const emlrtStack *sp, const emxArray_real_T *BONDLIST,
  emxArray_real_T *nodalForce, const emxArray_real_T *bForceX, const
  emxArray_real_T *bForceY, const emxArray_real_T *bForceZ, const
  emxArray_real_T *BODYFORCEFLAG, real_T MAXBODYFORCE)
{
  int32_T loop_ub;
  int32_T i3;
  int32_T i4;
  emxArray_real_T *b_nodalForce;
  int32_T i5;
  real_T nodei;
  int32_T iv3[2];
  real_T nodej;
  int32_T c_nodalForce[2];
  real_T d0;
  int32_T i6;
  int32_T i7;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  loop_ub = nodalForce->size[0];
  for (i3 = 0; i3 < 3; i3++) {
    for (i4 = 0; i4 < loop_ub; i4++) {
      nodalForce->data[i4 + nodalForce->size[0] * i3] = 0.0;
    }
  }

  /*  Nodal force - initialise for every time step */
  /*  Calculate the nodal force (N/m^3) for every node, iterate over the bond list */
  i3 = BONDLIST->size[0];
  for (loop_ub = 0; loop_ub < i3; loop_ub++) {
    i4 = BONDLIST->size[0];
    i5 = 1 + loop_ub;
    if ((i5 < 1) || (i5 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i5, 1, i4, &emlrtBCI, sp);
    }

    nodei = BONDLIST->data[i5 - 1];

    /*  Node i */
    i4 = BONDLIST->size[0];
    i5 = 1 + loop_ub;
    if ((i5 < 1) || (i5 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i5, 1, i4, &b_emlrtBCI, sp);
    }

    nodej = BONDLIST->data[(i5 + BONDLIST->size[0]) - 1];

    /*  Node j */
    /*  X-component */
    i4 = nodalForce->size[0];
    d0 = (int32_T)muDoubleScalarFloor(nodei);
    if (nodei != d0) {
      emlrtIntegerCheckR2012b(nodei, &emlrtDCI, sp);
    }

    i5 = (int32_T)nodei;
    if ((i5 < 1) || (i5 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i5, 1, i4, &c_emlrtBCI, sp);
    }

    i4 = bForceX->size[0];
    i6 = 1 + loop_ub;
    if ((i6 < 1) || (i6 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i6, 1, i4, &d_emlrtBCI, sp);
    }

    i4 = nodalForce->size[0];
    if (nodei != d0) {
      emlrtIntegerCheckR2012b(nodei, &b_emlrtDCI, sp);
    }

    if ((i5 < 1) || (i5 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i5, 1, i4, &e_emlrtBCI, sp);
    }

    nodalForce->data[i5 - 1] += bForceX->data[i6 - 1];

    /*  Bond force is positive on Node i  */
    i4 = nodalForce->size[0];
    d0 = (int32_T)muDoubleScalarFloor(nodej);
    if (nodej != d0) {
      emlrtIntegerCheckR2012b(nodej, &c_emlrtDCI, sp);
    }

    i6 = (int32_T)nodej;
    if ((i6 < 1) || (i6 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i6, 1, i4, &f_emlrtBCI, sp);
    }

    i4 = bForceX->size[0];
    i7 = 1 + loop_ub;
    if ((i7 < 1) || (i7 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i7, 1, i4, &g_emlrtBCI, sp);
    }

    i4 = nodalForce->size[0];
    if (nodej != d0) {
      emlrtIntegerCheckR2012b(nodej, &d_emlrtDCI, sp);
    }

    if ((i6 < 1) || (i6 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i6, 1, i4, &h_emlrtBCI, sp);
    }

    nodalForce->data[i6 - 1] -= bForceX->data[i7 - 1];

    /*  Bond force is negative on Node j */
    /*  Y-component */
    i4 = nodalForce->size[0];
    if ((i5 < 1) || (i5 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i5, 1, i4, &i_emlrtBCI, sp);
    }

    i4 = bForceY->size[0];
    i7 = 1 + loop_ub;
    if ((i7 < 1) || (i7 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i7, 1, i4, &j_emlrtBCI, sp);
    }

    i4 = nodalForce->size[0];
    if ((i5 < 1) || (i5 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i5, 1, i4, &k_emlrtBCI, sp);
    }

    nodalForce->data[(i5 + nodalForce->size[0]) - 1] += bForceY->data[i7 - 1];
    i4 = nodalForce->size[0];
    if ((i6 < 1) || (i6 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i6, 1, i4, &l_emlrtBCI, sp);
    }

    i4 = bForceY->size[0];
    i7 = 1 + loop_ub;
    if ((i7 < 1) || (i7 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i7, 1, i4, &m_emlrtBCI, sp);
    }

    i4 = nodalForce->size[0];
    if ((i6 < 1) || (i6 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i6, 1, i4, &n_emlrtBCI, sp);
    }

    nodalForce->data[(i6 + nodalForce->size[0]) - 1] -= bForceY->data[i7 - 1];

    /*  Z-component */
    i4 = nodalForce->size[0];
    if ((i5 < 1) || (i5 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i5, 1, i4, &o_emlrtBCI, sp);
    }

    i4 = bForceZ->size[0];
    i7 = 1 + loop_ub;
    if ((i7 < 1) || (i7 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i7, 1, i4, &p_emlrtBCI, sp);
    }

    i4 = nodalForce->size[0];
    if ((i5 < 1) || (i5 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i5, 1, i4, &q_emlrtBCI, sp);
    }

    nodalForce->data[(i5 + (nodalForce->size[0] << 1)) - 1] += bForceZ->data[i7
      - 1];
    i4 = nodalForce->size[0];
    if ((i6 < 1) || (i6 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i6, 1, i4, &r_emlrtBCI, sp);
    }

    i4 = bForceZ->size[0];
    i5 = 1 + loop_ub;
    if ((i5 < 1) || (i5 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i5, 1, i4, &s_emlrtBCI, sp);
    }

    i4 = nodalForce->size[0];
    if ((i6 < 1) || (i6 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i6, 1, i4, &t_emlrtBCI, sp);
    }

    nodalForce->data[(i6 + (nodalForce->size[0] << 1)) - 1] -= bForceZ->data[i5
      - 1];
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(sp);
    }
  }

  emxInit_real_T(sp, &b_nodalForce, 2, &c_emlrtRTEI, true);

  /*  Add body force (N/m^3) */
  loop_ub = BODYFORCEFLAG->size[0];
  i3 = b_nodalForce->size[0] * b_nodalForce->size[1];
  b_nodalForce->size[0] = loop_ub;
  b_nodalForce->size[1] = 3;
  emxEnsureCapacity_real_T(sp, b_nodalForce, i3, &b_emlrtRTEI);
  for (i3 = 0; i3 < 3; i3++) {
    for (i4 = 0; i4 < loop_ub; i4++) {
      b_nodalForce->data[i4 + b_nodalForce->size[0] * i3] = BODYFORCEFLAG->
        data[i4 + BODYFORCEFLAG->size[0] * i3] * MAXBODYFORCE;
    }
  }

  i3 = nodalForce->size[0];
  iv3[0] = i3;
  iv3[1] = 3;
  c_nodalForce[0] = b_nodalForce->size[0];
  c_nodalForce[1] = b_nodalForce->size[1];
  if ((i3 != c_nodalForce[0]) || (3 != c_nodalForce[1])) {
    emlrtSizeEqCheckNDR2012b(&iv3[0], &c_nodalForce[0], &emlrtECI, sp);
  }

  i3 = nodalForce->size[0];
  i4 = nodalForce->size[0];
  iv3[0] = i3;
  iv3[1] = 3;
  c_nodalForce[0] = i4;
  c_nodalForce[1] = 3;
  emlrtSubAssignSizeCheckR2012b(&iv3[0], 2, &c_nodalForce[0], 2, &b_emlrtECI, sp);
  loop_ub = nodalForce->size[0] - 1;
  i3 = b_nodalForce->size[0] * b_nodalForce->size[1];
  b_nodalForce->size[0] = loop_ub + 1;
  b_nodalForce->size[1] = 3;
  emxEnsureCapacity_real_T(sp, b_nodalForce, i3, &c_emlrtRTEI);
  for (i3 = 0; i3 < 3; i3++) {
    for (i4 = 0; i4 <= loop_ub; i4++) {
      b_nodalForce->data[i4 + b_nodalForce->size[0] * i3] += nodalForce->data[i4
        + nodalForce->size[0] * i3];
    }
  }

  for (i3 = 0; i3 < 3; i3++) {
    loop_ub = b_nodalForce->size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      nodalForce->data[i4 + nodalForce->size[0] * i3] = b_nodalForce->data[i4 +
        b_nodalForce->size[0] * i3];
    }
  }

  emxFree_real_T(&b_nodalForce);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (calculatenodalforces.c) */
