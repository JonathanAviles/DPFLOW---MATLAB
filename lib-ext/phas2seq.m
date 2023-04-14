function [Vp,Vn,V0]=phas2seq(Va,Vb,Vc)
    a=exp(1j*((2*pi)/3));
    Vpn0=(1/3).*[1 a a^2;1 a^2 a;1 1 1]*[Va;Vb;Vc];
    Vp=Vpn0(1);
    Vn=Vpn0(2);
    V0=Vpn0(3);
end