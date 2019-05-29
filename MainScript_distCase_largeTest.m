clear variables;
BID = 1;
oldBaseMVA = 0.8/3;
caseObject = distCase_testBuildBlock_old;

corrFactor = caseObject.baseMVA/oldBaseMVA;

caseObject.lineBranch(:,3:20) = corrFactor*caseObject.lineBranch(:,3:20);

busAnnex = zeros(905,9);
for n=1:(4*905)
    busAnnex(n,:) = [n+906,1,1.0000000000,1.0000000000,1.0000000000,-30.0000000000,-150.0000000000,90.0000000000,0.416/sqrt(3)];
end
caseObject.bus = [caseObject.bus;busAnnex];

yload_new = zeros(4*size(caseObject.yload,1),size(caseObject.yload,2));
for n=1:4
    yload_old = caseObject.yload;
    yload_old(:,BID) = yload_old(:,BID)+905*n;
    range = ((n-1)*size(yload_old,1)+1):(n*size(yload_old,1));
    yload_new(range,:) = yload_old;
end
caseObject.yload = [caseObject.yload;yload_new];
for n=1:size(caseObject.yload,1)
    activeLoad   = 20*sum(caseObject.yload(n,2:4));
    reactiveLoad = 20*sum(caseObject.yload(n,5:7));
    caseObject.yload(n,2:4) = 0;
    caseObject.yload(n,5:7) = 0;
    switch randi([1,3])
       case 1
           caseObject.yload(n,2) = activeLoad;
           caseObject.yload(n,5) = reactiveLoad;
       case 2
           caseObject.yload(n,3) = activeLoad;
           caseObject.yload(n,6) = reactiveLoad;
       case 3
           caseObject.yload(n,4) = activeLoad;
           caseObject.yload(n,7) = reactiveLoad;
    end
end

lineBranch_new = zeros(4*size(caseObject.lineBranch,1),size(caseObject.lineBranch,2));
for n=1:4
    lineBranch_old = caseObject.lineBranch;
    for m=1:size(lineBranch_old,1)
        if(lineBranch_old(m,1)~=1)
            lineBranch_old(m,1) = lineBranch_old(m,1)+905*n;
            lineBranch_old(m,2) = lineBranch_old(m,2)+905*n;
        else
            lineBranch_old(m,2) = lineBranch_old(m,2)+905*n;
        end
    end
    range = ((n-1)*size(lineBranch_old,1)+1):(n*size(lineBranch_old,1));
    lineBranch_new(range,:) = lineBranch_old;
end
caseObject.lineBranch = [caseObject.lineBranch;lineBranch_new];

savedistcase('distCase_testBuildBlock',{'Distribution test feeder, large case, unbalanced conditions for testing',...
    'Please see distributionCaseFormat.m for details on the case file format'},caseObject);
% savedistcase('distCase_largeSystem',{'Distribution test feeder, large case, unbalanced conditions for testing',...
%     'Please see distributionCaseFormat.m for details on the case file format'},caseObject);

Gcase = powerCaseGraph(caseObject);
neighbors(Gcase,2)
plot(Gcase);
%plot(Gcase,'NodeLabel',caseObject.bus(:,BID));

nnodes = size(caseObject.bus,1);
ntrafo = size(caseObject.trafoBranch,1);
[Vlg_pu,~,~,Ybus, Ypr] = unbalancedPowerFlowSolver(caseObject);
indexes = caseObject.bus(:,1);
Conn = connectionMatrix(indexes,caseObject.lineBranch(:,1:2),caseObject.trafoBranch(:,1:2),nnodes);

baseVoltages = tripleVector(caseObject.bus(:,9));
Vlg=Vlg_pu.*1e3.*baseVoltages;
Vll=phaseGround2phasePhase(Vlg);

Ibus_pu=Ybus*Vlg_pu;
Ibase=caseObject.baseMVA*1e3./baseVoltages;
Ibus=Ibase.*Ibus_pu;

Sbus_pu=Vlg_pu.*conj(Ibus_pu);
Sbus_MVA=caseObject.baseMVA*Sbus_pu;


trafoLink = zeros(2*ntrafo,2);
for n=1:ntrafo
    trafoLink(2*n-1,:) = [caseObject.trafoBranch(n,1),0];
    trafoLink(2*n  ,:) = [0,caseObject.trafoBranch(n,2)];
end
links = [caseObject.lineBranch(:,1:2);trafoLink];

Vbranch_pu = Conn * Vlg_pu;
Ibranch_pu = Ypr*Vbranch_pu;
Ibr_base = ones(size(Ibranch_pu));
Ibr_base(1:end-6)     = Ibase(7)*Ibr_base(1:end-6);
Ibr_base(end-5:end-3) = Ibase(1)*Ibr_base(end-5:end-3);
Ibr_base(end-2:end)   = Ibase(7)*Ibr_base(end-2:end);

Ibranch = Ibranch_pu .*Ibr_base;