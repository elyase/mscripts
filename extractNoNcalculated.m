%directory='/Volumes/FIAS/wideGridCalculations/data/';
directory='localminima/';
ggFiles = dir([directory '*.grossgrid.mat']);
%outputDir='localminima';
%mkdir(outputDir)
    list=[];
for k = 1:length(ggFiles)
    filename = ggFiles(k).name;
    %outputFilename=[outputDir '/' filename '.mat'];
%    disp(['Analizing ' filename])
%     if exist(filename,'file')==2, 
%         disp('Found.'); 
%         continue;
%     end

    manyminsm=importdata([directory filename]);
    if size(manyminsm,2)==0
        nums = regexp(filename,'\d+','match');
        Z=str2num(nums{1});A=str2num(nums{2});
        list=[list;Z A];
        disp([nums{1} ' ' nums{2}])
    end
end
