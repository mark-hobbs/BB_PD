/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_calculatenodalforces_info.c
 *
 * Code generation for function '_coder_calculatenodalforces_info'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "calculatenodalforces.h"
#include "_coder_calculatenodalforces_info.h"

/* Function Definitions */
mxArray *emlrtMexFcnProperties(void)
{
  mxArray *xResult;
  mxArray *xEntryPoints;
  const char * fldNames[6] = { "Name", "NumberOfInputs", "NumberOfOutputs",
    "ConstantInputs", "FullPath", "TimeStamp" };

  mxArray *xInputs;
  const char * b_fldNames[4] = { "Version", "ResolvedFunctions", "EntryPoints",
    "CoverageInfo" };

  xEntryPoints = emlrtCreateStructMatrix(1, 1, 6, fldNames);
  xInputs = emlrtCreateLogicalMatrix(1, 7);
  emlrtSetField(xEntryPoints, 0, "Name", emlrtMxCreateString(
    "calculatenodalforces"));
  emlrtSetField(xEntryPoints, 0, "NumberOfInputs", emlrtMxCreateDoubleScalar(7.0));
  emlrtSetField(xEntryPoints, 0, "NumberOfOutputs", emlrtMxCreateDoubleScalar
                (1.0));
  emlrtSetField(xEntryPoints, 0, "ConstantInputs", xInputs);
  emlrtSetField(xEntryPoints, 0, "FullPath", emlrtMxCreateString(
    "D:\\PhD\\2 Code\\2.1 PhD Code\\BB_PD\\solvers\\calculatenodalforces.m"));
  emlrtSetField(xEntryPoints, 0, "TimeStamp", emlrtMxCreateDoubleScalar
                (737587.44886574079));
  xResult = emlrtCreateStructMatrix(1, 1, 4, b_fldNames);
  emlrtSetField(xResult, 0, "Version", emlrtMxCreateString(
    "9.6.0.1099231 (R2019a) Update 1"));
  emlrtSetField(xResult, 0, "ResolvedFunctions", (mxArray *)
                emlrtMexFcnResolvedFunctionsInfo());
  emlrtSetField(xResult, 0, "EntryPoints", xEntryPoints);
  return xResult;
}

const mxArray *emlrtMexFcnResolvedFunctionsInfo(void)
{
  const mxArray *nameCaptureInfo;
  const char * data[6] = {
    "789ced56d16ed3301475d198d8c35078e195f28c54d34aa8035eda349de8d4b1b216096d9a8aeb78249a1d474e32b23eed43f8003e814f408867def8053e0191"
    "a471db18590d0c8a26711f7a73741c9febd36bdd804a6fbf0200b80d66b1b33dcb7902469e6f8062a87c455957292e0737c146e13dc9bfcb33e65e48e27006a8",
    "eb91e7119b1091000f3132dfc6e6ccf590178e2e7c020409383d2776c69cba948c5c46fa7c093c7313c07697a83948a9f4b9e3107c368c18104eb028972e03b0"
    "e4cf7bcdf9374afa636afc3114feb87b623d8103c7828d6a87db04366af56a0267c034c7030b66a71701c488e288a29078dc46f4940b4c821a2bd6fd5a53d766",
    "c9bad52c630bdc5a424f5b522fd6ec57d6a73b1a3d43e109a3631626ff67307608f5b38e4963d5b957d5a186ae0e1952efc36feac9fd872bf4247fdcebbfea9e"
    "74921611fc8d40ac9af67200f7dba37edb84878d87f5c708869cd3098f616212a4ee043214523481dc0fe04fbee50db3c67ef9faedf397f67afb73ddf7e1dfe9",
    "5df5feddd5e8190a3f30ed617c74e1ecd6fbd3c69ed33cf75e584d6b51c76085ceaa3a8006af6bff8f9af7cbfa8834fb1b0aff17eef37dcc19e3de18a7134e8e"
    "33792e5f5377d97ed4cdf92d657d169707ad2cb706f3f970a9d9bfacaff734fa86c2e3645c8a9a9b7c5c080fd19a1b98914bc39e977c5e10e1e22bcf09a9bfa9",
    "e0453d33c6e6d184923fd75758ab57e47fa9af02070962c3ccb3fcf7419ea483507570fd73e313f8fe7f6e5cf7b9f1f6c87c399dc64ef3c08fbadd46073f3a44"
    "3be6f59f1b3f00c755e6b4", "" };

  nameCaptureInfo = NULL;
  emlrtNameCaptureMxArrayR2016a(data, 3408U, &nameCaptureInfo);
  return nameCaptureInfo;
}

/* End of code generation (_coder_calculatenodalforces_info.c) */
