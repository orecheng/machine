/*
 * File: _coder_cross_fcn_api.c
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 15-Jan-2017 23:44:27
 */

/* Include Files */
#include "tmwtypes.h"
#include "_coder_cross_fcn_api.h"
#include "_coder_cross_fcn_mex.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;
emlrtContext emlrtContextGlobal = { true,/* bFirstTime */
  false,                               /* bInitialized */
  131435U,                             /* fVersionInfo */
  NULL,                                /* fErrorFunction */
  "cross_fcn",                         /* fFunctionName */
  NULL,                                /* fRTCallStack */
  false,                               /* bDebugMode */
  { 2045744189U, 2170104910U, 2743257031U, 4284093946U },/* fSigWrd */
  NULL                                 /* fSigMem */
};

/* Function Declarations */
static real_T b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId);
static real_T emlrt_marshallIn(const emlrtStack *sp, const mxArray *Ta_in, const
  char_T *identifier);
static const mxArray *emlrt_marshallOut(const real_T u);

/* Function Definitions */

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : real_T
 */
static real_T b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = c_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 * Return Type  : real_T
 */
static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId)
{
  real_T ret;
  static const int32_T dims = 0;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 0U, &dims);
  ret = *(real_T *)mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

/*
 * Arguments    : const emlrtStack *sp
 *                const mxArray *Ta_in
 *                const char_T *identifier
 * Return Type  : real_T
 */
static real_T emlrt_marshallIn(const emlrtStack *sp, const mxArray *Ta_in, const
  char_T *identifier)
{
  real_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(sp, emlrtAlias(Ta_in), &thisId);
  emlrtDestroyArray(&Ta_in);
  return y;
}

/*
 * Arguments    : const real_T u
 * Return Type  : const mxArray *
 */
static const mxArray *emlrt_marshallOut(const real_T u)
{
  const mxArray *y;
  const mxArray *m0;
  y = NULL;
  m0 = emlrtCreateDoubleScalar(u);
  emlrtAssign(&y, m0);
  return y;
}

/*
 * Arguments    : const mxArray * const prhs[6]
 *                const mxArray *plhs[6]
 * Return Type  : void
 */
void cross_fcn_api(const mxArray * const prhs[6], const mxArray *plhs[6])
{
  real_T Ta_in;
  real_T phi;
  real_T Ts_in;
  real_T Ps_in;
  real_T Ma_in;
  real_T Ms_in;
  real_T AveAirMoistureOut;
  real_T AveAirTempratureOut;
  real_T AveSolTempratureOut;
  real_T AveSolMassOut;
  real_T AveSolConcenOut;
  real_T AveSolEnthalpyOut;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Marshall function inputs */
  Ta_in = emlrt_marshallIn(&st, emlrtAliasP((const mxArray *)prhs[0]), "Ta_in");
  phi = emlrt_marshallIn(&st, emlrtAliasP((const mxArray *)prhs[1]), "phi");
  Ts_in = emlrt_marshallIn(&st, emlrtAliasP((const mxArray *)prhs[2]), "Ts_in");
  Ps_in = emlrt_marshallIn(&st, emlrtAliasP((const mxArray *)prhs[3]), "Ps_in");
  Ma_in = emlrt_marshallIn(&st, emlrtAliasP((const mxArray *)prhs[4]), "Ma_in");
  Ms_in = emlrt_marshallIn(&st, emlrtAliasP((const mxArray *)prhs[5]), "Ms_in");

  /* Invoke the target function */
  cross_fcn(Ta_in, phi, Ts_in, Ps_in, Ma_in, Ms_in, &AveAirMoistureOut,
            &AveAirTempratureOut, &AveSolTempratureOut, &AveSolMassOut,
            &AveSolConcenOut, &AveSolEnthalpyOut);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(AveAirMoistureOut);
  plhs[1] = emlrt_marshallOut(AveAirTempratureOut);
  plhs[2] = emlrt_marshallOut(AveSolTempratureOut);
  plhs[3] = emlrt_marshallOut(AveSolMassOut);
  plhs[4] = emlrt_marshallOut(AveSolConcenOut);
  plhs[5] = emlrt_marshallOut(AveSolEnthalpyOut);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void cross_fcn_atexit(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  cross_fcn_xil_terminate();
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void cross_fcn_initialize(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void cross_fcn_terminate(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/*
 * File trailer for _coder_cross_fcn_api.c
 *
 * [EOF]
 */
