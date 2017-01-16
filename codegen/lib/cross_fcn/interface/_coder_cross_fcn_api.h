/*
 * File: _coder_cross_fcn_api.h
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 15-Jan-2017 23:44:27
 */

#ifndef _CODER_CROSS_FCN_API_H
#define _CODER_CROSS_FCN_API_H

/* Include Files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_cross_fcn_api.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void cross_fcn(real_T Ta_in, real_T phi, real_T Ts_in, real_T Ps_in,
                      real_T Ma_in, real_T Ms_in, real_T *AveAirMoistureOut,
                      real_T *AveAirTempratureOut, real_T *AveSolTempratureOut,
                      real_T *AveSolMassOut, real_T *AveSolConcenOut, real_T
                      *AveSolEnthalpyOut);
extern void cross_fcn_api(const mxArray * const prhs[6], const mxArray *plhs[6]);
extern void cross_fcn_atexit(void);
extern void cross_fcn_initialize(void);
extern void cross_fcn_terminate(void);
extern void cross_fcn_xil_terminate(void);

#endif

/*
 * File trailer for _coder_cross_fcn_api.h
 *
 * [EOF]
 */
