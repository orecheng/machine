//
// File: cross_core.h
//
// MATLAB Coder version            : 3.2
// C/C++ source code generated on  : 15-Jan-2017 23:44:27
//
#ifndef CROSS_CORE_H
#define CROSS_CORE_H

// Include Files
#include <cmath>
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "rt_nonfinite.h"
#include "rtwtypes.h"
#include "cross_fcn_types.h"

// Function Declarations
extern void cross_core(double Ts_in, double Ps_in, double Ms_in, double ha_in,
  double da_in, double Ma_in, double M, double N, double NTU, double Le, double *
  da_out, double *Ta_out, double *ha_out, double *Ts_out, double *Ms_out, double
  *Ps_out, double *hs_out);

#endif

//
// File trailer for cross_core.h
//
// [EOF]
//
