function G = powerCaseGraph(caseObject)

    nnodes = size(caseObject.bus,1);
    nline  = size(caseObject.lineBranch,1);
    ntrafo = size(caseObject.trafoBranch,1);
    busID  = caseObject.bus(:,1);
    
    %% Indexing
    ext2intID = zeros(max(busID),1);
    ext2intID(caseObject.bus(:,1))=(1:nnodes)';
    caseObject.bus(:,1) = (1:nnodes)';
    caseObject.gen(:,1) = ext2intID(caseObject.gen(:,1));
    if (nline~=0)
        caseObject.lineBranch(:,1) = ext2intID(caseObject.lineBranch(:,1));
        caseObject.lineBranch(:,2) = ext2intID(caseObject.lineBranch(:,2));
    end
    if (ntrafo~=0)
        caseObject.trafoBranch(:,1) = ext2intID(caseObject.trafoBranch(:,1));
        caseObject.trafoBranch(:,2) = ext2intID(caseObject.trafoBranch(:,2));
    end
    
    %% Initialization
    linkList = [[caseObject.lineBranch(:,1);caseObject.trafoBranch(:,1)],...
                [caseObject.lineBranch(:,2);caseObject.trafoBranch(:,2)]];
    
    for n=1:(nline+ntrafo)
        link = linkList(n,:);
        A_rows(2*n-1:2*n) = [link(1);link(2)];
        A_cols(2*n-1:2*n) = [link(2);link(1)];
        A_vals(2*n-1:2*n) = 1;
    end
    A = sparse(A_rows,A_cols,A_vals,nnodes,nnodes);          %A-matrix allocation
    G = graph(A,cellstr(num2str(busID)));
    
end