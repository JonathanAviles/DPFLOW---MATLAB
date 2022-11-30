function X=threePhaseShift(X0,k)
    X=zeros(size(X0));
    for n=1:(size(X0,1)/3)
        X(3*n-2:3*n)=circshift(X0(3*n-2:3*n),[k,0]);
    end
end