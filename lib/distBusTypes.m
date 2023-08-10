function [ref, pv, pq] = distBusTypes(bus)
    
    %% Labels
    [PQ, PV, REF, NONE, BID, TYPE, VMA, VMB, VMC, VAA, VAB, VAC, BASEKV] = busIndexer;

    %% form index lists for slack, PV, and PQ buses
    ref = find(bus(:, TYPE) == REF);   %% reference bus index
    pv  = find(bus(:, TYPE) == PV );   %% PV bus indices
    pq  = find(bus(:, TYPE) == PQ );   %% PQ bus indices
end
