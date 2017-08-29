function saveDistCaseResults(outputObject)

    %%  Open file
    [fd, ~] = fopen('distCaseResults.m','wt');     % print it to an M-file
    
    if isfield(outputObject,'busInfo') 
        busInfo = outputObject.busInfo;
        busInfo(:,2:7) = busInfo(:,[2,5,3,6,4,7]);
        
        fprintf(fd,'%% Bus information\n');
        fprintf(fd,'%%{\n');
        fprintf(fd,'Bus\tVa(pu)\t  <Va  \tVb(pu)\t   <Vb   \tVc(pu)\t  <Vc  \n');
        fprintf(fd,'%%}\n');
        fprintf(fd,'busInfo = [\n');
        fprintf(fd,'%d\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\n',busInfo(:,1:7).');
        fprintf(fd,'];\n\n');
    end
    
    if isfield(outputObject,'branchInfo')
        brInfo = outputObject.branchInfo;
        brInfo(:,3:8) = brInfo(:,[3,6,4,7,5,8]);
    
        fprintf(fd,'%% Branch information\n');
        fprintf(fd,'%%{\n');
        fprintf(fd,'From To\t|IA|\t<IA\t|IB|\t<IB\t|IC|\t<IC\t|PA(kW)\tPB(kW)\tPC(kW)\tQA(kVAR)\tQB(kVAR)\tQC(kVAR)\n');
        fprintf(fd,'%%}\n');
        fprintf(fd,'branchInfo = [\n');
        fprintf(fd,'%d\t%d\t%4.4f\t%4.4f\t%4.4f\t%4.4f\t%4.4f\t%4.4f\t%4.4f\t%4.4f\t%4.4f\t%4.4f\t%4.4f\t%4.4f\n',brInfo(:,1:14).');
        fprintf(fd,'];\n\n');
    end
    
    fclose(fd);
end



