function []=nucleiPlot(Z,A,varargin)
%plots different kinds of plots specified by varargin
% Example:
%   nucleiPlot(Z,A,'audi-moller','beta')
%TODO
%[DONE]1-Add validation to input parameters
% What to plot
% shellcorrrection, Qalpha comparisons, ground state masses, beta2,
% separation energies arround 

%input validation
ParameterTypes={'error','beta2','shell','t','halflife','qalpha','s1n',...
    's1p','s2n','s2p','qbeta-','qbeta+','talpha','beta','mass'};
msgParameterTypes={'experimental mass errors'    , '\beta_2 deformations',...
    'shell corrections','experimental half lifes','experimental half lifes',...
    'Q_{\alpha}' ,'one neutron separation energies',...
    'one proton separation energies','two neutrons separation energies',...
    'two protons separation energies','\beta^- half lifes',...
    '\beta^+ half lifes','\alpha^+ half lifes','\beta_2 deformations',...
    'ground state masses'};
msgParameterUnits={'MeV','','MeV','s','s','MeV','MeV','MeV','MeV','MeV','MeV','MeV','s','','MeV'};
p=inputParser;
validateZA = @(x)validateattributes(x, {'numeric'}, ...
    {'integer', 'positive', '<=', 500});
p.addRequired('Z', validateZA);
p.addRequired('A', validateZA);
p.addRequired('PlotTypes');
p.addRequired('Parameter',@(x)ismember(x,ParameterTypes));
p.addOptional('filename','',@(x)ischar(x));
p.parse(Z, A, varargin{:});

plots=textscan(p.Results.PlotTypes,'%s','delimiter',',');
Parameter=p.Results.Parameter;
filename=p.Results.filename;
fh=figure('Units', 'pixels', ...
    'Position', [100 100 600 375]);
hold on;
set(0,'DefaultAxesColorOrder',[0 0 0],...
    'DefaultAxesLineStyleOrder','-o|-.^|--s|:p')
for j=1:numel(Z);                     %cycle through all Z
    for i=1:numel(plots{1})           %cycle through all plots
        x=A-Z(j);
        y=table(Z(j)*ones(length(A),1),A,cell2mat(plots{1}(i)),Parameter); 
        x(y==NaN)=NaN;
        h=plot(x,y,'LineWidth',1.5,'MarkerSize', 5);
        hold all;
    end
end

mapTypes = containers.Map(ParameterTypes, msgParameterTypes);
mapUnits = containers.Map(ParameterTypes, msgParameterUnits);

%set title
if numel(plots{1})>1, strTitle='Comparison of '; else strTitle=''; end
strTitle=[strTitle mapTypes(Parameter)];
hTitle=title(strTitle);

%axis labels
hXLabel=xlabel('N');
hYLabel=ylabel([mapTypes(Parameter) '(' mapUnits(Parameter) ')'],'Rotation',90);

%legend
if numel(Z)>1, 
    plots{1}=cell(numel(Z),1);
    for j=1:numel(Z),
        plots{1,1}{j,1}=['Z=' num2str(min(Z)+j-1)];
    end
    hLegend=legend(plots{1});
end
hLegend=legend(plots{1}) ;

% Adjust Font and Axes Properties
set( gca                       , ...
    'FontName'   , 'Helvetica' );
set([hLegend, gca]             , ...
    'FontSize'   , 8           );
set([hXLabel, hYLabel]  , ...
    'FontSize'   , 10);
set( hTitle                    , ...
    'FontSize'   , 12          , ...
    'FontWeight' , 'bold'      );
set(gca, ...
  'Box'         , 'on'     , ...
  'TickDir'     , 'in'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'off'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'LineWidth'   , 1.5         );

%Make y axis symmetric 
%ylim([-max(abs(ylim)) max(abs(ylim))]);

%Change bg color from grey to white
set(fh, 'color', 'white');

% Export to EPS
if ~isempty(filename), 
    set(gcf, 'PaperPositionMode', 'auto');
    disp('-----------------------------------------------------------------');
    input('nucleiPlot: Make modifications to plot and finally press enter: ');
    print('-depsc2',filename);
end
end


















