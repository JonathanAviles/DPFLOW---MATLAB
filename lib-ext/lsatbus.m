function S=lsatbus(Result,id_branch,id_bus,v_base)
% lsatbus  this is to calculate the power at specific bus 
%
% mfun() <{3:explain usage}>
% this function is calculating the power at a certain bus
% the input is the result function the output of the dpflow toolbox
% nbraanch the branch of the current needs to calculate 
% nbus the bus 
% Author(s): <Ahmed M. Elkholy>
% Copyright <2023> <A.M.Elkholy>
%current
for n=1:3
     I_b(n,1)=Result.branchInfo(id_branch,2+n).*exp(deg2rad(Result.branchInfo(id_branch,2+n+3))*1i);
end
%voltage
for n=1:3
     V_b(n,1)=v_base*Result.busInfo(id_bus,1+n).*exp(deg2rad(Result.busInfo(id_bus,1+n+3))*1i);
end
S.sl=V_b .* conj(I_b);
S.pl=real(S.sl);
S.il=imag(S.sl);
S.pt=sum(S.pl);
S.it=sum(S.il);
end