function [Swye_pu, Sdelta_pu, Iwye_pu, Idelta_pu]= Sbus_creation(baseMVA, gen, yload, dload ,nnodes)
    %MAKESwye   Builds the vector of complex bus power injections.

    %% Labels
    [PQ, PV, REF, NONE, BID, TYPE, VMA, VMB, VMC, VAA, VAB, VAC, BASEKV] = busIndexer;
    [~, PGA, PGB, PGC, QGA, QGB, QGC, GSTAT] = genIndexer;
    [~, YPD0A, YPD0B, YPD0C, YQD0A, YQD0B, YQD0C, YPD1A, YPD1B, YPD1C, YQD1A, ...
        YQD1B, YQD1C, YPD2A, YPD2B, YPD2C, YQD2A, YQD2B, YQD2C, YLSTAT]= loadIndexer;
    [~, DPD0AB, DPD0BC, DPD0CA, DQD0AB, DQD0BC, DQD0CA, DPD1AB, DPD1BC, DPD1CA, ...
        DQD1AB, DQD1BC, DQD1CA, DPD2AB, DPD2BC, DPD2CA, DQD2AB, DQD2BC, DQD2CA, DLSTAT] = loadIndexer;
    [FBUS, TBUS, R11, R12, R13, R22, R23, R33, X11, X12, X13, X22, X23, X33, ...
        B11, B12, B13, B22, B23, B33, LBSTAT] = lineBranchIndexer;
    [~, ~, RPU, XPU, TCONN, PTAP, STAP, TSTAT] = trafoBranchIndexer;
    
    %% 
    ngen   = size(gen,1);
    nyload = size(yload,1);
    ndload = size(dload,1);
    Swye = zeros(3*nnodes,1);
    Sdelta = zeros(3*nnodes,1);
    Iwye = zeros(3*nnodes,1);
    Idelta = zeros(3*nnodes,1);
    for n=1:ngen
        if(gen(n,GSTAT)~=0)
            nodeID = gen(n,BID);
            Snode = gen(n,[PGA, PGB, PGC]) + 1i*gen(n,[QGA, QGB, QGC]);
            Swye(3*nodeID-2:3*nodeID) = Swye(3*nodeID-2:3*nodeID) + reshape(Snode.',[],1);
        end
    end
    for n=1:nyload
        if(yload(n,YLSTAT)~=0)
            nodeID = yload(n,BID);
            Snode = yload(n,[YPD0A, YPD0B, YPD0C]) + 1i*yload(n,[YQD0A, YQD0B, YQD0C]);
            Swye(3*nodeID-2:3*nodeID) = Swye(3*nodeID-2:3*nodeID) - reshape(Snode.',[],1);
            Inode = yload(n,[YPD1A, YPD1B, YPD1C]) + 1i*yload(n,[YQD1A, YQD1B, YQD1C]);
            Iwye(3*nodeID-2:3*nodeID) = Iwye(3*nodeID-2:3*nodeID) - reshape(Inode.',[],1);
        end
    end
    for n=1:ndload
        if(dload(n,DLSTAT)~=0)
            nodeID = dload(n,BID);
            Snode = dload(n,[DPD0AB, DPD0BC, DPD0CA]) + 1i*dload(n,[DQD0AB, DQD0BC, DQD0CA]);
            Sdelta(3*nodeID-2:3*nodeID) = Sdelta(3*nodeID-2:3*nodeID) - reshape(Snode.',[],1);
            Inode = dload(n,[DPD1AB, DPD1BC, DPD1CA]) + 1i*dload(n,[DQD1AB, DQD1BC, DQD1CA]);
            Idelta(3*nodeID-2:3*nodeID) = Idelta(3*nodeID-2:3*nodeID) - reshape(Inode.',[],1);
        end
    end
    Swye_pu   = Swye/baseMVA;
    Sdelta_pu = Sdelta/baseMVA;
    Iwye_pu   = Iwye/baseMVA;
    Idelta_pu = Idelta/baseMVA;
end
