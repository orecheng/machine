
hp_Tc_in=45;
hp_Te_in=22;
hp_cond_frac=0.3;
hp_evap_frac=0.3;
hp_cond_enthalpy=enthalpy(hp_Tc_in,hp_cond_frac);

hp_Volc=2;
hp_Vole=2;
%
hp_Qc_in=hp_Tc_in*cp*hp_Volc;
hp_Qe_in=hp_Te_in*cp*hp_Vole;
hp_Tc_out(1)=hp_Tc_in;
hp_Te_out(1)=hp_Te_in;
% 
% i=1;
% while(1)
%     i=i+1;
%     [cop,N]=compressor(hp_Tc_out(i-1),hp_Te_out(i-1));
%     Qc=cop*(N+1);
%     Qe=cop*N;
%     Qc_out=hp_Qc_in+Qc;
%     Qe_out=hp_Qe_in-Qe;
%     hp_Tc_out(i)=Qc_out/(cp*hp_Volc);
%     hp_Te_out(i)=Qe_out/(cp*hp_Vole);
%     err=hp_Tc_out(i)-hp_Tc_out(i-1);
%     if abs((hp_Tc_out(i)-hp_Tc_out(i-1)))<1e-4
%         break
%     end
% end