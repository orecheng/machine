function [ AveAirMoistureOut,AveAirTempratureOut,AveSolTempratureOut,AveSolMassOut,AveSolConcenOut,AveSolEnthalpyOut] = cross_fcn( Ta_in,phi,Ts_in,Ps_in,Ma_in,Ms_in)
% Ta_in=30;%
% phi=0.8;%

T=Ta_in+273.15;
[rho_air,da_in,ha_in]= rh2da(Ta_in,phi);
% Ts_in=10;%
% Ps_in=0.3;%
rho_licl=cal_rho_licl(Ts_in,Ps_in);

% Va_in=4000;%
% Vs_in=4.8;%

% Ms_in=Vs_in;
% Ma_in=Va_in;

H=0.5;%
L=0.5;%
W=0.65;%

hs_in=sol_enthalpy(Ts_in,Ps_in);

meshgrid=0.005;
M=ceil(L/meshgrid);
N=ceil(H/meshgrid);

V=H*L*W;
Fa=Ma_in/(H*W);
Fz=Ms_in/(W*L);
if Ts_in>35
    a=[0.010296438	-0.833147603	1.180504199	-23.45078711];%����
else
    a=[5.094975587	-0.061006773	0.609178325	-1.330942842];%��ʪ
end
NTU=a(1)*V*Fa^a(2)*Fz^a(3)*(1-Ps_in)^a(4);%
%% ˮ�ڿ����е���ɢϵ��
Dair=(-0.29890+1.6253e-3*T+7.5e-7*T^2)*1e-4;
%% �����Ķ���ճ�Ⱥ��˶�ճ��
mu_da=[-2.448e-6,0.005072,1.713]*[Ta_in^2;Ta_in;1]*1e-5; %����ճ��
nv_da=mu_da/rho_air; %�˶�ճ��
%% Thermal Conductivity of Air
lamda=[6.993e-8,0.007618,2.442]*[Ta_in^2;Ta_in;1]*1e-2;
%% Sc
Sc=nv_da/Dair;
%% Pr
Cpa=1.01e3;
Pr=mu_da*Cpa/lamda;
Le=Sc/Pr;
%% Initial of Matrix
SolEnthalpy=zeros(N,M);
AirMoisture=zeros(N,M);
AirEnthalpy=zeros(N,M);
AirTemprature=zeros(N,M);
SolTemprature=zeros(N,M);
SolMass=zeros(N,M);
SolConcen=zeros(N,M);
%% row_1 column_1
[AirMoisture(1,1),AirTemprature(1,1),AirEnthalpy(1,1),SolTemprature(1,1),SolMass(1,1),SolConcen(1,1),SolEnthalpy(1,1)]= cross_core(Ts_in,Ps_in,Ms_in/M,ha_in,da_in,Ma_in/N,M,N,NTU,Le);
%% row_1
for j=2:M
    [AirMoisture(1,j),AirTemprature(1,j),AirEnthalpy(1,j),SolTemprature(1,j),SolMass(1,j),SolConcen(1,j),SolEnthalpy(1,j)]= cross_core(Ts_in,Ps_in,Ms_in/M,AirEnthalpy(1,j-1),AirMoisture(1,j-1),Ma_in/N,M,N,NTU,Le);
end
%% column_1
for i=2:N
    [AirMoisture(i,1),AirTemprature(i,1),AirEnthalpy(i,1),SolTemprature(i,1),SolMass(i,1),SolConcen(i,1),SolEnthalpy(i,1)]= cross_core(SolTemprature(i-1,1),SolConcen(i-1,1),SolMass(i-1,1),ha_in,da_in,Ma_in/N,M,N,NTU,Le);
end
%% row_2~row_end  column_1~column_end
for i=2:N
    for j=2:M
        [AirMoisture(i,j),AirTemprature(i,j),AirEnthalpy(i,j),SolTemprature(i,j),SolMass(i,j),SolConcen(i,j),SolEnthalpy(i,j)]= cross_core(SolTemprature(i-1,j),SolConcen(i-1,j),SolMass(i-1,j),AirEnthalpy(i,j-1),AirMoisture(i,j-1),Ma_in/N,M,N,NTU,Le);
    end
end

%% Average Out
AveAirMoistureOut =mean(AirMoisture(1:N,M));
AveAirEnthalpyOut =mean(AirEnthalpy(1:N,M));
AveAirTempratureOut =mean(AirTemprature(1:N,M));

AveSolTempratureOut =mean(SolTemprature(N,1:M));
AveSolMassOut=sum(SolMass(N,1:M));
AveSolConcenOut=mean(SolConcen(N,1:M));
AveSolEnthalpyOut=mean(SolEnthalpy(N,1:M));

err  = (ha_in-AveAirEnthalpyOut)*Ma_in/(sum(SolEnthalpy(N,1:M).*SolMass(N,1:M))-hs_in*Ms_in)-1;
err2 = (da_in-AveAirMoistureOut)*Ma_in/(sum(SolMass(N,1:M))-Ms_in)-1;


end

