//
// File: sum.cpp
//
// MATLAB Coder version            : 3.2
// C/C++ source code generated on  : 15-Jan-2017 23:44:27
//

// Include Files
#include "rt_nonfinite.h"
#include "cross_fcn.h"
#include "sum.h"

// Function Definitions

//
// Arguments    : const double x[30]
// Return Type  : double
//
double sum(const double x[30])
{
  double y;
  int k;
  y = x[0];
  for (k = 0; k < 29; k++) {
    y += x[k + 1];
  }

  return y;
}

//
// File trailer for sum.cpp
//
// [EOF]
//
