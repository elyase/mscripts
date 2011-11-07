function gsplot(Z,gs,mode)
TCSM_col=5;
Moller_col=7;
exp_col=6;
indexes=find((gs(:,1) == Z));
if mode=='n'
 plot(gs(indexes,2),gs(indexes,TCSM_col),'*g',...
      gs(indexes,2),gs(indexes,Moller_col),'.b',...
      gs(indexes,2),gs(indexes,exp_col),'sr');
  title(['Ground states vs A for nuclei with Z=',num2str(Z)]);
  ylabel('Mass deffect(MeV)');
  legend('TCSM','Moller','Experiment');
else
 plot(gs(indexes,2),gs(indexes,TCSM_col)-gs(indexes,Moller_col),'*g',...
      gs(indexes,2),gs(indexes,Moller_col)-gs(indexes,exp_col),'+b',...
      gs(indexes,2),gs(indexes,TCSM_col)-gs(indexes,exp_col),'sr');
 title(['Ground states difference vs A for nuclei with Z=',num2str(Z)]);
 ylabel('Ground stated difference(MeV)');
 legend('TCSM-Moller','Moller-Experiment','TCSM-experiment');
end 
axis tight
 xlabel('A');
 
 