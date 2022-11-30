function Vll=phaseGround2phasePhase(Vlg)

    N=length(Vlg);
    Vlg=reshape(Vlg,3,N/3);
    Vll=zeros(N,1);
    A=[1,-1,0;0,1,-1;-1,0,1];
    
    for n=1:N/3
        aux=A*[Vlg(1,n);Vlg(2,n);Vlg(3,n)];
        Vll(3*n-2)=aux(1);
        Vll(3*n-1)=aux(2);
        Vll(3*n)=aux(3);
    end
end
