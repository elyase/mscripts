%Mass excess to binding energy calculator
M_P = 938.2723;    %MeV
M_E = 0.5110;      %MeV
M_N = 939.5656;    %MeV
AMU =  931.494028; %MeV
for i=1:length(table(:,1))
  Z=table(i,1);
  A=table(i,2);
  M_EXCESS=table(i,4);
  bindingEnergy=Z*(M_P+M_E) + (A-Z)*M_N - (M_EXCESS+A*AMU);
  table(i,6)=bindingEnergy;
end
clear M_P M_E M_N AMU Z A M_EXCESS daugtherIndex bindingEnergy i