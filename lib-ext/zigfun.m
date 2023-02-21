function yload=zigfun(zig,Vlg,Ibus,yload,yload_busid,index);
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
switch 1
case 1
    %%% find the
    [row,~] = find(index==zig);
    [row_yload,~] = find(yload_busid==zig);
    row=row';
    row_yload=row_yload';
    %% after calculation 
    Ibus_mat=threePhaseArray(Ibus);
    % Ibranch_mat=threePhaseArray(Ibranch_pu);
    Vbus_mat=threePhaseArray(Vlg);
    % i_index=[index,Ibus_mat]
    % v_index=[index,vbus_mat]
    i=1;
    for zig_mo=row
        I_zig_ph=sum(Ibus_mat(zig_mo,:))/3;
        s_zig=(Vbus_mat(zig_mo,:).*conj(I_zig_ph))/1e6;
        yload(row_yload(i),2)=yload(row_yload(i),2)-real(s_zig(1));
        yload(row_yload(i),2)=yload(row_yload(i),3)-real(s_zig(2));
        yload(row_yload(i),4)=yload(row_yload(i),4)-real(s_zig(3));
        yload(row_yload(i),5)=yload(row_yload(i),5)-imag(s_zig(1));
        yload(row_yload(i),6)=yload(row_yload(i),6)-imag(s_zig(2));
        yload(row_yload(i),7)=yload(row_yload(i),7)-imag(s_zig(3));
        i=i+1;
    end
case 2
    Ibus_mat=threePhaseArray(Ibus);
    % Ibranch_mat=threePhaseArray(Ibranch_pu);
    Vbus_mat=threePhaseArray(Vlg);
    I3ph_675=Ibus_mat(13,:);
    v3ph_675=Vbus_mat(13,:);
    % v3ph_675=abs2real(Result,13,'v').*(2.4017771198e3);

    I_zig_675=sum(I3ph_675)/3;
    s_zig_675=(v3ph_675.*conj(I_zig_675))/ (1e6)
    nox=-1;
    yload(4,2)=yload(4,2)+nox*real(s_zig_675(1));
    yload(4,3)=yload(4,3)+nox*real(s_zig_675(2));
    yload(4,4)=yload(4,4)+nox*real(s_zig_675(3));
    yload(4,5)=yload(4,5)+nox*imag(s_zig_675(1));
    yload(4,6)=yload(4,6)+nox*imag(s_zig_675(2));
    yload(4,7)=yload(4,7)+nox*imag(s_zig_675(3));


end