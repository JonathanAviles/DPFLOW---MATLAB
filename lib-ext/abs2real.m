function y3ph=abs2real(Xinfo,id_x,flag)
%% this function is to get the current or the voltage according to the flag of specific Xinfo as real and imag
%% y3ph=abs2real(Xinfo,id_x,flag)
%% Xinfo is the businfo or branchInfo
%% id_x is the the id of the bus or the branch 
%% flag is 'i' or 'v'
%% the input is the branch info and id branch
%% the output is a column contains the three phases currents

% Author(s): <Ahmed M. Elkholy>
% Copyright <2023> <A.M.Elkholy>

%% current of the phases 
switch flag
    case 'i' 
    y3ph=[Xinfo(id_x,3);Xinfo(id_x,4);Xinfo(id_x,5)].*exp(1j*([deg2rad(Xinfo(id_x,6));deg2rad(Xinfo(id_x,7));deg2rad(Xinfo(id_x,8))]));
    case 'v' 
    y3ph=[Xinfo(id_x,2);Xinfo(id_x,3);Xinfo(id_x,4)].*exp(1j*([deg2rad(Xinfo(id_x,5));deg2rad(Xinfo(id_x,6));deg2rad(Xinfo(id_x,7))]));
    end
end