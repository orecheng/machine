circu_air_temp=20;
circu_air_RH=0.8;
hp_temp_cond_out=50;
reg_sink_sol_frac=0.3;
reg_trans_air_mass=2;
reg_trans_sol_mass_in=2;

[reg_trans_air_da_out,reg_trans_air_temp_out,reg_trans_sol_temp_out,reg_trans_sol_mass_out,reg_trans_sol_frac_out,reg_trans_sol_enth_out] ...
        = cross_fcn(circu_air_temp,circu_air_RH,hp_temp_cond_out,reg_sink_sol_frac,reg_trans_air_mass,reg_trans_sol_mass_in);
   