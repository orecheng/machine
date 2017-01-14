function [Mhotout,Thotout,Photout,Mcoldout,Tcoldout,Pcoldout] = heatexchanger(Mhotin,Thotin,Photin,Mcoldin,Tcoldin,Pcoldin)
%#codegen
Cpw=4180;
k=2500;
A=2;


Thot0=abs((Thotin+273.15)/228-1);

if Photin<=0.31
    Fh1=1.4398*Photin-1.24317*Photin^2-0.1207*Photin^3;
else
    Fh1=0.12825+0.62934*Photin;
end

% Fh1=1.4398*Photin-1.24317*Photin^2-0.1207*Photin^3;
Fh2=58.5225*Thot0^0.02-105.634*Thot0^0.04+47.7948*Thot0^0.06;
CpsolH=Cpw*(1-Fh1*Fh2);

Tcold0=abs((Tcoldin+273.15)/228-1);

if Photin<=0.31
    Fc1=1.4398*Pcoldin-1.24317*Pcoldin^2-0.1207*Pcoldin^3;
else
    Fc1=0.12825+0.62934*Pcoldin;
end

% Fc1=1.4398*Pcoldin-1.24317*Pcoldin^2-0.1207*Pcoldin^3;
Fc2=58.5225*Tcold0^0.02-105.634*Tcold0^0.04+47.7948*Tcold0^0.06;
CpsolC=Cpw*(1-Fc1*Fc2);

Cr=min(Mhotin*CpsolH,Mcoldin*CpsolC)/max(Mhotin*CpsolH,Mcoldin*CpsolC);
NTU=k*A/min(Mhotin*CpsolH,Mcoldin*CpsolC);

eff=(1-exp(-NTU*(1-Cr)))/(1-Cr*exp(-NTU*(1-Cr)));

if Mhotin*CpsolH<=Mcoldin*CpsolC
    Thotout=Thotin-eff*(Thotin-Tcoldin);
    Tcoldout=(Mhotin*CpsolH)/(Mcoldin*CpsolC)*(Thotin-Thotout)+Tcoldin;
elseif Mhotin*CpsolH>Mcoldin*CpsolC
    Tcoldout=Tcoldin+eff*(Thotin-Tcoldin);
    Thotout=Thotin-(Mcoldin*CpsolC)/(Mhotin*CpsolH)*(Tcoldout-Tcoldin);
else
    Tcoldout=Tcoldin+eff*(Thotin-Tcoldin);
    Thotout=Thotin-(Mcoldin*CpsolC)/(Mhotin*CpsolH)*(Tcoldout-Tcoldin);
end

Mhotout=Mhotin;
Mcoldout=Mcoldin;
Photout=Photin;
Pcoldout=Pcoldin;
end
