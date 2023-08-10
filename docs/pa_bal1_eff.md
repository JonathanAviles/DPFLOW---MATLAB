## [eff,system_losses_mt,system_losses_mtn,losses_N_mt,K_uN,P_A_m]=pa_bal1_eff(distCase,no_load,id_bus)
% all data for the IEEE 4 bus system 
%no_load=1; % this is to define the id for a specific load in the bus data 
% discase >> this is the case study to load 

this function to calculate the overall efficiency and overall losses and unbalancing_Ratio for all transmission lines 



## TODO [[dpflow_ext]]

- [ ] convert this function to be like this [sys,busresult,branch,itrano] = dpflow_ext(distCase,neutral_flag)
- [ ] modify the project for IEEE4 modified bus 


sys.eff
sys.system_losses_mt
sys.losses_N_mt
sys.system_losses_mtn
sys.itrano

busresult=[busresult K_uN] % add the unbalancing ratio to the bus data