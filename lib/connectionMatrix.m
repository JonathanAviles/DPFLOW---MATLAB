function C = connectionMatrix(listNodes,lineLink,trafoLink,N)

    ext2intID = zeros(N,1);
    ext2intID(listNodes)=(1:N)';
    lineLink(:,1) = ext2intID(lineLink(:,1));
    lineLink(:,2) = ext2intID(lineLink(:,2));
    trafoLink(:,1) = ext2intID(trafoLink(:,1));
    trafoLink(:,2) = ext2intID(trafoLink(:,2));   

    %% Initialization
    numLine = size(lineLink,1);
    numTrafo = size(trafoLink,1);
    C1_rows = zeros(6*numLine,1);
    C1_cols = zeros(6*numLine,1);
    C1_vals = zeros(6*numLine,1);
    C2_rows = zeros(6*numTrafo,1);
    C2_cols = zeros(6*numTrafo,1);
    C2_vals = zeros(6*numTrafo,1);
    
    %% Algorithm
    % A column will correspond to each edge. '1' will be added to the element 
    % correspondent to the origin node and '-1' to the element correspondent
    % to the destiny node
    for n = 1:numLine
        n1 = lineLink(n,1); n2 = lineLink(n,2);
        C1_rows(6*n-5:6*n-3) = (3*n-2:3*n).';
        C1_cols(6*n-5:6*n-3) = (3*n1-2:3*n1).';
        C1_vals(6*n-5:6*n-3) = +1;
        C1_rows(6*n-2:6*n  ) = (3*n-2:3*n).';
        C1_cols(6*n-2:6*n  ) = (3*n2-2:3*n2).';
        C1_vals(6*n-2:6*n  ) = -1;
    end
    for n = 1:numTrafo
        n1 = trafoLink(n,1); n2 = trafoLink(n,2);
        C2_rows(6*n-5:6*n-3) = (6*n-5:6*n-3).';
        C2_cols(6*n-5:6*n-3) = (3*n1-2:3*n1).';
        C2_vals(6*n-5:6*n-3) = +1;
        C2_rows(6*n-2:6*n  ) = (6*n-2:6*n  ).';
        C2_cols(6*n-2:6*n  ) = (3*n2-2:3*n2).';
        C2_vals(6*n-2:6*n  ) = -1;
    end
    C1 = sparse(C1_rows, C1_cols, C1_vals, 3*(numLine), 3*N);
    C2 = sparse(C2_rows, C2_cols, C2_vals, 6*(numTrafo), 3*N);
    C = [C1;C2];
end
