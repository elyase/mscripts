directory='/Volumes/FIAS/wideGridCalculations/data/';
ggFiles = dir([directory '*.grossgrid']);
outputDir='localminima';
mkdir(outputDir)
for k = 1:length(ggFiles)
    filename = ggFiles(k).name;
    outputFilename=[outputDir '/' filename '.mat'];
    disp(['Analizing ' filename])
    if exist(outputFilename,'file')==2, 
        disp('Ya fue calculado.'); 
        continue;
    end
    data=importdata([directory filename]);
    [x fval eflag output manymins]=multiMinSearch(data);
    save(outputFilename,'manymins');
end
