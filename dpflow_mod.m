function outputObject = dpflow_mod(caseObject)
    %%Timer starts
    t1 = clock;
    %% Labels
    [~, ~, ~, ~, BID, ~, VMA, VMB, VMC, VAA, VAB, VAC, BASEKV] = busIndexer;
    [FBUS, TBUS, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ...
        ~, ~, ~, ~, ~, ~, ~] = lineBranchIndexer;
    %% 
    [baseMVA, ~, ~, bus, gen, yload, dload, lineBranch, trafoBranch,~,zig] = loadDistCase(caseObject);
    %Number of elements
    nnodes = size(bus,1);
    nyload = size(yload,1);
    ndload = size(dload,1);
    nline  = size(lineBranch,1);
    ntrafo = size(trafoBranch,1);
    yload_busid=yload(:,BID); %% this is used in  zigzag function because the yload is changed after the function ext2intID 
    index = caseObject.bus(:,BID); %% to calculate the index of the buses
    %% create links and conn matrix to be used in the output calculation
    if nnodes<=1000
        Conn = connectionMatrix(index,caseObject.lineBranch(:,FBUS:TBUS),caseObject.trafoBranch(:,FBUS:TBUS),nnodes);
        trafoLink = zeros(2*ntrafo,2);
        for n=1:ntrafo
            trafoLink(2*n-1,:) = [caseObject.trafoBranch(n,FBUS),-n];
            trafoLink(2*n  ,:) = [-n,caseObject.trafoBranch(n,TBUS)];
        end
        links = [caseObject.lineBranch(:,FBUS:TBUS);trafoLink];
    end
    %% Indexing
    ext2intID = zeros(nnodes,1);
    ext2intID(bus(:,BID))=(1:nnodes)';
    bus(:,BID) = (1:nnodes)';
    gen(:,BID) = ext2intID(gen(:,BID));
    if (nyload~=0)
        yload(:,BID) = ext2intID(yload(:,BID));
    end
 % yload
    if (ndload~=0)
        dload(:,BID) = ext2intID(dload(:,BID));
    end
    if (nline~=0)
        lineBranch(:,FBUS) = ext2intID(lineBranch(:,FBUS));
        lineBranch(:,TBUS) = ext2intID(lineBranch(:,TBUS));
    end
    if (ntrafo~=0)
        trafoBranch(:,FBUS) = ext2intID(trafoBranch(:,FBUS));
        trafoBranch(:,TBUS) = ext2intID(trafoBranch(:,TBUS));
    end
    
    %%
    [~,pv3,pq3]=distBusTypes(bus);
    [Ybus,Ypr] = YMaker(nnodes, yload, dload, lineBranch, trafoBranch, baseMVA);
    mp = find(any(Ybus,2)==0);
    %ref = setdiff(reshape([3*ref3-2,3*ref3-1,3*ref3].',[],1),mp);
    pv = setdiff(reshape([3*pv3-2,3*pv3-1,3*pv3].',[],1),mp);
    pq = setdiff(reshape([3*pq3-2,3*pq3-1,3*pq3].',[],1),mp);
    
    %Turn angles from degrees into radians
    bus(:,[VAA, VAB, VAC]) = bus(:,[VAA, VAB, VAC])*pi/180;
    
    % Voltage bus allocation (magnitude and angle)
    V_mag = reshape(bus(:,[VMA, VMB, VMC]).',[],1);
    V_ang = reshape(bus(:,[VAA, VAB, VAC]).',[],1);
    
    %%  Initial values for fsolve
    x0=[V_ang([pv;pq]);V_mag(pq)];
    %%Timer starts
    t2 = clock;
    %global res
    %global iter
    if caseObject.options(1,1)==1 %option flag to show the output 
    options=optimoptions('fsolve','TolFun',1E-10,'FiniteDifferenceType',...
    'central','MaxFunEvals',200000,'Display','iter','MaxIter',1000,...
    'Jacobian','on','OutputFcn',@resfun);
    end
    if caseObject.options(1,1)==0 %option flag to show the output
    options=optimoptions('fsolve','TolFun',1E-10,'FiniteDifferenceType',...
    'central','MaxFunEvals',200000,'Display','off','MaxIter',1000,...
    'Jacobian','on','OutputFcn',@resfun);
    end 

    xsol = fsolve(@loadsol,x0,options);
        function [diff,J]=loadsol(x)
            [Swye, Sdelta, Iwye, Idelta]= Sbus_creation(baseMVA, gen, yload, dload ,nnodes);
            [Ybus,Ypr] = YMaker(nnodes, yload, dload, lineBranch, trafoBranch, baseMVA);
            V_ang(pv)=x(1:length(pv));
            V_ang(pq)=x(length(pv)+1:length([pv;pq]));
            V_mag(pq)=x(length(pv)+length(pq)+1:length(x));
            Vbus = V_mag.*exp(1i*V_ang);
            
            VLL = phaseGround2phasePhase(Vbus);
            Ibus_delta = (Sdelta + Idelta.*abs(VLL)/sqrt(3))./VLL;
            Sbus = Swye + Iwye.*abs(Vbus) + Vbus.*(Ibus_delta-threePhaseShift(Ibus_delta,1));
            mis = Vbus .* conj(Ybus * Vbus) - Sbus;
            diff = [real(mis([pv; pq])); imag(mis(pq))];
            
            %Calculate the jacobian, matpowerstyle.
            [dSbus_dVm, dSbus_dVa] = dSbus_dV_full(Ybus, Vbus, VLL, Sdelta, Iwye, Idelta);

            j11 = real(dSbus_dVa([pv; pq], [pv; pq]));
            j12 = real(dSbus_dVm([pv; pq], pq));
            j21 = imag(dSbus_dVa(pq, [pv; pq]));
            j22 = imag(dSbus_dVm(pq, pq));

            J = [   j11 j12;
                    j21 j22;    ];
            if ~isempty(zig)
                V_ang(pv)=x(1:length(pv));
                V_ang(pq)=x(length(pv)+1:length([pv;pq]));
                V_mag(pq)=x(length(pv)+length(pq)+1:length(x));
                Vlg_pu = V_mag.*exp(1i*V_ang);
                yload=zigfun(zig,Vlg_pu,Ypr,Ybus,yload,yload_busid,index,links,baseMVA);
            end
        end
        function stop=resfun(~,optimValues,state)
            switch state
                case 'iter'
                    L=optimValues.fval;
                    iter=optimValues.iteration;
                    resnorm=L'*L;
                    res(iter+1)=resnorm;
                    stop=0;
                otherwise
                    stop=0;
            end
            outputObject.itrano=max(optimValues.iteration);
        end

    %% Output format             
    V_ang(pv)=xsol(1:length(pv));
    V_ang(pq)=xsol(length(pv)+1:length([pv;pq]));
    V_mag(pq)=xsol(length(pv)+length(pq)+1:length(xsol));
    Vlg_pu = V_mag.*exp(1i*V_ang);
    
    %%Timer ends
    t3 = clock;

    baseVoltages = tripleVector(caseObject.bus(:,BASEKV));
    Vlg = Vlg_pu.*1e3.*baseVoltages;
    Vll = phaseGround2phasePhase(Vlg);
% Ybus
% Vlg_pu
% full(Ybus)

    Ibus_pu  = Ybus * Vlg_pu;
    Ibase    = baseMVA*1e3./baseVoltages;
    Ibus     = Ibase.*Ibus_pu;

    Sbus_MVA  = Vlg.*conj(Ibus)/1e6;
    

    %% Bus quantities
    outputObject.busInfo = zeros(nnodes,22);
    outputObject.busInfo(:,1)     = index;
    outputObject.busInfo(:,2:4)   = threePhaseArray(abs(Vlg_pu));
    outputObject.busInfo(:,5:7)   = threePhaseArray(angle(Vlg_pu)*180/pi);
    outputObject.busInfo(:,8:10)  = threePhaseArray(abs(Vlg));
    outputObject.busInfo(:,11:13) = threePhaseArray(abs(Vll));
    outputObject.busInfo(:,14:16) = threePhaseArray(angle(Vll)*180/pi);
    outputObject.busInfo(:,17:19) = threePhaseArray(real(Sbus_MVA));
    outputObject.busInfo(:,20:22) = threePhaseArray(imag(Sbus_MVA));
      
    if nnodes<=1000


        numbr = size(links,1);
        Ibr_base = zeros(3*numbr,1);
        for n=1:size(links,1)
            if(links(n,1)~=-1)
                Ibr_base(3*n-2:3*n) = baseMVA*1e3./caseObject.bus(caseObject.bus(:,BID)==links(n,1),BASEKV);
            else
                Ibr_base(3*n-2:3*n) = baseMVA*1e3./caseObject.bus(caseObject.bus(:,BID)==links(n,2),BASEKV);
            end
        end

        Vbranch_pu = Conn * Vlg_pu;
        Ibranch_pu = Ypr * Vbranch_pu;
        Ibranch = Ibranch_pu .*Ibr_base;
        Sloss = 1e3 * baseMVA * Vbranch_pu .* conj(Ibranch_pu); %kVA
        
        %% Branch quantities
        outputObject.branchInfo = zeros(numbr,14);
        outputObject.branchInfo(:,1:2)   = links;
        outputObject.branchInfo(:,3:5)   = threePhaseArray(abs(Ibranch));
        outputObject.branchInfo(:,6:8)   = threePhaseArray(angle(Ibranch)*180/pi);
        outputObject.branchInfo(:,9:11)   = threePhaseArray(real(Sloss));
        outputObject.branchInfo(:,12:14) = threePhaseArray(imag(Sloss));
    end 
    outputObject.Ypr=Ypr;
    
    %% Save results to file
    t4 = clock;
    if caseObject.options(1,1)==1
    fprintf('Time elapsed per stage:\n')
    fprintf('Data preparation   : %.4f seconds\n',etime(t2,t1));
    fprintf('Nonlinear solver   : %.4f seconds\n',etime(t3,t2));
    fprintf('Saving to file     : %.4f seconds\n',etime(t4,t3));
    fprintf('____________________________________\n');
    fprintf('Total elapsed time : %.4f seconds\n\n',etime(t4,t1));
    end 
    
    if caseObject.options(1,3)==1
    saveDistCaseResults(outputObject);
    fprintf('Results saved to file distCaseResults\n');
    end 
end % End of function
