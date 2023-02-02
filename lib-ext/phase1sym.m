function Vxxx=phase1sym(Vyyy,flg)
%% this function introduces the way to calculate the negative and positive and zero sequences
%% Vabc=phase1sym(Vpno,'phase') Vpno=phase1sym(Vabc,'sym')
%% the value of the a=1<120 deg and this for the (abc) system that means the phase b have the angle -120 and phase c have angle 120
%% if the flg=phas >> convert from abc to pn0
%% if the flg=2 >> convert from pn0 to abc
switch flg
    case 'sym' 
    a=exp(1j*((2*pi)/3));
    Vxxx=(1/3).*[1 a a^2;1 a^2 a;1 1 1]*Vyyy;
    case 'phase' 
    a=exp(1j*((2*pi)/3));
    Vxxx=(3).*[1 a a^2;1 a^2 a;1 1 1]^-1*Vyyy;
    end
end