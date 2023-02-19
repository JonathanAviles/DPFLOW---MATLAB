function [Ybus, Ypr] = YMaker(nnodes, yload, dload, lineBranch, trafoBranch, baseMVA)
    
    %% Labels
    [BID, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ...
        ~, ~, YPD2A, YPD2B, YPD2C, YQD2A, YQD2B, YQD2C, YLSTAT]= loadIndexer;
    [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ...
        ~, ~, ~, DPD2AB, DPD2BC, DPD2CA, DQD2AB, DQD2BC, DQD2CA, DLSTAT] = loadIndexer;
    [FBUS, TBUS, R11, R12, R13, R22, R23, R33, X11, X12, X13, X22, X23, X33, ...
        B11, B12, B13, B22, B23, B33, LBSTAT] = lineBranchIndexer;
    [~, ~, RPU, XPU, TCONN, PTAP, STAP, TSTAT] = trafoBranchIndexer;

    %%  Memory allocation
    nyload  = size(yload,1);
    ndload  = size(dload,1);
    nline   = size(lineBranch,1);
    ntrafo  = size(trafoBranch,1);

    Ybus_rows = zeros(36*(nline+ntrafo)+3*nyload+9*ndload,1);
    Ybus_cols = zeros(36*(nline+ntrafo)+3*nyload+9*ndload,1);
    Ybus_vals = zeros(36*(nline+ntrafo)+3*nyload+9*ndload,1);
    
    Ypr1_rows = zeros(9*nline,1);
    Ypr1_cols = zeros(9*nline,1);
    Ypr1_vals = zeros(9*nline,1);
    
    Ypr4_rows = zeros(36*ntrafo,1);
    Ypr4_cols = zeros(36*ntrafo,1);
    Ypr4_vals = zeros(36*ntrafo,1);
    
    %%  wye constant impedance loads
    for n = 1:nyload
        node1 = yload(n,BID);    
        Ybus_rows(3*n-2) = 3*node1-2;   Ybus_cols(3*n-2) = 3*node1-2;
        Ybus_rows(3*n-1) = 3*node1-1;   Ybus_cols(3*n-1) = 3*node1-1;
        Ybus_rows(3*n  ) = 3*node1;     Ybus_cols(3*n  ) = 3*node1;
        
        if(yload(n,YLSTAT)~=0)
            Ybus_vals(3*n-2) = (yload(n,YPD2A)-1i*yload(n,YQD2A))/baseMVA;
            Ybus_vals(3*n-1) = (yload(n,YPD2B)-1i*yload(n,YQD2B))/baseMVA;
            Ybus_vals(3*n  ) = (yload(n,YPD2C)-1i*yload(n,YQD2C))/baseMVA;
        end
    end
    
    offset = 3*nyload;
    
    %%  Delta constant impedance loads
    for n = 1:ndload
        node1 = dload(n,BID);
        Ybus_rows(9*n-8+offset) = 3*node1-2;   Ybus_cols(9*n-8+offset) = 3*node1-2;   
        Ybus_rows(9*n-7+offset) = 3*node1-1;   Ybus_cols(9*n-7+offset) = 3*node1-1;   
        Ybus_rows(9*n-6+offset) = 3*node1;     Ybus_cols(9*n-6+offset) = 3*node1;
        Ybus_rows(9*n-5+offset) = 3*node1-2;   Ybus_cols(9*n-5+offset) = 3*node1-1;
        Ybus_rows(9*n-4+offset) = 3*node1-1;   Ybus_cols(9*n-4+offset) = 3*node1-2;
        Ybus_rows(9*n-3+offset) = 3*node1-1;   Ybus_cols(9*n-3+offset) = 3*node1;
        Ybus_rows(9*n-2+offset) = 3*node1;     Ybus_cols(9*n-2+offset) = 3*node1-1;
        Ybus_rows(9*n-1+offset) = 3*node1-2;   Ybus_cols(9*n-1+offset) = 3*node1;
        Ybus_rows(9*n  +offset) = 3*node1;     Ybus_cols(9*n  +offset) = 3*node1-2;
        
        if(dload(n,DLSTAT)~=0)
            Ybus_vals(9*n-8+offset) = + (dload(n,DPD2AB)-1i*dload(n,DQD2AB))/(3*baseMVA) + (dload(n,DPD2CA)-1i*dload(n,DQD2CA))/(3*baseMVA);
            Ybus_vals(9*n-7+offset) = + (dload(n,DPD2BC)-1i*dload(n,DQD2BC))/(3*baseMVA) + (dload(n,DPD2AB)-1i*dload(n,DQD2AB))/(3*baseMVA);
            Ybus_vals(9*n-6+offset) = + (dload(n,DPD2CA)-1i*dload(n,DQD2CA))/(3*baseMVA) + (dload(n,DPD2BC)-1i*dload(n,DQD2BC))/(3*baseMVA);
            Ybus_vals(9*n-5+offset) = - (dload(n,DPD2AB)-1i*dload(n,DQD2AB))/(3*baseMVA);
            Ybus_vals(9*n-4+offset) = - (dload(n,DPD2AB)-1i*dload(n,DQD2AB))/(3*baseMVA);
            Ybus_vals(9*n-3+offset) = - (dload(n,DPD2BC)-1i*dload(n,DQD2BC))/(3*baseMVA);
            Ybus_vals(9*n-2+offset) = - (dload(n,DPD2BC)-1i*dload(n,DQD2BC))/(3*baseMVA);
            Ybus_vals(9*n-1+offset) = - (dload(n,DPD2CA)-1i*dload(n,DQD2CA))/(3*baseMVA);
            Ybus_vals(9*n  +offset) = - (dload(n,DPD2CA)-1i*dload(n,DQD2CA))/(3*baseMVA);
        end
    end
    
    offset = 3*nyload + 9*ndload;

    %%  Line branches
    for n = 1:nline
        % One distribution line
        dline = lineBranch(n,:);
        
        Ypr1_rows(9*n-8:9*n) = [(3*n-2)*[1;1;1];(3*n-1)*[1;1;1];3*n*[1;1;1]];
        Ypr1_cols(9*n-8:9*n) = [(3*n-2:3*n),(3*n-2:3*n),(3*n-2:3*n)].';
        
        node1 = dline(FBUS); node2 = dline(TBUS);
        Ybus_rows((36*n-35+offset):(36*n-27+offset)) = [(3*node1-2)*[1;1;1];(3*node1-1)*[1;1;1];3*node1*[1;1;1]];
        Ybus_cols((36*n-35+offset):(36*n-27+offset)) = [(3*node1-2:3*node1),(3*node1-2:3*node1),(3*node1-2:3*node1)].';
        
        Ybus_rows((36*n-26+offset):(36*n-18+offset)) = [(3*node2-2)*[1;1;1];(3*node2-1)*[1;1;1];3*node2*[1;1;1]];
        Ybus_cols((36*n-26+offset):(36*n-18+offset)) = [(3*node2-2:3*node2),(3*node2-2:3*node2),(3*node2-2:3*node2)].';
        
        Ybus_rows((36*n-17+offset):(36*n-9+offset))  = [(3*node1-2)*[1;1;1];(3*node1-1)*[1;1;1];3*node1*[1;1;1]];
        Ybus_cols((36*n-17+offset):(36*n-9+offset))  = [(3*node2-2:3*node2),(3*node2-2:3*node2),(3*node2-2:3*node2)].';
        
        Ybus_rows((36*n-8+offset) :(36*n+offset))    = [(3*node2-2)*[1;1;1];(3*node2-1)*[1;1;1];3*node2*[1;1;1]];
        Ybus_cols((36*n-8+offset) :(36*n+offset))    = [(3*node1-2:3*node1),(3*node1-2:3*node1),(3*node1-2:3*node1)].';
        
        if(dline(LBSTAT)~=0)
            % Primitive impedance matrix from data
            Zline = [dline(R11),dline(R12),dline(R13);dline(R12),dline(R22),dline(R23);dline(R13),dline(R23),dline(R33)]...
                + 1i*[dline(X11),dline(X12),dline(X13);dline(X12),dline(X22),dline(X23);dline(X13),dline(X23),dline(X33)];

            % If the branch is composed by less than 3 phases, the correspondent
            % only-zero rows and columns need to be removed in order to compute
            % the correspondent primitive admittance matrix
            nonConPhases = find(any(Zline,2)==0);
            Zline = deleteRowsAndCols(Zline,nonConPhases); 

            % Primitive admittance matrix calculation
            Yline = eye(3-length(nonConPhases))/Zline;

            % Only-zero rows and columns are reinserted into the primitive
            % admittance matrix
            Yline = insertZerosIntoMatrix(Yline,nonConPhases);

            % Primitive susceptance matrix is computed from data
            Bline = 1i*[dline(B11),dline(B12),dline(B13);dline(B12),dline(B22),dline(B23);dline(B13),dline(B23),dline(B33)];

            % Contribution from the distribution line is added to the Ypr
            % matrix of the network in the correspondent cells
            Ypr1_vals(9*n-8:9*n) = Yline(:);
            
            % Contribution from the distribution line is added to the Ybus
            % matrix of the network in the correspondent cells
            Ybus_vals((36*n-35+offset):(36*n-27+offset)) = Yline(:) + Bline(:)/2;
            Ybus_vals((36*n-26+offset):(36*n-18+offset)) = Yline(:) + Bline(:)/2;
            Ybus_vals((36*n-17+offset):(36*n-9+offset))  = - Yline(:);
            Ybus_vals((36*n-8+offset) :(36*n+offset))    = - Yline(:);
    
        end
    end

    offset  = 3*nyload + 9*ndload + 36*nline;
        
    %%  Transformer branches
    for n = 1:ntrafo
        Ypr4_rows(36*n-35:36*n-27) = [(6*n-5)*[1;1;1];(6*n-4)*[1;1;1];(6*n-3)*[1;1;1]];
        Ypr4_cols(36*n-35:36*n-27) = [(6*n-5:6*n-3),(6*n-5:6*n-3),(6*n-5:6*n-3)].';
        
        Ypr4_rows(36*n-26:36*n-18) = [(6*n-5)*[1;1;1];(6*n-4)*[1;1;1];(6*n-3)*[1;1;1]];
        Ypr4_cols(36*n-26:36*n-18) = [(6*n-2:6*n),(6*n-2:6*n),(6*n-2:6*n)].';
        
        Ypr4_rows(36*n-17:36*n-9)  = [(6*n-2)*[1;1;1];(6*n-1)*[1;1;1];6*n*[1;1;1]];
        Ypr4_cols(36*n-17:36*n-9)  = [(6*n-5:6*n-3),(6*n-5:6*n-3),(6*n-5:6*n-3)].';
       
        Ypr4_rows(36*n-8 :36*n)    = [(6*n-2)*[1;1;1];(6*n-1)*[1;1;1];6*n*[1;1;1]];
        Ypr4_cols(36*n-8 :36*n)    = [(6*n-2:6*n),(6*n-2:6*n),(6*n-2:6*n)].';
        
        node1 = trafoBranch(n,FBUS); node2 = trafoBranch(n,TBUS);
        
        Ybus_rows((36*n-35+offset):(36*n-27+offset)) = [(3*node1-2)*[1;1;1];(3*node1-1)*[1;1;1];3*node1*[1;1;1]];
        Ybus_cols((36*n-35+offset):(36*n-27+offset)) = [(3*node1-2:3*node1),(3*node1-2:3*node1),(3*node1-2:3*node1)].';
        
        Ybus_rows((36*n-26+offset):(36*n-18+offset)) = [(3*node2-2)*[1;1;1];(3*node2-1)*[1;1;1];3*node2*[1;1;1]];
        Ybus_cols((36*n-26+offset):(36*n-18+offset)) = [(3*node2-2:3*node2),(3*node2-2:3*node2),(3*node2-2:3*node2)].';
        
        Ybus_rows((36*n-17+offset):(36*n-9+offset))  = [(3*node1-2)*[1;1;1];(3*node1-1)*[1;1;1];3*node1*[1;1;1]];
        Ybus_cols((36*n-17+offset):(36*n-9+offset))  = [(3*node2-2:3*node2),(3*node2-2:3*node2),(3*node2-2:3*node2)].';
        
        Ybus_rows((36*n-8+offset) :(36*n+offset))    = [(3*node2-2)*[1;1;1];(3*node2-1)*[1;1;1];3*node2*[1;1;1]];
        Ybus_cols((36*n-8+offset) :(36*n+offset))    = [(3*node1-2:3*node1),(3*node1-2:3*node1),(3*node1-2:3*node1)].';
        
        if(trafoBranch(n,TSTAT)~=0)
            YI   = eye(3);
            YII  = [2,-1,-1;-1,2,-1;-1,-1,2]/3;
            YIII = [-1,1,0;0,-1,1;1,0,-1].'/sqrt(3);  %% Transpose is used because of the column oriented indexing of MATLAB
            ytr_pu = 1/(trafoBranch(n,RPU)+1i*trafoBranch(n,XPU));
            
            switch trafoBranch(n,TCONN)
                case 1 %YNyn0
                    Ypp = ytr_pu*YI;
                    Yps = -Ypp;
                    Ysp = -Ypp;
                    Yss = Ypp;
                case 4 %Dd0
                    Ypp = ytr_pu*YII;
                    Yps = -Ypp;
                    Ysp = -Ypp;
                    Yss = Ypp;
                case 5 %YNd1
                    Ypp = ytr_pu*YI;
                    Yps = ytr_pu*YIII;
                    Ysp = Yps.';
                    Yss = ytr_pu*YII;
                case 7 %Dyn1
                    Ypp = ytr_pu*YII;
                    Yps = ytr_pu*YIII;
                    Ysp = Yps.';
                    Yss = ytr_pu*YI;
                otherwise
                    % to be filled
            end
            
            Ypr4_vals(36*n-35:36*n-27) = Ypp/(trafoBranch(n,PTAP)^2);
            Ypr4_vals(36*n-26:36*n-18) = -Yps/(trafoBranch(n,PTAP)*trafoBranch(n,STAP));
            Ypr4_vals(36*n-17:36*n-9 ) = -Ysp/(trafoBranch(n,PTAP)*trafoBranch(n,STAP));
            Ypr4_vals(36*n-8 :36*n   ) = Yss/(trafoBranch(n,STAP)^2);
            
            Ybus_vals((36*n-35+offset):(36*n-27+offset)) = Ypp/(trafoBranch(n,PTAP)^2);
            Ybus_vals((36*n-26+offset):(36*n-18+offset)) = Yss/(trafoBranch(n,STAP)^2);
            Ybus_vals((36*n-17+offset):(36*n-9+offset))  = Yps/(trafoBranch(n,PTAP)*trafoBranch(n,STAP));
            Ybus_vals((36*n-8+offset) :(36*n+offset))    = Ysp/(trafoBranch(n,PTAP)*trafoBranch(n,STAP));
        end
    end
    
    Ybus    = sparse(Ybus_rows,Ybus_cols,Ybus_vals,3*nnodes,3*nnodes);
   %% sparse is used to reduce the momery used by the MATLAB so you can inverse it by full(Ybus) 
    Ypr1    = sparse(Ypr1_rows,Ypr1_cols,Ypr1_vals,3*nline,3*nline);
    Ypr2    = sparse(3*nline,6*ntrafo);
    Ypr3    = sparse(6*ntrafo,3*nline);
    Ypr4    = sparse(Ypr4_rows,Ypr4_cols,Ypr4_vals,6*ntrafo,6*ntrafo);
    Ypr = [Ypr1,Ypr2;Ypr3,Ypr4];
        
end
