function I3ph=abs2real(branchInfo,id_branch)
% this function is to get the current of specific branchInfo as real and imag
% the input is the branch info and id branch
% the output is a column contains the three phases currents

% Author(s): <Ahmed M. Elkholy>
% Copyright <2023> <A.M.Elkholy>

%% current of the phases 
I3ph=[branchInfo(id_branch,3);branchInfo(id_branch,4);branchInfo(id_branch,5)].*exp(1j*([deg2rad(branchInfo(id_branch,6));deg2rad(branchInfo(id_branch,7));deg2rad(branchInfo(id_branch,8))]));
end