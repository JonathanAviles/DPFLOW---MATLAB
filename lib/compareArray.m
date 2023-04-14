function boolean = compareArray(array1,array2)
    boolean =0;
    if(abs((array1(:)-array2(:))) < 1e-5)
       boolean = 1; 
    end
end