function yload=zigfun(zig,Vlg_pu,Ypr,Ybus,yload,yload_busid,index,branch_index,baseMVA);
%zigmfun < this function is to modify the yload matrix to inculde the zigzag transformer the paper will be added at the end>
%
% 
% the input is the result function the output of the dpflow toolbox
% x is the solution at every case  
% zig the buses which install the zigzag transformer
% BASEKV is the base voltage for every bus 
% Ybus is the ybus matrix 
% yload is the load matrix which will be readModified

% Author(s): <Ahmed M. Elkholy>
% Copyright <2023> <A.M.Elkholy>

%%% find the
[row,~] = find(index==zig);
[row_yload,~] = find(yload_busid==zig);
row=row';
row_yload=row_yload';
%% after calculation 
% Ibranch_pu = Ypr * Vbranch_pu;
Ibus_pu  = Ybus * Vlg_pu;
Ibus_mat=threePhaseArray(Ibus_pu);
% Ibranch_mat=threePhaseArray(Ibranch_pu);
Vbus_mat=threePhaseArray(Vlg_pu);
% [index, Ibus_mat];
% [branch_index,Ibranch_mat];
i=1;
for zig_mo=row
    I_zig_ph=sum(Ibus_mat(zig_mo,:))/3
    s_zig=(Vbus_mat(zig_mo,:).*conj(I_zig_ph)).*baseMVA
    yload(row_yload(i),2)=yload(row_yload(i),2)-real(s_zig(1));
    yload(row_yload(i),2)=yload(row_yload(i),3)-real(s_zig(2));
    yload(row_yload(i),4)=yload(row_yload(i),4)-real(s_zig(3));
    yload(row_yload(i),5)=yload(row_yload(i),5)-imag(s_zig(1));
    yload(row_yload(i),6)=yload(row_yload(i),6)-imag(s_zig(2));
    yload(row_yload(i),7)=yload(row_yload(i),7)-imag(s_zig(3));
    i=i+1;
end
end