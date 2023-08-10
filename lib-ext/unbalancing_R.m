function K_uN=unbalancing_R(Result,id_bus)
%unbalancing_Ratio <one line description>
% the input is the result function the output of the dpflow toolbox
% id_bus that we need to calculate the bus unbalancing ratio 
% the output of this function is the unbalancing coefficient for zero and negative as vector K_uN=[k_0;k_1]

% Author(s): <Ahmed M. Elkholy>
% Copyright <2021> <A.M.Elkholy>
v_a_u=Result.busInfo(id_bus,2)*exp(i*deg2rad(Result.busInfo(id_bus,2+3)));
v_b_u=Result.busInfo(id_bus,3)*exp(i*deg2rad(Result.busInfo(id_bus,3+3)));
v_c_u=Result.busInfo(id_bus,4)*exp(i*deg2rad(Result.busInfo(id_bus,4+3)));
Vabc=[v_a_u;v_b_u;v_c_u];
Vpno=phase1sym(Vabc,'sym');
K_uN=abs([Vpno(3);Vpno(2)]./Vpno(1));
end