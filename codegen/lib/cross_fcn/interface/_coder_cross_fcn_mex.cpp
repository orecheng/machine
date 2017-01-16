/*
 * File: _coder_cross_fcn_mex.cpp
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 15-Jan-2017 23:44:27
 */

/* Include Files */
#include "_coder_cross_fcn_api.h"
#include "_coder_cross_fcn_mex.h"

/* Function Declarations */
static void cross_fcn_mexFunction(int32_T nlhs, mxArray *plhs[6], int32_T nrhs,
  const mxArray *prhs[6]);

/* Function Definitions */

/*
 * Arguments    : int32_T nlhs
 *                const mxArray *plhs[6]
 *                int32_T nrhs
 *                const mxArray *prhs[6]
 * Return Type  : void
 */
static void cross_fcn_mexFunction(int32_T nlhs, mxArray *plhs[6], int32_T nrhs,
  const mxArray *prhs[6])
{
  int32_T n;
  const mxArray *inputs[6];
  const mxArray *outputs[6];
  int32_T b_nlhs;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 6) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 6, 4, 9,
                        "cross_fcn");
  }

  if (nlhs > 6) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 9,
                        "cross_fcn");
  }

  /* Temporary copy for mex inputs. */
  for (n = 0; n < nrhs; n++) {
    inputs[n] = prhs[n];
  }

  /* Call the function. */
  cross_fcn_api(inputs, outputs);

  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    b_nlhs = 1;
  } else {
    b_nlhs = nlhs;
  }

  emlrtReturnArrays(b_nlhs, plhs, outputs);

  /* Module termination. */
  cross_fcn_terminate();
}

/*
 * Arguments    : int32_T nlhs
 *                const mxArray * const plhs[]
 *                int32_T nrhs
 *                const mxArray * const prhs[]
 * Return Type  : void
 */
void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(cross_fcn_atexit);

  /* Initialize the memory manager. */
  /* Module initialization. */
  cross_fcn_initialize();

  /* Dispatch the entry-point. */
  cross_fcn_mexFunction(nlhs, plhs, nrhs, prhs);
}

/*
 * Arguments    : void
 * Return Type  : emlrtCTX
 */
emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/*
 * File trailer for _coder_cross_fcn_mex.cpp
 *
 * [EOF]
 */
