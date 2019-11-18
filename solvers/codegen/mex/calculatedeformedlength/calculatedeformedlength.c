/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * calculatedeformedlength.c
 *
 * Code generation for function 'calculatedeformedlength'
 *
 */

/* Include files */
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "calculatedeformedlength.h"
#include "calculatedeformedlength_data.h"

/* Variable Definitions */
static emlrtRTEInfo b_emlrtRTEI = { 8, /* lineNo */
  13,                                  /* colNo */
  "calculatedeformedlength",           /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatedeformedlength.m"/* pName */
};

static emlrtBCInfo emlrtBCI = { -1,    /* iFirst */
  -1,                                  /* iLast */
  10,                                  /* lineNo */
  12,                                  /* colNo */
  "BONDLIST",                          /* aName */
  "calculatedeformedlength",           /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatedeformedlength.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo b_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  11,                                  /* lineNo */
  12,                                  /* colNo */
  "BONDLIST",                          /* aName */
  "calculatedeformedlength",           /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatedeformedlength.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo c_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  13,                                  /* lineNo */
  23,                                  /* colNo */
  "deformedCoordinates",               /* aName */
  "calculatedeformedlength",           /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatedeformedlength.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo emlrtDCI = { 13,    /* lineNo */
  23,                                  /* colNo */
  "calculatedeformedlength",           /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatedeformedlength.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo d_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  13,                                  /* lineNo */
  54,                                  /* colNo */
  "deformedCoordinates",               /* aName */
  "calculatedeformedlength",           /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatedeformedlength.m",/* pName */
  0                                    /* checkKind */
};

static emlrtDCInfo b_emlrtDCI = { 13,  /* lineNo */
  54,                                  /* colNo */
  "calculatedeformedlength",           /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatedeformedlength.m",/* pName */
  1                                    /* checkKind */
};

static emlrtBCInfo e_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  13,                                  /* lineNo */
  4,                                   /* colNo */
  "deformedX",                         /* aName */
  "calculatedeformedlength",           /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatedeformedlength.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo f_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  14,                                  /* lineNo */
  23,                                  /* colNo */
  "deformedCoordinates",               /* aName */
  "calculatedeformedlength",           /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatedeformedlength.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo g_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  14,                                  /* lineNo */
  54,                                  /* colNo */
  "deformedCoordinates",               /* aName */
  "calculatedeformedlength",           /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatedeformedlength.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo h_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  14,                                  /* lineNo */
  4,                                   /* colNo */
  "deformedY",                         /* aName */
  "calculatedeformedlength",           /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatedeformedlength.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo i_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  15,                                  /* lineNo */
  23,                                  /* colNo */
  "deformedCoordinates",               /* aName */
  "calculatedeformedlength",           /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatedeformedlength.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo j_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  15,                                  /* lineNo */
  54,                                  /* colNo */
  "deformedCoordinates",               /* aName */
  "calculatedeformedlength",           /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatedeformedlength.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo k_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  15,                                  /* lineNo */
  4,                                   /* colNo */
  "deformedZ",                         /* aName */
  "calculatedeformedlength",           /* fName */
  "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatedeformedlength.m",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void calculatedeformedlength(const emlrtStack *sp, const emxArray_real_T
  *deformedCoordinates, emxArray_real_T *deformedX, emxArray_real_T *deformedY,
  emxArray_real_T *deformedZ, real_T nBonds, const emxArray_real_T *BONDLIST)
{
  int32_T i3;
  int32_T kBond;
  int32_T i4;
  int32_T i5;
  real_T nodei;
  real_T nodej;
  int32_T i6;
  int32_T i7;

  /*  calculatedeformedlength - calculate the deformed length and stretch of */
  /*  every bond */
  /*  [deformedLength,deformedX,deformedY,deformedZ,stretch] = calculatedeformedlength(deformedCoordinates,UNDEFORMEDLENGTH,deformedX,deformedY,deformedZ,nBonds,BONDLIST) */
  /*  Calculate the deformed length of every bond using a for loop */
  i3 = (int32_T)nBonds;
  emlrtForLoopVectorCheckR2012b(1.0, 1.0, nBonds, mxDOUBLE_CLASS, (int32_T)
    nBonds, &b_emlrtRTEI, sp);
  for (kBond = 0; kBond < i3; kBond++) {
    i4 = BONDLIST->size[0];
    i5 = (int32_T)(1U + kBond);
    if ((i5 < 1) || (i5 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i5, 1, i4, &emlrtBCI, sp);
    }

    nodei = BONDLIST->data[i5 - 1];
    i4 = BONDLIST->size[0];
    if ((i5 < 1) || (i5 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i5, 1, i4, &b_emlrtBCI, sp);
    }

    nodej = BONDLIST->data[(i5 + BONDLIST->size[0]) - 1];
    i4 = deformedCoordinates->size[0];
    if (nodej != (int32_T)muDoubleScalarFloor(nodej)) {
      emlrtIntegerCheckR2012b(nodej, &emlrtDCI, sp);
    }

    i6 = (int32_T)nodej;
    if ((i6 < 1) || (i6 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i6, 1, i4, &c_emlrtBCI, sp);
    }

    i4 = deformedCoordinates->size[0];
    if (nodei != (int32_T)muDoubleScalarFloor(nodei)) {
      emlrtIntegerCheckR2012b(nodei, &b_emlrtDCI, sp);
    }

    i7 = (int32_T)nodei;
    if ((i7 < 1) || (i7 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i7, 1, i4, &d_emlrtBCI, sp);
    }

    i4 = deformedX->size[0];
    if ((i5 < 1) || (i5 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i5, 1, i4, &e_emlrtBCI, sp);
    }

    deformedX->data[i5 - 1] = deformedCoordinates->data[i6 - 1] -
      deformedCoordinates->data[i7 - 1];

    /*  X-component of deformed bond */
    i4 = deformedCoordinates->size[0];
    if ((i6 < 1) || (i6 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i6, 1, i4, &f_emlrtBCI, sp);
    }

    i4 = deformedCoordinates->size[0];
    if ((i7 < 1) || (i7 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i7, 1, i4, &g_emlrtBCI, sp);
    }

    i4 = deformedY->size[0];
    if ((i5 < 1) || (i5 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i5, 1, i4, &h_emlrtBCI, sp);
    }

    deformedY->data[i5 - 1] = deformedCoordinates->data[(i6 +
      deformedCoordinates->size[0]) - 1] - deformedCoordinates->data[(i7 +
      deformedCoordinates->size[0]) - 1];

    /*  Y-component of deformed bond */
    i4 = deformedCoordinates->size[0];
    if ((i6 < 1) || (i6 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i6, 1, i4, &i_emlrtBCI, sp);
    }

    i4 = deformedCoordinates->size[0];
    if ((i7 < 1) || (i7 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i7, 1, i4, &j_emlrtBCI, sp);
    }

    i4 = deformedZ->size[0];
    if ((i5 < 1) || (i5 > i4)) {
      emlrtDynamicBoundsCheckR2012b(i5, 1, i4, &k_emlrtBCI, sp);
    }

    deformedZ->data[i5 - 1] = deformedCoordinates->data[(i6 +
      (deformedCoordinates->size[0] << 1)) - 1] - deformedCoordinates->data[(i7
      + (deformedCoordinates->size[0] << 1)) - 1];

    /*  Z-component of deformed bond */
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(sp);
    }
  }

  /*  % Calculate length of deformed bond */
  /*  deformedLength = deformedX.^2 + deformedY.^2 + deformedZ.^2;    % Move outside of for loop - optimises speed */
  /*  deformedLength = sqrt(deformedLength);                          % sqrt outside of for loop - optimises speed */
  /*   */
  /*  % Calculate bond stretch */
  /*  stretch = (deformedLength - UNDEFORMEDLENGTH) ./ UNDEFORMEDLENGTH; % Surely this should be ./undeformedLength??? */
}

/* End of code generation (calculatedeformedlength.c) */
