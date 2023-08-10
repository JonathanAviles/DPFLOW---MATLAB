function [eff,system_losses_mt,system_losses_mtn,losses_N_mt,K_uN,P_A_m]=pa_bal1_eff(distCase,no_load,id_bus)
% all data for the IEEE 4 bus system 
%no_load=1; % this is to define the id for a specific load in the bus data 
% discase >> this is the case study to load 
%% the main program
    P_total=distCase.yload(no_load,2)+distCase.yload(no_load,3)+distCase.yload(no_load,4);
    if (P_total-2*distCase.P_max)<0
        P_A_m=0.01:0.01:distCase.P_max; %% to reject the negative values
    else
        P_A_m=(P_total-2*distCase.P_max):0.01:distCase.P_max;%% removing reactive power increase the voltage so the load variation is being more flexible the max loading is 5.4 MVAR 3*1.8 MVAR
    end
    n=1;
    itrano=0;

        for P_A=P_A_m
            %calculate the power of the three phases 
            distCase.yload(no_load,2)=P_A;
            distCase.yload(no_load,3)=(P_total-distCase.yload(no_load,2))/2;
            distCase.yload(no_load,4)=distCase.yload(no_load,3);
            [eff(n),system_losses_mt(n),losses_N_mt(n),system_losses_mtn(n),K_uN(n),bus,branch,itrano] = dpflow_ext(distCase,id_bus,1);
            n=n+1;
            if distCase.options(1,2)==0 & itrano >=30 
                P_A_m(n:end)=[];  
                break;        
            end
        end

    P_A_m=P_A_m./distCase.P_sc;
end