//
// File: rh2da.cpp
//
// MATLAB Coder version            : 3.2
// C/C++ source code generated on  : 15-Jan-2017 23:44:27
//

// Include Files
#include "rt_nonfinite.h"
#include "cross_fcn.h"
#include "rh2da.h"
#include "cross_core.h"
#include "cross_fcn_rtwutil.h"

// Function Definitions

//
// t=41.1;
//  phi=0.649;
// Arguments    : double t
//                double phi
//                double *rho_air
//                double *da
//                double *ha
// Return Type  : void
//
void rh2da(double t, double phi, double *rho_air, double *da, double *ha)
{
  double ps;
  if (phi > 10.0) {
    phi /= 100.0;
  }

  ps = std::exp(((7.23E-7 * rt_powd_snf(t, 3.0) - 0.000271 * (t * t)) + 0.072 *
                 t) + 6.42);
  *da = 0.622 * phi * ps / (101325.0 - phi * ps);
  *rho_air = 101325.0 * (1.0 + 0.001 * *da) / (287.0 * (t + 273.15) * (1.0 +
    0.001606 * *da));

  //  湿空气密度 （kg/kg干空气）
  *ha = 1.01 * t + (1.83 * t + 2501.0) * *da;
}

//
// File trailer for rh2da.cpp
//
// [EOF]
//
