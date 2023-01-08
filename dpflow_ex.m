function [eff,v_3p,K_uN,p_loss_total,q_loss_total,itrano] = dpflow_ex(distCase)
    %% adding dpflow so i can use all functions
    % this function to determine the unbalancing ratio losses TL eff for specific system 
    % the inputs is 
    % the distcase is the case required to solve 
    % id_bus >> the bus required to calculate the unbalancing ratio for it 
    % neutral_flag >> is the flag that determine if the neutral is included or not or the system is 3 wire or 4 wire 
    %% running the program
    Result = dpflow(distCase);
    %% the power losses
    [p_loss,q_loss]=loss_p_q(Result.branchInfo);
    p_loss_total=sum(sum(p_loss(:,(3:5))));   %% G1
    q_loss_total=sum(sum(q_loss(:,(3:5))));  
    %% the voltage profile
    v_3p=Result.busInfo(:,2:4)-1; %%G2 voltage profile in three phases
    %% the unbalancing_Ratio
    for id_bus=1:length(Result.busInfo(:,1)) %% G3
            K_uN(id_bus)=unbalancing_Ratio(Result,id_bus);
    end
    %% efficiency of the device
    P_total=distCase.yload(1,2)+distCase.yload(1,3)+distCase.yload(1,4);
    eff=(P_total*1e6)/(P_total*1e6+p_loss_total)*100;
    itrano=Result.itrano;
end