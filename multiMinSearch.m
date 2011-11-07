function [x fval eflag output manyminsm] = multiMinSearch(data)
%multiMinSearch Search for minima in gross grid
%   Detailed explanation goes here
x0=[6.5 0];
minR=min(data(:,1));
maxR=max(data(:,1));
minDlt=min(data(:,2));
maxDlt=max(data(:,2));
data=data(~isnan(data(:,4)),:);
Interpolant= TriScatteredInterp(data(:,1),data(:,2),data(:,4));
ObjectiveFcn = @(x) Interpolant(x(:,1),x(:,2));
lb= [minR minDlt];
ub=[maxR maxDlt];
TolX=0.2;
TolFun=2;

%matlabpool open 2

tic
%build startpoints grid
[X,Y] = ndgrid(minR:0.6:maxR,minDlt:0.1:maxDlt);
W = [X(:),Y(:)];
custstpts= CustomStartPointSet(W);

%Create and run problem
opts = optimset('Algorithm','sqp','Display', 'iter','MaxIter',50,'TolFun',0.2);
problem = createOptimProblem('fmincon','objective',ObjectiveFcn,'x0',x0,'lb',lb,'ub',ub,'options',opts);
ms = MultiStart('StartPointsToRun','bounds','UseParallel','always','Display', 'iter','TolX',TolX,'TolFun',TolFun);%,'PlotFcns',@gsplotbestf);
[x fval eflag output manyminsm]= run(ms,problem,custstpts);
%matlabpool close
toc

%Eliminate frontier minima
% cnt=0;
% for i=1:length(manyminsm(:))
% if any(abs(manyminsm(i).X-lb)<0.05) || any(abs(manyminsm(i).X-ub)<0.05)
%     index(i)=1;
% else
%     index(i)=0;
% end
% end
% index=logical(index);
% manyminsm(index)=[];

%plot minima
possColors = 'kbgcrm';
hold on
for i = 1:size(manyminsm,2)  
    % Color of this line
    cIdx = rem(i-1, length(possColors)) + 1;
    color = possColors(cIdx);
    % Plot start points
    u = manyminsm(i).X0; 
    x0ThisMin = reshape([u{:}], 2, length(u));
    plot(x0ThisMin(1, :), x0ThisMin(2, :), '.', ...
        'Color',color,'MarkerSize',25);
    % Plot the basin with color i
    plot(manyminsm(i).X(1), manyminsm(i).X(2), '*', ...
        'Color', color, 'MarkerSize',25); 
end % basin center marked with a *, start points with dots
hold off
end




