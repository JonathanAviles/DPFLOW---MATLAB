function [eff,system_losses_mt,losses_N_mt,system_losses_mtn,K_uN,busresult,branch,itrano] = dpflow_ext(distCase,id_bus,neutral_flag)
    %% adding dpflow so i can use all functions
    % this function to determine the unbalancing ratio losses TL eff for specific system 
    % the inputs is 
    % the distcase is the case required to solve 
    % id_bus >> the bus required to calculate the unbalancing ratio for it 
    % neutral_flag >> is the flag that determine if the neutral is included or not or the system is 3 wire or 4 wire 
    %% running the program
    [baseMVA,~, ~,bus, ~, yload, ~, lineBranch, ~,neutral] = loadDistCase(distCase);
    [line_branch,~]=size(lineBranch);
    Result = dpflow(distCase);
    %% calculate the unbalancing coefficient 
    K_uN=unbalancing_Ratio(Result,id_bus);
    %% calculate the losses in the power system all
    [p_loss,~]=loss_p_q(Result.branchInfo);
    p_loss(:,1:2)=[];
    system_losses_mt=sum(sum(p_loss))*1e3;

    switch neutral_flag
    case 1
    %% calculating the neutral line losses 
    losses_N_mt=0;
    for id_branch=1:line_branch
        [~,losses_N]=neutral_current(Result.branchInfo,neutral(id_branch,3),id_branch);
        losses_N_mt=losses_N_mt+losses_N;
    end    
    case 0
        losses_N_mt=0;
    end
        %% efficiency of the device
    system_losses_mtn=system_losses_mt+losses_N_mt;
    P_total=yload(1,2)+yload(1,3)+yload(1,4);
    eff=(P_total*1e6)/(P_total*1e6+system_losses_mtn)*100;
    busresult=Result.busInfo;
    branch=Result.branchInfo;
    itrano=Result.itrano;
end