function [p_loss,q_loss]=loss_p_q(branchInfo)
% this identify the losses in ever phase per line 
% the input is the result function the output of the dpflow toolbox
%[p_loss,q_loss]=loss_p_q(branchInfo)

% Author(s): <Ahmed M. Elkholy>
% Copyright <2023> <A.M.Elkholy>

%% active power losses 
[n_row,n_col]=size(branchInfo);
branchInfo([n_row-1:n_row],:)=[];
branch_1=branchInfo;
branch_1(:,[3:8])=[];
branch_1(:,[6:8])=[];
p_loss=branch_1;

%% reactive power 
branch_2=branchInfo;
branch_2(:,[3:8])=[];
branch_2(:,[3:5])=[];
q_loss=branch_2;

end