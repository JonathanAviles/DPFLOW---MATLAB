function [I_N,losses_N]=neutral_current(branchInfo,R_l,id_branch)
%neutral_current <this fucntion to calculate the neutral current from the three phases >
    % See also <list related>
    % the branchinfo is the current in the TL >> the output of the dpflow
    % R_line >> the line resistance
    % id_branch >> is the number of the line that you want to calculate the losses in it
    % the output of the function is 
        % the output is the neutral line and the losses at the neutral line in "watt"
    % Author(s): <Ahmed M. Elkholy>
    % Copyright <2021> <A.M.Elkholy>
%% tst
%{
clc; clear all 
Result = dpflow(distCase_4bus33_11k(1))
[I_N,losses_N]=neutral_current(Result.branchInfo,3.7920,1);
%}
%% adapting the branchInfo matrix
[n_branch,~]=size(branchInfo);
branchInfo([n_branch-1:n_branch],:)=[];
        %%the curents in the results matrics 1 for the current between the bus 1 to 2
        % the number 2 is the current between the bus 3 and 4
I_b=zeros(3,1);
for n=1:3
    I_b(n,1)=branchInfo(id_branch,2+n).*exp(deg2rad(branchInfo(id_branch,2+n+3))*1i);
end
%% calculating the losses in the system
I_mat=[I_b(1)           0           0
       0                I_b(2)      0
       0                0           I_b(3)];
I=[ I_mat(1,1)
    I_mat(2,2)
    I_mat(3,3)];
I_N=sqrt(sum(abs(I).^2)-abs(I(1))*abs(I(2))-abs(I(2))*abs(I(3))-abs(I(3))*abs(I(1)));
losses_N=I_N^2*R_l;
end