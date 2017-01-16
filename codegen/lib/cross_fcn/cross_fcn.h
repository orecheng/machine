//
// File: cross_fcn.h
//
// MATLAB Coder version            : 3.2
// C/C++ source code generated on  : 15-Jan-2017 23:44:27
//
#ifndef CROSS_FCN_H
#define CROSS_FCN_H

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
extern void cross_fcn(double Ta_in, double phi, double Ts_in, double Ps_in,
                      double Ma_in, double Ms_in, double *AveAirMoistureOut,
                      double *AveAirTempratureOut, double *AveSolTempratureOut,
                      double *AveSolMassOut, double *AveSolConcenOut, double
                      *AveSolEnthalpyOut);

#endif

//
// File trailer for cross_fcn.h
//
// [EOF]
//
