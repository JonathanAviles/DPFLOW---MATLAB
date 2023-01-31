function I3_A3=current_lf(branchInfo)
% this identify the currents in ever phase per line 
% the input is the result function the output of the dpflow toolbox

% Author(s): <Ahmed M. Elkholy>
% Copyright <2023> <A.M.Elkholy>

%% current of the phases 
[n_row,n_col]=size(branchInfo);
% remove the additional rows
branchInfo([n_row-1:n_row],:)=[];
% remove the losses
branchInfo(:,[9:14])=[];
I3_A3=branchInfo;
end