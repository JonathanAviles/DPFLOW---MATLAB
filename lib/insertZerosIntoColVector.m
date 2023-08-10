function X=insertZerosIntoColVector(X0,index)
    index=sort(index);
    N=length(index);
    for n=1:N
        a=index(n);
        X0 = [X0(1:(a-1));0;X0(a:end)];
    end
    X=X0;
end