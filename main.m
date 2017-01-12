clc
clear all
%% input
circu_air_temp = 25;
circu_air_RH = 0.8;

deh_sink_sol_temp = 20;
deh_sink_sol_frac = 0.3;
deh_sink_sol_mass = 100;
reg_sink_sol_temp = 20;
reg_sink_sol_frac = 0.3;
reg_sink_sol_mass = 100;

deh_trans_sol_mass=2;
reg_trans_sol_mass=2;


%% initial
[circu_air_rho,circu_air_da,circu_air_ha] = rh2da(circu_air_temp,circu_air_RH);

%% cal
 [hp_temp_evap_out,hp_temp_cond_out]=heatpump(deh_sink_sol_temp,reg_sink_sol_temp,deh_sink_sol_frac,reg_sink_sol_frac,deh_trans_sol_mass,reg_trans_sol_mass);
 