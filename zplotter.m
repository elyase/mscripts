function zplotter(Zi,Zf,column)
if nargin~=3
    error('You must enter Zi,Zf and column input arguments.');
end
if Zf-Zi+1>6
    disp('Will only plot 6 colors.');
    Zf=Zi+5;
end
colors=['r';'g';'b';'y';'c';'k'];
markers=['o','s','v','x','+','d'];
count=0;
hold all;
%load alpha_decay_exp2007.txt;
load data.mat;
for Z=Zi:Zf
    count=count+1;
    QVindexes=(table(:,1)==Z);
    %QVindexes=QVindexes(1:(length(QVindexes)/3));%Only plot the low A region as there is no exp for higher A 
    %expindexes=find(alpha_decay_exp2007(:,1)==Z);
    %if numel(expindexes)==0 
    %    continue
    %end
    %temp1=find(table(QVindexes,2)==alpha_decay_exp2007(expindexes(1),2));
    %temp2=find(table(QVindexes,2)==alpha_decay_exp2007(expindexes(length(expindexes)),2));
    %QVindexes=QVindexes((temp2(length(temp2))):(temp1(length(temp1))+2)); %Only plot the A region where experimental data exists
    h1=plot(table(QVindexes,2)-table(QVindexes,1),abs(table(QVindexes,column)),'Marker',markers(count), 'LineStyle','none');    
    %h2=plot(QValues(QVindexes,2),QValues(QVindexes,4),'*', 'LineStyle','none');
    %h3=errorbar(alpha_decay_exp2007(expindexes,2),alpha_decay_exp2007(expindexes,5),alpha_decay_exp2007(expindexes,6),'s');
    %h3=plot(alpha_decay_exp2007(expindexes,2),alpha_decay_exp2007(expindexes,5),'s');
    set(h1,'Color',colors(count));
    set(h1,'MarkerSize',6);
    %set(h1,'MarkerFaceColor',colors(count));
    [LEGH,OBJH,OUTH,OUTM] = legend;
    if ~(size(OUTM)==0)
        legend([OUTH;h1],OUTM{:},strcat('TCSM(Z=',num2str(Z),')'));
    else
        legend(h1,strcat('TCSM(Z=',num2str(Z),')')); %this is needed first time legend is created, otherwise an error is raised
    end       
    %set(h2,'Color',colors(count));
    %set(h2,'MarkerSize',6);
    %set(h3,'Color',colors(count));
    %[LEGH,OBJH,OUTH,OUTM] = legend;
    %legend([OUTH;h2],OUTM{:},strcat('Moller(Z=',num2str(Z),')'));
    %set(h3,'MarkerFaceColor',colors(count));
    %set(h3,'MarkerSize',10);
    %[LEGH,OBJH,OUTH,OUTM] = legend;
    %legend([OUTH;h3],OUTM{:},strcat('Experiment(Z=',num2str(Z),')'));
    xlabel('N');
    ylabel('\beta_2 deformation');
end
clear;