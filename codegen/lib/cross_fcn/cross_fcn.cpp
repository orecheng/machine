//
// File: cross_fcn.cpp
//
// MATLAB Coder version            : 3.2
// C/C++ source code generated on  : 15-Jan-2017 23:44:27
//

// Include Files
#include "rt_nonfinite.h"
#include "cross_fcn.h"
#include "cross_core.h"
#include "mean.h"
#include "sum.h"
#include "rh2da.h"
#include "cross_fcn_rtwutil.h"

// Function Definitions

//
// Ta_in=30;%
//  phi=0.8;%
// Arguments    : double Ta_in
//                double phi
//                double Ts_in
//                double Ps_in
//                double Ma_in
//                double Ms_in
//                double *AveAirMoistureOut
//                double *AveAirTempratureOut
//                double *AveSolTempratureOut
//                double *AveSolMassOut
//                double *AveSolConcenOut
//                double *AveSolEnthalpyOut
// Return Type  : void
//
void cross_fcn(double Ta_in, double phi, double Ts_in, double Ps_in, double
               Ma_in, double Ms_in, double *AveAirMoistureOut, double
               *AveAirTempratureOut, double *AveSolTempratureOut, double
               *AveSolMassOut, double *AveSolConcenOut, double
               *AveSolEnthalpyOut)
{
  double Le;
  double da_in;
  double ha_in;
  double b_Ta_in[3];
  double NTU;
  int j;
  double mu_da;
  static const double a[3] = { -2.448E-6, 0.005072, 1.713 };

  double c_Ta_in[3];
  static const double b_a[3] = { 6.993E-8, 0.007618, 2.442 };

  double c_a[4];
  static const double dv0[4] = { 5.088, 0.7329, 0.4203, 1.5328 };

  static const double dv1[4] = { 0.075344, 0.9697, 0.619, -5.3885 };

  double SolEnthalpy[3000];
  double AirMoisture[3000];
  double AirEnthalpy[3000];
  double AirTemprature[3000];
  double SolTemprature[3000];
  double SolMass[3000];
  double SolConcen[3000];
  int i;
  double b_SolTemprature[30];
  rh2da(Ta_in, phi, &Le, &da_in, &ha_in);

  //  Ts_in=10;%
  //  Ps_in=0.3;%
  //  Va_in=4000;%
  //  Vs_in=4.8;%
  //  Ms_in=Vs_in;
  //  Ma_in=Va_in;
  //
  //
  //
  //  水在空气中的扩散系数
  //  空气的动力粘度和运动粘度
  b_Ta_in[0] = Ta_in * Ta_in;
  b_Ta_in[1] = Ta_in;
  b_Ta_in[2] = 1.0;
  NTU = 0.0;
  for (j = 0; j < 3; j++) {
    NTU += a[j] * b_Ta_in[j];
  }

  mu_da = NTU * 1.0E-5;

  // 动力粘度
  // 运动粘度
  //  Thermal Conductivity of Air
  //  Sc
  //  Pr
  c_Ta_in[0] = Ta_in * Ta_in;
  c_Ta_in[1] = Ta_in;
  c_Ta_in[2] = 1.0;
  NTU = 0.0;
  for (j = 0; j < 3; j++) {
    NTU += b_a[j] * c_Ta_in[j];
  }

  Le = mu_da / Le / (((-0.2989 + 0.0016253 * (Ta_in + 273.15)) + 7.5E-7 *
                      ((Ta_in + 273.15) * (Ta_in + 273.15))) * 0.0001) / (mu_da *
    1010.0 / (NTU * 0.01));

  //  NTU
  //  我们自己实验数据拟合的
  //  if Ts_in>35
  //      a=[0.010296438	-0.833147603	1.180504199	-23.45078711];%再生
  //  else
  //      a=[5.094975587	-0.061006773	0.609178325	-1.330942842];%除湿
  //  end
  //  清华大学刘拴强博士毕业论文拟合的
  if (Ts_in > 35.0) {
    for (j = 0; j < 4; j++) {
      c_a[j] = dv1[j];
    }

    // 再生
  } else {
    for (j = 0; j < 4; j++) {
      c_a[j] = dv0[j];
    }

    // 除湿
  }

  NTU = c_a[0] * 0.04875 * rt_powd_snf(Ma_in / 0.325, c_a[1]) * rt_powd_snf
    (Ms_in / 0.0975, c_a[2]) * rt_powd_snf(1.0 - Ps_in, c_a[3]);

  //
  //  Initial of Matrix
  memset(&SolEnthalpy[0], 0, 3000U * sizeof(double));
  memset(&AirMoisture[0], 0, 3000U * sizeof(double));
  memset(&AirEnthalpy[0], 0, 3000U * sizeof(double));
  memset(&AirTemprature[0], 0, 3000U * sizeof(double));
  memset(&SolTemprature[0], 0, 3000U * sizeof(double));
  memset(&SolMass[0], 0, 3000U * sizeof(double));
  memset(&SolConcen[0], 0, 3000U * sizeof(double));

  //  row_1 column_1
  cross_core(Ts_in, Ps_in, Ms_in / 30.0, ha_in, da_in, Ma_in / 100.0, 30.0,
             100.0, NTU, Le, &AirMoisture[0], &AirTemprature[0], &AirEnthalpy[0],
             &SolTemprature[0], &SolMass[0], &SolConcen[0], &SolEnthalpy[0]);

  //  row_1
  for (j = 0; j < 29; j++) {
    cross_core(Ts_in, Ps_in, Ms_in / 30.0, AirEnthalpy[100 * j], AirMoisture[100
               * j], Ma_in / 100.0, 30.0, 100.0, NTU, Le, &AirMoisture[100 * (j
                + 1)], &AirTemprature[100 * (j + 1)], &AirEnthalpy[100 * (j + 1)],
               &SolTemprature[100 * (j + 1)], &SolMass[100 * (j + 1)],
               &SolConcen[100 * (j + 1)], &SolEnthalpy[100 * (j + 1)]);
  }

  //  column_1
  //  row_2~row_end  column_1~column_end
  for (i = 0; i < 99; i++) {
    cross_core(SolTemprature[i], SolConcen[i], SolMass[i], ha_in, da_in, Ma_in /
               100.0, 30.0, 100.0, NTU, Le, &AirMoisture[i + 1],
               &AirTemprature[i + 1], &AirEnthalpy[i + 1], &SolTemprature[i + 1],
               &SolMass[i + 1], &SolConcen[i + 1], &SolEnthalpy[i + 1]);
    for (j = 0; j < 29; j++) {
      cross_core(SolTemprature[i + 100 * (j + 1)], SolConcen[i + 100 * (j + 1)],
                 SolMass[i + 100 * (j + 1)], AirEnthalpy[(i + 100 * j) + 1],
                 AirMoisture[(i + 100 * j) + 1], Ma_in / 100.0, 30.0, 100.0, NTU,
                 Le, &AirMoisture[(i + 100 * (j + 1)) + 1], &AirTemprature[(i +
                  100 * (j + 1)) + 1], &AirEnthalpy[(i + 100 * (j + 1)) + 1],
                 &SolTemprature[(i + 100 * (j + 1)) + 1], &SolMass[(i + 100 * (j
        + 1)) + 1], &SolConcen[(i + 100 * (j + 1)) + 1], &SolEnthalpy[(i + 100 *
                  (j + 1)) + 1]);
    }
  }

  //  Average Out
  *AveAirMoistureOut = mean(*(double (*)[100])&AirMoisture[2900]);
  *AveAirTempratureOut = mean(*(double (*)[100])&AirTemprature[2900]);
  for (j = 0; j < 30; j++) {
    b_SolTemprature[j] = SolTemprature[99 + 100 * j];
  }

  *AveSolTempratureOut = b_mean(b_SolTemprature);
  for (j = 0; j < 30; j++) {
    b_SolTemprature[j] = SolMass[99 + 100 * j];
  }

  *AveSolMassOut = sum(b_SolTemprature);
  for (j = 0; j < 30; j++) {
    b_SolTemprature[j] = SolConcen[99 + 100 * j];
  }

  *AveSolConcenOut = b_mean(b_SolTemprature);
  for (j = 0; j < 30; j++) {
    b_SolTemprature[j] = SolEnthalpy[99 + 100 * j];
  }

  *AveSolEnthalpyOut = b_mean(b_SolTemprature);
}

//
// File trailer for cross_fcn.cpp
//
// [EOF]
//
