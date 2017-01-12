function [hp_temp_evap_out,hp_temp_cond_out]=heatpump(hp_temp_evap_in,hp_temp_cond_in,hp_frac_evap,hp_frac_cond,hp_mass_evap,hp_mass_cond)
% hp_temp_cond_in=45;
% hp_temp_evap_in=22;
% hp_frac_cond=0.3;
% hp_frac_evap=0.3;
% % hp_Vol_cond=2;
% % hp_Vol_evap=2;
% hp_mass_cond=4000/3600;
% hp_mass_evap=4000/3600;

hp_rho_cond=cal_rho_licl(hp_temp_cond_in,hp_frac_cond);
hp_rho_evap=cal_rho_licl(hp_temp_evap_in,hp_frac_evap);
% % hp_mass_cond=hp_rho_cond*hp_Vol_cond;
% % hp_mass_evap=hp_rho_evap*hp_Vol_evap;

hp_enthalpy_cond_in=sol_enthalpy(hp_temp_cond_in,hp_frac_cond);
hp_enthalpy_evap_in=sol_enthalpy(hp_temp_evap_in,hp_frac_evap);
hp_Q_cond_in=hp_mass_cond * hp_enthalpy_cond_in;
hp_Q_evap_in=hp_mass_evap * hp_enthalpy_evap_in;

hp_temp_cond(1)=hp_temp_cond_in;
hp_temp_evap(1)=hp_temp_evap_in;

i=1;
while(1)
    i=i+1;
    [cop,N]=compressor(hp_temp_cond(i-1),hp_temp_evap(i-1));
    hp_Q_cond=(cop + 1) * N;
    hp_Q_evap=cop * N;
    hp_Q_cond_out=hp_Q_cond_in + hp_Q_cond;
    hp_Q_evap_out=hp_Q_evap_in - hp_Q_evap;
    hp_temp_cond(i)=solEnthalpy2Temp(hp_frac_cond,hp_Q_cond_out/hp_mass_cond);
    hp_temp_evap(i)=solEnthalpy2Temp(hp_frac_evap,hp_Q_evap_out/hp_mass_evap);
    err=hp_temp_cond(i)-hp_temp_cond(i-1);
    if abs(hp_temp_cond(i)-hp_temp_cond(i-1))<1e-4
        break
    end
end


hp_temp_cond_out=hp_temp_cond(end);
hp_temp_evap_out=hp_temp_evap(end);