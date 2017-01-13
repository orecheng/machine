clc
clear all
%% input
circu_air_temp = 25;
circu_air_RH = 0.8;

deh_sink_sol_temp(1) = 20;
deh_sink_sol_frac(1) = 0.3;
deh_sink_sol_mass(1) = 100;
reg_sink_sol_temp(1) = 20;
reg_sink_sol_frac(1) = 0.3;
reg_sink_sol_mass(1) = 100;

deh_trans_sol_mass_in=2;
reg_trans_sol_mass_in=2;
deh_trans_air_mass=2;
reg_trans_air_mass=2;

%% initial
[circu_air_rho,circu_air_da,circu_air_ha] = rh2da(circu_air_temp,circu_air_RH);

deh_sink_sol_enth = sol_enthalpy(deh_sink_sol_temp,deh_sink_sol_frac);
deh_sink_sol_enth_all = deh_sink_sol_enth*deh_sink_sol_mass;
reg_sink_sol_enth = sol_enthalpy(reg_sink_sol_temp,reg_sink_sol_frac);
reg_sink_sol_enth_all = reg_sink_sol_enth*reg_sink_sol_mass;

deh_sink_sol_LiCl(1) = deh_sink_sol_frac*deh_sink_sol_mass;
reg_sink_sol_LiCl(1) = reg_sink_sol_frac*reg_sink_sol_mass;

%% cal
tic
step=10;
timelength=10000;
for i=2:floor(timelength/step)
% i=2;
% while(1)
%% DEH
    [hp_temp_evap_out,hp_temp_cond_out]...
        =heatpump(deh_sink_sol_temp(i-1),reg_sink_sol_temp(i-1),deh_sink_sol_frac(i-1),reg_sink_sol_frac(i-1),deh_trans_sol_mass_in,reg_trans_sol_mass_in);
    
    [deh_trans_air_da_out,deh_trans_air_temp_out,deh_trans_sol_temp_out,deh_trans_sol_mass_out,deh_trans_sol_frac_out,deh_trans_sol_enth_out] ...
        = cross_fcn(circu_air_temp,circu_air_RH,hp_temp_evap_out,deh_sink_sol_frac(i-1),deh_trans_air_mass,deh_trans_sol_mass_in);
    
    deh_sink_sol_LiCl(i) ...
        = deh_sink_sol_LiCl(i-1) + (deh_trans_sol_frac_out*deh_trans_sol_mass_out-deh_sink_sol_frac(i-1)*deh_trans_sol_mass_in)*step;
    
    deh_sink_sol_mass(i) ...
        = deh_sink_sol_mass(i-1) + (deh_trans_sol_mass_out-deh_trans_sol_mass_in)*step;
    
    deh_sink_sol_frac(i) ...
        = deh_sink_sol_LiCl(i)/deh_sink_sol_mass(i);
    
    deh_sink_sol_enth_all(i) ...
        = deh_sink_sol_enth_all(i-1)+(deh_trans_sol_enth_out*deh_trans_sol_mass_out-deh_sink_sol_enth(i-1)*deh_trans_sol_mass_in)*step;
    
    deh_sink_sol_enth(i) ...
        = deh_sink_sol_enth_all(i)/deh_sink_sol_mass(i);
    
    deh_sink_sol_temp(i) ...
        =solEnthalpy2Temp(deh_sink_sol_frac(i),deh_sink_sol_enth(i));
 %% REG  
    [reg_trans_air_da_out,reg_trans_air_temp_out,reg_trans_sol_temp_out,reg_trans_sol_mass_out,reg_trans_sol_frac_out,reg_trans_sol_enth_out] ...
        = cross_fcn(circu_air_temp,circu_air_RH,hp_temp_cond_out,reg_sink_sol_frac(i-1),reg_trans_air_mass,reg_trans_sol_mass_in);
  
    reg_sink_sol_LiCl(i) ...
        = reg_sink_sol_LiCl(i-1) + (reg_trans_sol_frac_out*reg_trans_sol_mass_out-reg_sink_sol_frac(i-1)*reg_trans_sol_mass_in)*step;
    
    reg_sink_sol_mass(i) ...
        = reg_sink_sol_mass(i-1) + (reg_trans_sol_mass_out-reg_trans_sol_mass_in)*step;

    reg_sink_sol_frac(i) ...
        = reg_sink_sol_LiCl(i)/reg_sink_sol_mass(i);
    
    reg_sink_sol_enth_all(i) ...
        = reg_sink_sol_enth_all(i-1)+(reg_trans_sol_enth_out*reg_trans_sol_mass_out-reg_sink_sol_enth(i-1)*reg_trans_sol_mass_in)*step;
    
    reg_sink_sol_enth(i) ...
        = reg_sink_sol_enth_all(i)/reg_sink_sol_mass(i);
    
    reg_sink_sol_temp(i) ...
        =solEnthalpy2Temp(reg_sink_sol_frac(i),reg_sink_sol_enth(i));    
    
    
%     frac(i)=deh_sink_sol_frac;
%     if i>2
%         err=abs(frac(i)-frac(i-1))
%         if err<1e-5
%             break
%         end
%     end
 i=i+1;
 i*step
end
toc
