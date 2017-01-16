//
// File: cross_core.cpp
//
// MATLAB Coder version            : 3.2
// C/C++ source code generated on  : 15-Jan-2017 23:44:27
//

// Include Files
#include "rt_nonfinite.h"
#include "cross_fcn.h"
#include "cross_core.h"
#include "cross_fcn_rtwutil.h"

// Function Definitions

//
// Arguments    : double Ts_in
//                double Ps_in
//                double Ms_in
//                double ha_in
//                double da_in
//                double Ma_in
//                double M
//                double N
//                double NTU
//                double Le
//                double *da_out
//                double *Ta_out
//                double *ha_out
//                double *Ts_out
//                double *Ms_out
//                double *Ps_out
//                double *hs_out
// Return Type  : void
//
void cross_core(double Ts_in, double Ps_in, double Ms_in, double ha_in, double
                da_in, double Ma_in, double M, double N, double NTU, double Le,
                double *da_out, double *Ta_out, double *ha_out, double *Ts_out,
                double *Ms_out, double *Ps_out, double *hs_out)
{
  double t;
  double X;
  double x[5];
  double d0;
  int i0;
  static const double a[5] = { -66.2324, 11.2711, -0.79853, 0.021534,
    -0.000166352 };

  static const double b_a[5] = { 4.5751, -0.146924, 0.006307226, -0.000138054,
    1.0669E-6 };

  static const double c_a[5] = { -0.000809689, 0.000218145, -1.36194E-5,
    3.20998E-7, -2.64266E-9 };

  t = 1.0 - (Ts_in + 273.15) / 647.14;
  t = 2.2120000000000004E+7 * std::exp((((((-7.85823 * (1.0 - (Ts_in + 273.15) /
    647.14) + 1.83991 * rt_powd_snf(t, 1.5)) + -11.7811 * rt_powd_snf(t, 3.0)) +
    22.6705 * rt_powd_snf(t, 3.5)) + -15.9393 * rt_powd_snf(t, 4.0)) + 1.77516 *
    rt_powd_snf(t, 7.5)) / (1.0 - t)) * ((1.0 - rt_powd_snf(1.0 + rt_powd_snf
    (Ps_in / 0.362, -4.75), -0.4)) - 0.03 * std::exp(-((Ps_in - 0.1) * (Ps_in -
    0.1) / 0.005))) * ((2.0 - rt_powd_snf(1.0 + rt_powd_snf(Ps_in / 0.28, 4.3),
    0.6)) + (rt_powd_snf(1.0 + rt_powd_snf(Ps_in / 0.21, 5.1), 0.49) - 1.0) *
                       ((Ts_in + 273.15) / 228.0 - 1.0));

  // 溶液表面的蒸汽压
  t = 0.622 * (t / (101325.0 - t));

  // 与溶液状态相平衡的饱和空气含湿量
  //  计算溶液焓值
  X = Ps_in * 100.0;
  x[0] = 1.0;
  x[1] = X;
  x[2] = X * X;
  x[3] = rt_powd_snf(X, 3.0);
  x[4] = rt_powd_snf(X, 4.0);

  //  he,i-1 换算 Tsin de,i-1
  //  da,i ①
  *da_out = da_in + NTU * (t - da_in) / M;

  //  ha,i ②
  *ha_out = ha_in + NTU * Le * (((1.01 * Ts_in + (2501.0 + 1.83 * Ts_in) * t) -
    ha_in) + (2500.0 - 2.35 * Ts_in) * (1.0 / Le - 1.0) * (t - da_in)) / M;
  *Ta_out = (*ha_out - 2501.0 * *da_out) / (1.01 + 1.83 * *da_out);

  //  Ms,j ③
  *Ms_out = Ms_in + Ma_in * (da_in - *da_out) * M / N;

  //  Ps,j ④
  *Ps_out = Ps_in * Ms_in / *Ms_out;

  //  hs,j ⑤
  t = 0.0;
  X = 0.0;
  d0 = 0.0;
  for (i0 = 0; i0 < 5; i0++) {
    t += a[i0] * x[i0];
    X += b_a[i0] * x[i0];
    d0 += c_a[i0] * x[i0];
  }

  *hs_out = (((t + X * Ts_in) + d0 * (Ts_in * Ts_in)) * Ms_in - Ma_in * (*ha_out
              - ha_in) * M / N) / *Ms_out;

  //  Ts,j
  X = *Ps_out * 100.0;
  x[0] = 1.0;
  x[1] = X;
  x[2] = X * X;
  x[3] = rt_powd_snf(X, 3.0);
  x[4] = rt_powd_snf(X, 4.0);
  t = 0.0;
  for (i0 = 0; i0 < 5; i0++) {
    t += b_a[i0] * x[i0];
  }

  X = 0.0;
  for (i0 = 0; i0 < 5; i0++) {
    X += c_a[i0] * x[i0];
  }

  d0 = 0.0;
  for (i0 = 0; i0 < 5; i0++) {
    d0 += a[i0] * x[i0];
  }

  *Ts_out = (-t + std::sqrt(t * t - 4.0 * X * (d0 - *hs_out))) / (2.0 * X);
}

//
// File trailer for cross_core.cpp
//
// [EOF]
//
