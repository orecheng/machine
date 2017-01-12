clc
clear all
%% input
circu_air_temp = 25;
circu_air_RH = 0.8;



%% initial
[circu_air_rho,circu_air_da,circu_air_ha] = rh2da(circu_air_temp,circu_air_RH);
