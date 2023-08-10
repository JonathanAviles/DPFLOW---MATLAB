function X=insertZerosIntoMatrix(X0,index)
    index=sort(index);
    N=length(index);
    X=X0;
    for n=1:N
        a=index(n);
        DX=length(X);
        X = [X(:,1:(a-1)),zeros(DX,1),X(:,a:end)];
        X = [X(1:(a-1),:);zeros(1,DX+1);X(a:end,:)];
    end
end