function Vxxx=phas2seq(Vyyy,flg)
%% this function introduces the way to calculate the negative and positive and zero sequences
%% [Vp,Vn,V0]=phas2seq(Va,Vb,Vc)
%% the value of the a=1<120 deg and this for the (abc) system that means the phase b have the angle -120 and phase c have angle 120
%%%%%%%% flg
%% if the flg=1 >> convert from abc to pn0
%% if the flg=2 >> convert from pn0 to abc
switch flg
    case 1
    a=exp(1j*((2*pi)/3));
    Vxxx=(1/3).*[1 a a^2;1 a^2 a;1 1 1]*Vyyy;
    case 2
    a=exp(1j*((2*pi)/3));
    Vxxx=(3).*[1 a a^2;1 a^2 a;1 1 1]^-1*Vyyy;
    end
end