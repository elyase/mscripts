%change here the variable to export, its format and the output filename
exportVar=less3_minimum;
fmt='%1.0f %1.0f\n'; %1.2f %1.2f\n';
fileName='less3.txt';

fid = fopen(fileName, 'wt');
for i=1:length(exportVar(:,1))
 fprintf(fid,fmt,exportVar(i,1),exportVar(i,2));
end
fclose(fid);