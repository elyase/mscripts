minElongation=3;
maxElongation=10;
N_MIN=3;                            %number of minima to be exported
E_TOL=10;                           %allowed energy difference in MeV
%directory='/Volumes/FIAS/wideGridCalculations/data/';
no_minimum=zeros(23000,2);idx1=0;
less3_minimum=zeros(23000,2);idx2=0;
normal_minimum=zeros(23000,5);idx3=0;
directory='localminimanobounds/';
ggFiles = dir([directory '*.grossgrid.mat']);
% outputDir='localminimanobounds';
% mkdir(outputDir)
nFiles=length(ggFiles);
h= waitbar(0,'Please wait...');

%% Loop over minimanobounds files
for k = 1:nFiles
    %% Parse Z and A from file name
    fileName = ggFiles(k).name;
    %outputFilename=[outputDir '/' fileName '.txt'];
    %disp(['Analizing ' fileName])
    nums = regexp(fileName,'\d+','match');
    Z=round(str2double(nums{1}));
    A=round(str2double(nums{2}));
    mins=importdata([directory fileName]);
    
    %% mins sanity check
    if size(mins,2)==0,
        idx1=idx1+1;
        no_minimum(idx1,:)=[Z A];
        continue;
    end
    
    %% Convert mins to matrix
    X=[mins.X];
    elongations=X(1:2:end);
    delta=X(2:2:end);
    energies=[mins.Fval];
    mins=[elongations' delta' energies'];
    
    %% eliminate minima at the right elongation border
    if any(abs(elongations-maxElongation)<0.05)
        mins(abs(elongations-maxElongation)<0.05,:)=[];
        if size(mins,2)==0,
            idx1=idx1+1;
            no_minimum(idx1,:)=[Z A];
            continue;
        end
    end
    %% eliminate minima 10 MeV higher
    [minEnergy idx]=min(mins(:,3));
    mins(mins(:,3)-minEnergy>E_TOL,:)=[];
    
%    %% Check if less than 3
%     if any(abs(elongations-minElongation)<0.05)
%         %first make sure this is the case
%         %retrieve data file:
%         %data=importdata();
%         
%         %minima < 3, needs recalculation
%         idx2=idx2+1;
%         less3_minimum(idx2,1:2)=[Z A];
%         continue;
%     end
    
    %% select "best"(meaning "with lower value") minima
    mins=sortrows(mins,3);
    l=min([numel(mins(:,1)) N_MIN]);
    for j=1:l
        idx3=idx3+1;
        normal_minimum(idx3,:)=[Z A mins(j,:)];
    end
    
    %% Show progress
    if mod(k,100)==0,
        waitbar(k/nFiles);
%         str = sprintf('Progress: %2.1f percent, more than 10=%d, less than 3=%d, normal minimum=%d',100*k/nFiles);
%        if k>100, char(8)*ones(1,length(str)), end
%        disp(str);
        %fprintf('Count total %d, checksum %d\n',k,idx1+idx2+idx3);
    end
end


   

close(h) 
fprintf('Total nuclei: %d\n',nFiles);

%clean lists
normal_minimum(idx3+1:end,:)=[];
less3_minimum(idx2+1:end,:)=[];
no_minimum(idx1+1:end,:)=[];
%clear idx1 idx2 idx3 k elongations maxElongation minElongation mins ...
%        X Z A fileName ggFiles list outputDir directory nFiles nums
