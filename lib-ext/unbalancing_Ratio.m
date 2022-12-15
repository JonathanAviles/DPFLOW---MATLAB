function K_uN=unbalancing_Ratio(Result,id_bus)
%unbalancing_Ratio <one line description>
%
% unbalancing_Ratio() <explain usage>
% 
% the input is the result function the output of the dpflow toolbox
% id_bus that we need to calculate the bus unbalancing ratio 

% Author(s): <Ahmed M. Elkholy>
% Copyright <2021> <A.M.Elkholy>

v_a_u=Result.busInfo(id_bus,2)*exp(i*deg2rad(Result.busInfo(id_bus,2+3)));
v_b_u=Result.busInfo(id_bus,3)*exp(i*deg2rad(Result.busInfo(id_bus,3+3)));
v_c_u=Result.busInfo(id_bus,4)*exp(i*deg2rad(Result.busInfo(id_bus,4+3)));
V_a_b_u=abs(v_a_u-v_b_u);
V_b_c_u=abs(v_b_u-v_c_u);
V_c_a_u=abs(v_c_u-v_a_u);
U_r=(V_a_b_u^4+V_b_c_u^4+V_c_a_u^4)/(V_a_b_u^2+V_b_c_u^2+V_c_a_u^2)^2;
K_uN=abs(sqrt((1-sqrt(3-6*U_r))/(sqrt(6*U_r+3)+1)));
end