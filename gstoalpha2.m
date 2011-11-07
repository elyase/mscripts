h = waitbar(0,'Calculating...');
Work_dir=pwd;
%Parameters from Oganessian, PHYS. REV. C70, 064609(2004)
a_ogn=1.78722;
b_ogn=-21.398;
c_ogn=-0.25488;
d_ogn=-28.423;
data_fid = fopen(fullfile(Work_dir,'ground_states.txt'));
QV_fid = fopen(fullfile(Work_dir,'QValues.txt'), 'wt');
data = textscan(data_fid, '%f %f %f %f %f %*[^\n]');
Z=data{1};
A=data{2};
M=data{5};
read_moller;
read_audi;
t0=cputime;
%Moller and Audi values retrieval can be optimized here by 
%constructing a table to avoid calls to respective functions
for j=1:length(Z)
    for i=1:length(Z)
        if ((Z(j)-2)==Z(i)) && ((A(j)-4)==A(i))
            Q_alpha=M(j)-M(i)-2.4249;
            Q_alpha_moller=moller(M_moller,Z(j),A(j))-moller(M_moller,Z(i),A(i))-2.4249;
            Q_alpha_audi=audi(M_audi,Z(j),A(j))-audi(M_audi,Z(i),A(i))-2.4249;
            logTalpha=(a_ogn*Z(j)+b_ogn)/(sqrt(Q_alpha))+c_ogn*Z(j) + d_ogn;
            logTalpha_moller=(a_ogn*Z(j)+b_ogn)/(sqrt(Q_alpha_moller))+c_ogn*Z(j) + d_ogn;
            if (Q_alpha > 0) %&& (Q_alpha_moller > 0)
                fprintf(QV_fid,'%d %d %.4f %.4f %.4f %.4f %.4f\n',Z(j),A(j),Q_alpha,Q_alpha_moller,Q_alpha_audi,logTalpha,logTalpha_moller);
            end
            waitbar(j/length(Z));
            rem_time=round((size(Z,1)-j)*(cputime-t0)/j);
            set(get(findobj(h,'type','axes'),'title'), 'string', ['Remaining time: ' num2str(rem_time) ' seconds.']);
        end
    end
end
fclose(QV_fid);
fclose(data_fid);
close(h);
fprintf('Output file: %s\n',fullfile(Work_dir,'QValues.txt'));
disp('Format:Z A Qa Qa_moller Qa_audi logTa logTa_moller');
clear 