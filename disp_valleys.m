disp('Format: assymetry, (Z_L,A_L) (Z_H,A_H)');
for i=1:4
    disp(['Valleys for ','Z=',num2str(nuclei(i).Z),' A=',num2str(nuclei(i).A)])
    etaA=nuclei(i).main_valleys_etaA;
    etaZ=nuclei(i).main_valleys_etaZ;
    for j=1:length(etaA)
        indexes=find(nuclei(i).PES(:,1)==16.1);
        [temp_min eta_index]=min(abs(nuclei(i).PES(indexes,2)-etaA(j)));
        eta_index=indexes(1)+eta_index-1;
        etaZ=nuclei(i).PES(eta_index,3);
        nuclei(i).main_valleys_etaZ(j)=etaZ;
        A_L=round(nuclei(i).A*(1-etaA(j))/2);
        A_H=nuclei(i).A-A_L;
        Z_L=round(nuclei(i).Z*(1-etaZ)/2);
        Z_H=nuclei(i).Z-Z_L;
        disp([num2str(etaA(j)),' (',num2str(Z_L),',',num2str(A_L),...
            ')', ' (',num2str(Z_H),',', num2str(A_H),')']);
        %min(etaA-etaA(j))
        %disp
    end
end
    