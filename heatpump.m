hp_temp_cond_in=45;
hp_temp_evap_in=22;
hp_frac_cond=0.3;
hp_frac_evap=0.3;
hp_Vol_cond=2;
hp_Vol_evap=2;

hp_enthalpy_cond=sol_enthalpy(hp_temp_cond_in,hp_frac_cond);
hp_enthalpy_evap=sol_enthalpy(hp_temp_evap_in,hp_frac_evap);
hp_Q_cond_in=hp_Vol_cond*hp_enthalpy_cond;
hp_Q_evap_in=hp_Vol_evap*hp_enthalpy_evap;

hp_temp_cond_out(1)=hp_temp_cond_in;
hp_temp_evap_out(1)=hp_temp_evap_in;

i=1;
while(1)
    i=i+1;
    [cop,N]=compressor(hp_temp_cond_out(i-1),hp_temp_evap_out(i-1));
    Q_cond=cop*(N+1);
    Q_evap=cop*N;
    Qc_out=hp_Q_cond_in+Q_cond;
    Qe_out=hp_Q_evap_in-Q_evap;
    hp_temp_cond_out(i)=Qc_out/(cp*hp_Volc);
    hp_temp_evap_out(i)=Qe_out/(cp*hp_Vole);
    err=hp_temp_cond_out(i)-hp_temp_cond_out(i-1);
    if abs(hp_temp_cond_out(i)-hp_temp_cond_out(i-1))<1e-4
        break
    end
end