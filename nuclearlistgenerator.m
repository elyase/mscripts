fid = fopen('nuclearlist.test', 'wt');
for Z=25:49
    for N=Z-10:Z+30*(1+0.5*(Z-25)/(49-25))
        %not_in_table=nnz((table(:,1)==(Z)) & (table(:,2)==(Z+N)))==0;
        %if not_in_table 
            fprintf(fid,'%1.0f %1.0f\n',Z,Z+N);
    end
end
fclose(fid);