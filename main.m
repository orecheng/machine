clc
clear all
%% input
circu_air_temp = 30;
circu_air_RH = 0.8;

deh_sink_sol_temp(1) = 20;
deh_sink_sol_frac(1) = 0.3;
deh_sink_sol_mass(1) = 100;
reg_sink_sol_temp(1) = 20;
reg_sink_sol_frac(1) = 0.3;
reg_sink_sol_mass(1) = 100;

deh_trans_sol_mass_in=8000/3600;
reg_trans_sol_mass_in=8000/3600;
deh_trans_air_mass=8000/3600;
reg_trans_air_mass=8000/3600;
mass_exchange_reg2deh=0.12;
he_off_on=1;% 0���Ƚ�������1���Ƚ����� 
power_compressor=12;%ѹ�������ʣ�ƥ
%% initial
[circu_air_rho,circu_air_da,circu_air_ha] = rh2da(circu_air_temp,circu_air_RH);

deh_sink_sol_enth = sol_enthalpy(deh_sink_sol_temp,deh_sink_sol_frac);
deh_sink_sol_enth_all = deh_sink_sol_enth*deh_sink_sol_mass;
reg_sink_sol_enth = sol_enthalpy(reg_sink_sol_temp,reg_sink_sol_frac);
reg_sink_sol_enth_all = reg_sink_sol_enth*reg_sink_sol_mass;

deh_sink_sol_LiCl(1) = deh_sink_sol_frac*deh_sink_sol_mass;
reg_sink_sol_LiCl(1) = reg_sink_sol_frac*reg_sink_sol_mass;

% deh_trans_air_da_out(1)=circu_air_da;
% reg_trans_air_da_out(1)=circu_air_da;
%% cal
tic
step=50;


timelength=86400;
% for i=2:floor(timelength/step)
time_step=0:step:timelength;
% hp_temp_evap_out=20;
i=1;
while(1)
    i=i+1;
    
    %% DEH
    
    [N(i),cop(i),hp_temp_evap_out(i),hp_temp_cond_out(i)]... 
        =heatpump(power_compressor,deh_sink_sol_temp(i-1),reg_sink_sol_temp(i-1),deh_sink_sol_frac(i-1),reg_sink_sol_frac(i-1),deh_trans_sol_mass_in,reg_trans_sol_mass_in);
    
    [deh_trans_air_da_out(i),deh_trans_air_temp_out(i),deh_trans_air_enthalpy_out(i),deh_trans_sol_temp_out,deh_trans_sol_mass_out,deh_trans_sol_frac_out,deh_trans_sol_enth_out,err_ha_deh(i),err_da_deh(i)] ...
        = cross_fcn(circu_air_temp,circu_air_RH,hp_temp_evap_out(i),deh_sink_sol_frac(i-1),deh_trans_air_mass,deh_trans_sol_mass_in);
        
    deh_trans_air_enthalpy_change(i)=deh_trans_air_enthalpy_out(i)-circu_air_ha;
    
    deh_sink_sol_LiCl(i) ...
        = deh_sink_sol_LiCl(i-1) + (deh_trans_sol_frac_out*deh_trans_sol_mass_out-deh_sink_sol_frac(i-1)*deh_trans_sol_mass_in)*step;
    
    deh_sink_sol_mass(i) ...
        = deh_sink_sol_mass(i-1) + (deh_trans_sol_mass_out-deh_trans_sol_mass_in)*step;
    
    deh_sink_sol_frac(i) ...
        = deh_sink_sol_LiCl(i)/deh_sink_sol_mass(i);
    
    deh_sink_sol_enth_all_sb(i)=deh_sink_sol_enth_all(i-1);
    deh_sink_sol_enth_all(i) ...
        = deh_sink_sol_enth_all(i-1)+(deh_trans_sol_enth_out*deh_trans_sol_mass_out-deh_sink_sol_enth(i-1)*deh_trans_sol_mass_in)*step;
    deh_sink_sol_enth_all_sa(i)=deh_sink_sol_enth_all(i);
    
    deh_sink_sol_enth(i) ...
        = deh_sink_sol_enth_all(i)/deh_sink_sol_mass(i);
    
    deh_sink_sol_temp(i) ...
        =solEnthalpy2Temp(deh_sink_sol_frac(i),deh_sink_sol_enth(i));
    
    deh_air_da_change(i)=deh_trans_air_da_out(i)-circu_air_da;
    %% REG
    [reg_trans_air_da_out(i),reg_trans_air_temp_out(i),reg_trans_air_enthalpy_out(i),reg_trans_sol_temp_out,reg_trans_sol_mass_out,reg_trans_sol_frac_out,reg_trans_sol_enth_out,err_ha_reg(i),err_da_reg(i)] ...
        = cross_fcn(circu_air_temp,circu_air_RH,hp_temp_cond_out(i),reg_sink_sol_frac(i-1),reg_trans_air_mass,reg_trans_sol_mass_in);

    reg_trans_air_enthalpy_change(i)=reg_trans_air_enthalpy_out(i)-circu_air_ha;
    
    reg_sink_sol_LiCl(i) ...
        = reg_sink_sol_LiCl(i-1) + (reg_trans_sol_frac_out*reg_trans_sol_mass_out-reg_sink_sol_frac(i-1)*reg_trans_sol_mass_in)*step;
    
    reg_sink_sol_mass(i) ...
        = reg_sink_sol_mass(i-1) + (reg_trans_sol_mass_out-reg_trans_sol_mass_in)*step;
    
    reg_sink_sol_frac(i) ...
        = reg_sink_sol_LiCl(i)/reg_sink_sol_mass(i);
    
    reg_sink_sol_enth_all_sb(i)=reg_sink_sol_enth_all(i-1);
    reg_sink_sol_enth_all(i) ...
        = reg_sink_sol_enth_all(i-1)+(reg_trans_sol_enth_out*reg_trans_sol_mass_out-reg_sink_sol_enth(i-1)*reg_trans_sol_mass_in)*step;
    reg_sink_sol_enth_all_sa(i)=reg_sink_sol_enth_all(i);
    
    reg_sink_sol_enth(i) ...
        = reg_sink_sol_enth_all(i)/reg_sink_sol_mass(i);
    
    reg_sink_sol_temp(i) ...
        =solEnthalpy2Temp(reg_sink_sol_frac(i),reg_sink_sol_enth(i));
    
    reg_air_da_change(i)=reg_trans_air_da_out(i)-circu_air_da;
    %% heat exchanger
    %     mass_exchange_reg2deh=0.01;
    
    
    mass_exchange_deh2reg=(deh_sink_sol_mass(i)-reg_sink_sol_mass(i))*1e-2;
    

    if he_off_on==0
        %% ���Ƚ�����
        Thotout(i)=reg_sink_sol_temp(i);
        frachotout=reg_sink_sol_frac(i);
        Tcoldout(i)=deh_sink_sol_temp(i);
        fraccoldout=deh_sink_sol_frac(i);
    elseif he_off_on==1
        %% ���Ƚ�����
        [~,Thotout(i),frachotout,~,Tcoldout(i),fraccoldout] ...
            = heatexchanger(mass_exchange_reg2deh,reg_sink_sol_temp(i),reg_sink_sol_frac(i),mass_exchange_deh2reg,deh_sink_sol_temp(i),deh_sink_sol_frac(i));
        %%
    end
    [reg_echange_enth] = sol_enthalpy(Thotout(i), frachotout);
    [deh_echange_enth] = sol_enthalpy(Tcoldout(i),fraccoldout);
    
    deh_sink_sol_mass(i)...
        =deh_sink_sol_mass(i)+( mass_exchange_reg2deh-mass_exchange_deh2reg)*step;
    reg_sink_sol_mass(i)...
        =reg_sink_sol_mass(i)+(-mass_exchange_reg2deh+mass_exchange_deh2reg)*step;
    
    deh_sink_sol_LiCl(i)...
        =deh_sink_sol_LiCl(i) + (mass_exchange_reg2deh * reg_sink_sol_frac(i) - mass_exchange_deh2reg * deh_sink_sol_frac(i))*step;
    reg_sink_sol_LiCl(i)...
        =reg_sink_sol_LiCl(i) +(-mass_exchange_reg2deh * reg_sink_sol_frac(i) + mass_exchange_deh2reg * deh_sink_sol_frac(i))*step;
    
    deh_sink_sol_frac(i) ...
        = deh_sink_sol_LiCl(i)/deh_sink_sol_mass(i);
    reg_sink_sol_frac(i) ...
        = reg_sink_sol_LiCl(i)/reg_sink_sol_mass(i);
    
    deh_sink_sol_enth_all(i) ...
        = deh_sink_sol_enth_all(i)+( reg_echange_enth*mass_exchange_reg2deh - deh_echange_enth * mass_exchange_deh2reg)*step;
    deh_sink_sol_enth_all_ea(i)=deh_sink_sol_enth_all(i);
    
    reg_sink_sol_enth_all(i) ...
        = reg_sink_sol_enth_all(i)+(-reg_echange_enth*mass_exchange_reg2deh + deh_echange_enth * mass_exchange_deh2reg)*step;
    reg_sink_sol_enth_all_ea(i)=reg_sink_sol_enth_all(i);
    
    deh_sink_sol_enth(i) ...
        = deh_sink_sol_enth_all(i)/deh_sink_sol_mass(i);
    reg_sink_sol_enth(i) ...
        = reg_sink_sol_enth_all(i)/reg_sink_sol_mass(i);
    
    deh_sink_sol_temp(i) ...
        =solEnthalpy2Temp(deh_sink_sol_frac(i),deh_sink_sol_enth(i));
    reg_sink_sol_temp(i) ...
        =solEnthalpy2Temp(reg_sink_sol_frac(i),reg_sink_sol_enth(i));
    
    
    
    err=abs(deh_sink_sol_mass(i)-deh_sink_sol_mass(i-1));
    pr=1;
if pr==0    
    if err<1e-5
        break
    end
else   
    if i*step>timelength
        break
    end    
end   
    
    i*step
    deh_sink_sol_mass(i)
    %  if i==279
    %      save 279.mat
    %  end
end

reg_air_da_change(i)=reg_air_da_change(i-1);
deh_air_da_change(i)=deh_air_da_change(i-1);
reg_trans_air_temp_out(i)=reg_trans_air_temp_out(i-1);
deh_trans_air_temp_out(i)=deh_trans_air_temp_out(i-1);
N(i)=N(i-1);
cop(i)=cop(i-1);
toc
%%
sum_N=sum(N)*step/3600;%N�Ѿ���kW
sum_da_change=sum(deh_air_da_change)*deh_trans_air_mass*step;
deh_air_da_change(end)
deh_sink_sol_enth_all_exchange=(deh_sink_sol_enth_all_ea-deh_sink_sol_enth_all_sa)/step;
reg_sink_sol_enth_all_exchange=(reg_sink_sol_enth_all_ea-reg_sink_sol_enth_all_sa)/step;
%% ��ͼ
figure(1)
if he_off_on==1
    text='��';
else
    text='û��';
end

suptitle([num2str(deh_trans_air_mass*3600),'(m3/h)����',num2str(power_compressor),'Pѹ������',text,'�Ȼ��ջ�����'])

ax1=subplot(4,4,1);
plot(time_step,deh_air_da_change);
ylim([min(deh_air_da_change(100:end))*1.001,max(deh_air_da_change(100:end))+0.0001])
title('��ʪ��������ʪ���仯');xlabel('ʱ��(s)');ylabel('��ʪ���仯��kg/kg �ɿ�����');grid on

subplot(4,4,2)
plot(time_step,deh_trans_air_temp_out)
ylim([min(deh_trans_air_temp_out(100:end))*0.99,max(deh_trans_air_temp_out(100:end))*1.03])
title('��ʪ�����������¶�');xlabel('ʱ��(s)');ylabel('�¶ȣ���C��');grid on

subplot(4,4,3)
plot(time_step,deh_sink_sol_frac*100)
title('��ʪ����Һ����ҺŨ��');xlabel('ʱ��(s)');ylabel('Ũ�ȣ�%��');grid on

subplot(4,4,4)
plot(time_step,deh_sink_sol_temp)
ylim([min(deh_sink_sol_temp(100:end))*0.99,max(deh_sink_sol_temp(100:end))*1.02])
title('��ʪ����Һ����Һ�¶�');xlabel('ʱ��(s)');ylabel('�¶ȣ���C��');grid on


subplot(4,4,5)
plot(time_step,reg_air_da_change);
ylim([min(reg_air_da_change(100:end))*0.99,max(reg_air_da_change(100:end))*1.01])
title('������������ʪ���仯');xlabel('ʱ��(s)');ylabel('��ʪ���仯��kg/kg �ɿ�����');grid on

subplot(4,4,6)
plot(time_step,reg_trans_air_temp_out)
ylim([min(reg_trans_air_temp_out(100:end))*0.99,max(reg_trans_air_temp_out(100:end))*1.03])
title('���������������¶�');xlabel('ʱ��(s)');ylabel('�¶ȣ���C��');grid on

subplot(4,4,7)
plot(time_step,reg_sink_sol_frac*100)
title('��������Һ����ҺŨ��');xlabel('ʱ��(s)');ylabel('Ũ�ȣ�%��');grid on

subplot(4,4,8)
plot(time_step,reg_sink_sol_temp)
ylim([min(reg_sink_sol_temp(100:end))*0.99,max(reg_sink_sol_temp(100:end))*1.01])
title('��������Һ����Һ�¶�');xlabel('ʱ��(s)');ylabel('�¶ȣ���C��');grid on

subplot(4,4,9)
plot(time_step,N)
ylim([min(N(100:end))*0.99,max(N(100:end))*1.01])
title('ѹ��������');xlabel('ʱ��(s)');ylabel('���ʣ�kW��');grid on

subplot(4,4,10)
plot(time_step,cop)
ylim([min(cop(100:end))*0.99,max(cop(100:end))*1.01])
title('ѹ����COP');xlabel('ʱ��(s)');ylabel('COP');grid on

subplot(4,4,11)
plot(time_step,deh_sink_sol_mass)
ylim([min(reg_sink_sol_mass)*0.95,max(deh_sink_sol_mass)*1.01])
title('��ʪ����Һ����Һ����');xlabel('ʱ��(s)');ylabel('������kg��');grid on

subplot(4,4,12)
plot(time_step,reg_sink_sol_mass)
ylim([min(reg_sink_sol_mass)*0.95,max(deh_sink_sol_mass)*1.01])
title('��������Һ����Һ����');xlabel('ʱ��(s)');ylabel('������kg��');grid on

subplot(4,4,13)
plot(time_step,hp_temp_evap_out)
ylim([min(hp_temp_evap_out(100:end))*0.99,max(hp_temp_evap_out(100:end))*1.02])
title('��ʪ��Һ�����¶�');xlabel('ʱ��(s)');ylabel('�¶ȣ���C��');grid on

subplot(4,4,14)
plot(time_step,hp_temp_cond_out)
ylim([min(hp_temp_cond_out(100:end))*0.99,max(hp_temp_cond_out(100:end))*1.02])
title('������Һ�����¶�');xlabel('ʱ��(s)');ylabel('�¶ȣ���C��');grid on

subplot(4,4,15)
plot(time_step,deh_trans_air_enthalpy_change*deh_trans_air_mass)
ylim([min(deh_trans_air_enthalpy_change(100:end)*deh_trans_air_mass)*1.1,0])
title('��ʪ��������');xlabel('ʱ��(s)');ylabel('���ʣ�kW��');grid on

subplot(4,4,16)
plot(time_step,reg_trans_air_enthalpy_change*reg_trans_air_mass)
 ylim([0,max(reg_trans_air_enthalpy_change(100:end)*reg_trans_air_mass)*1.1])
title('������������');xlabel('ʱ��(s)');ylabel('���ʣ�kW��');grid on

hold off

figure(2)
suptitle('ϵͳ���������仯')
subplot(2,4,1)
plot(time_step,deh_trans_air_enthalpy_change*deh_trans_air_mass)
ylim([min(deh_trans_air_enthalpy_change(100:end)*deh_trans_air_mass)*1.1,0])
title('��ʪ��������');xlabel('ʱ��(s)');ylabel('���ʣ�kW��');grid on

subplot(2,4,2)
plot(time_step,-N.*cop)
 ylim([min(-N.*cop)*1.1,0])
title('ѹ��������');xlabel('ʱ��(s)');ylabel('���ʣ�kW��');grid on

subplot(2,4,3)
plot(time_step,deh_sink_sol_enth_all_exchange)
title('��ʪˮ���ʽ��������仯');xlabel('ʱ��(s)');ylabel('���ʣ�kW��');grid on

subplot(2,4,4)
plot(time_step,-deh_trans_air_enthalpy_change*deh_trans_air_mass-N.*cop+deh_sink_sol_enth_all_exchange)
ylim([-0.2,0.2])
title('��ʪˮ�������仯');xlabel('ʱ��(s)');ylabel('���ʣ�kW��');grid on

subplot(2,4,5)
plot(time_step,reg_trans_air_enthalpy_change*reg_trans_air_mass)
 ylim([0,max(reg_trans_air_enthalpy_change(100:end)*reg_trans_air_mass)*1.1])
title('������������');xlabel('ʱ��(s)');ylabel('���ʣ�kW��');grid on

subplot(2,4,6)
plot(time_step,N.*(cop+1))
 ylim([0,max(N.*(cop+1))*1.1])
title('ѹ��������');xlabel('ʱ��(s)');ylabel('���ʣ�kW��');grid on

subplot(2,4,7)
plot(time_step,reg_sink_sol_enth_all_exchange)
title('����ˮ���ʽ��������仯');xlabel('ʱ��(s)');ylabel('���ʣ�kW��');grid on

subplot(2,4,8)
plot(time_step,reg_trans_air_enthalpy_change*reg_trans_air_mass-N.*(cop+1)-reg_sink_sol_enth_all_exchange)
ylim([-0.2,0.2])
title('����ˮ�������仯');xlabel('ʱ��(s)');ylabel('���ʣ�kW��');grid on

hold off

figure(3)

subplot(2,2,1)
plot(time_step,err_da_deh)
title('��ʪ�����������������');xlabel('ʱ��(s)');ylabel('������');grid on

subplot(2,2,2)
plot(time_step,err_ha_deh)
title('��ʪ�����������������');xlabel('ʱ��(s)');ylabel('������');grid on

subplot(2,2,3)
plot(time_step,err_da_reg)
title('���������������������');xlabel('ʱ��(s)');ylabel('������');grid on

subplot(2,2,4)
plot(time_step,err_ha_reg)
title('���������������������');xlabel('ʱ��(s)');ylabel('������');grid on

hold off