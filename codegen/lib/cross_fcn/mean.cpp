//
// File: mean.cpp
//
// MATLAB Coder version            : 3.2
// C/C++ source code generated on  : 15-Jan-2017 23:44:27
//

// Include Files
#include "rt_nonfinite.h"
#include "cross_fcn.h"
#include "mean.h"

// Function Definitions

//
// Arguments    : const double x[30]
// Return Type  : double
//
double b_mean(const double x[30])
{
  double y;
  int k;
  y = x[0];
  for (k = 0; k < 29; k++) {
    y += x[k + 1];
  }

  y /= 30.0;
  return y;
}

//
// Arguments    : const double x[100]
// Return Type  : double
//
double mean(const double x[100])
{
  double y;
  int k;
  y = x[0];
  for (k = 0; k < 99; k++) {
    y += x[k + 1];
  }

  y /= 100.0;
  return y;
}

//
// File trailer for mean.cpp
//
// [EOF]
//
