function X=deleteRowsAndCols(X0,index)
    if(any(size(X0)==1))
        X0(index)=[];
    else
        X0(index,:)=[];
        X0(:,index)=[];
    end
    X=X0;    
end