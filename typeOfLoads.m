yload = caseObject.yload;
threePhaseNum = 0;
twoPhaseNum = 0;
singlePhaseNum = 0;
zeroPhaseNum = 0;

for n=1:size(yload,1)
  if(yload(n,2) > 0.0000001 && yload(n,3) > 0.0000001 && yload(n,4) > 0.0000001)
    threePhaseNum = threePhaseNum+1;
  end
  if((yload(n,2) > 0.0000001 && yload(n,3) > 0.0000001 && yload(n,4)<= 0.0000001) ||...
     (yload(n,2) > 0.0000001 && yload(n,3)<= 0.0000001 && yload(n,4) > 0.0000001) ||...
     (yload(n,2)<= 0.0000001 && yload(n,3) > 0.0000001 && yload(n,4) > 0.0000001))
    twoPhaseNum = twoPhaseNum+1;
  end
  if((yload(n,2) > 0.0000001 && yload(n,3)<= 0.0000001 && yload(n,4)<= 0.0000001) ||...
     (yload(n,2)<= 0.0000001 && yload(n,3) > 0.0000001 && yload(n,4)<= 0.0000001) ||...
     (yload(n,2)<= 0.0000001 && yload(n,3)<= 0.0000001 && yload(n,4) > 0.0000001))
    singlePhaseNum = singlePhaseNum+1;
  end
  if(yload(n,2)<= 0.0000001 && yload(n,3)<= 0.0000001 && yload(n,4)<= 0.0000001)
    zeroPhaseNum = zeroPhaseNum+1;
  end
end

index3PH = zeros(threePhaseNum,1);
index2PH = zeros(twoPhaseNum,1);
index1PH = zeros(singlePhaseNum,1);
n1PH = 0;
n2PH = 0;
n3PH = 0;

for n=1:size(yload,1)
  if(yload(n,2) > 0.0000001 && yload(n,3) > 0.0000001 && yload(n,4) > 0.0000001)
    n3PH = n3PH+1;
    index3PH(n3PH) = n;
  end
  if((yload(n,2) > 0.0000001 && yload(n,3) > 0.0000001 && yload(n,4)<= 0.0000001) ||...
     (yload(n,2) > 0.0000001 && yload(n,3)<= 0.0000001 && yload(n,4) > 0.0000001) ||...
     (yload(n,2)<= 0.0000001 && yload(n,3) > 0.0000001 && yload(n,4) > 0.0000001))    
    n2PH = n2PH+1;
    index2PH(n2PH) = n;
  end
  if((yload(n,2) > 0.0000001 && yload(n,3)<= 0.0000001 && yload(n,4)<= 0.0000001) ||...
     (yload(n,2)<= 0.0000001 && yload(n,3) > 0.0000001 && yload(n,4)<= 0.0000001) ||...
     (yload(n,2)<= 0.0000001 && yload(n,3)<= 0.0000001 && yload(n,4) > 0.0000001))
    n1PH = n1PH+1;
    index1PH(n1PH) = n;
  end
end
