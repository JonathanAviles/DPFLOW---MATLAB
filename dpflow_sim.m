function outputObject = dpflow_sim(caseObject)
    % caseObject=distCase_13bus_nodistload;
[baseMVA, ~, ~, bus, gen, yload, dload, lineBranch, trafoBranch,~] = loadDistCase(caseObject);
%% modifying buses
[~, ~, ~, ~, BID, ~, VMA, VMB, VMC, VAA, VAB, VAC, BASEKV] = busIndexer;
[FBUS, TBUS, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ...
    ~, ~, ~, ~, ~, ~, ~] = lineBranchIndexer;
% [baseMVA, ~, ~, bus, gen, yload, dload, lineBranch, trafoBranch,~] = loadDistCase(caseObject);
    %Number of elements
    nnodes = size(bus,1);
    nyload = size(yload,1);
    ndload = size(dload,1);
    nline  = size(lineBranch,1);
    ntrafo = size(trafoBranch,1);
    %% Indexing
    ext2intID = zeros(nnodes,1);
    ext2intID(bus(:,BID))=(1:nnodes)';
    bus(:,BID) = (1:nnodes)';
    gen(:,BID) = ext2intID(gen(:,BID));
    if (nyload~=0)
        yload(:,BID) = ext2intID(yload(:,BID));
    end
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
    [Ybus, Ypr] = YMaker(nnodes, yload, dload, lineBranch, trafoBranch, baseMVA);

    index = caseObject.bus(:,BID);
        baseVoltages = tripleVector(caseObject.bus(:,BASEKV));
    Vlg = caseObject.Vlg_pu.*1e3.*baseVoltages;
    Vll = phaseGround2phasePhase(Vlg);

    Ibus_pu  = Ybus * caseObject.Vlg_pu;
    Ibase    = baseMVA*1e3./baseVoltages;
    Ibus     = Ibase.*Ibus_pu;

    Sbus_MVA  = Vlg.*conj(Ibus)/1e6;
    index = caseObject.bus(:,BID);
    

    Conn = connectionMatrix(index,caseObject.lineBranch(:,FBUS:TBUS),caseObject.trafoBranch(:,FBUS:TBUS),nnodes);

    trafoLink = zeros(2*ntrafo,2);
    for n=1:ntrafo
        trafoLink(2*n-1,:) = [caseObject.trafoBranch(n,FBUS),-n];
        trafoLink(2*n  ,:) = [-n,caseObject.trafoBranch(n,TBUS)];
    end
    links = [caseObject.lineBranch(:,FBUS:TBUS);trafoLink];
    numbr = size(links,1);
    Ibr_base = zeros(3*numbr,1);
    for n=1:size(links,1)
        if(links(n,1)~=-1)
            Ibr_base(3*n-2:3*n) = baseMVA*1e3./caseObject.bus(caseObject.bus(:,BID)==links(n,1),BASEKV);
        else
            Ibr_base(3*n-2:3*n) = baseMVA*1e3./caseObject.bus(caseObject.bus(:,BID)==links(n,2),BASEKV);
        end
    end
    Vbranch_pu = Conn * caseObject.Vlg_pu;
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

%% Bus quantities
outputObject.busInfo = zeros(nnodes,22);
outputObject.busInfo(:,1)     = index;
outputObject.busInfo(:,2:4)   = threePhaseArray(abs(caseObject.Vlg_pu));
outputObject.busInfo(:,5:7)   = threePhaseArray(angle(caseObject.Vlg_pu)*180/pi);
outputObject.busInfo(:,8:10)  = threePhaseArray(abs(Vlg));
outputObject.busInfo(:,11:13) = threePhaseArray(abs(Vll));
outputObject.busInfo(:,14:16) = threePhaseArray(angle(Vll)*180/pi);
outputObject.busInfo(:,17:19) = threePhaseArray(real(Sbus_MVA));
outputObject.busInfo(:,20:22) = threePhaseArray(imag(Sbus_MVA));
end % End of function
