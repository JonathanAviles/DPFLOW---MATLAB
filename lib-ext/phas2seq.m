function [Vp,Vn,V0]=phas2seq(Va,Vb,Vc)
%% this function introduces the way to calculate the negative and positive and zero sequences
%% [Vp,Vn,V0]=phas2seq(Va,Vb,Vc)
%% the value of the a=1<120 deg and this for the (abc) system that means the phase b have the angle -120 and phase c have angle 120
    a=exp(1j*((2*pi)/3));
    Vpn0=(1/3).*[1 a a^2;1 a^2 a;1 1 1]*[Va;Vb;Vc];
    Vp=Vpn0(1);
    Vn=Vpn0(2);
    V0=Vpn0(3);
end