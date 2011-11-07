function ggPlotter(fileName,mode)
%ggPlotter    Plots potential energy surface
%   ggPlotter with no parameters displays a file selection dialog 
%   ggPlotter(filename) generates a plot for a potential energy 
%   surface given by filename. Filename should be in the current directory.
%   If optional parameter mode is given, then ... 
%   Example: 
%      surfacePlotter('92_235')

%     Copyright(c)2009-2010 
%         Yaser Martinez (palenzuela@fias.uni-frankfurt.de)
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.

pathName=[pwd '/'];
if nargin==0
    [fileName,pathName] = uigetfile('*.grossgrid','Select data file');
    if isequal(fileName,0)
        disp('No file selected. Exiting ...');
        return;
    end
end


%Extraer Z y A del nombre del fichero
nums = regexp(fileName,'\d+','match');
Z=str2num(nums{1});A=str2num(nums{2});

%Cargar el fichero.dat a una variable
if ~exist([pathName fileName],'file'),
    disp(['File ' [pathName fileName] ' not found. Exiting ...']);
    return;
end
[data,~,hasFragmentMasses]=importdata([pathName fileName]);
if hasFragmentMasses
    disp(data.textdata);
    data=data.data;
end
dataLength=length(data(:,1));
%Cuts
data(data(:,2)<-0.4,:)=[];
%data(data(:,4)>260,:)=[];
percent=1000;

%extract elongation vector
r=data(:,1);
rRes=dataLength/nnz(r==r(1));
rRes=percent*rRes/100;
rMin=min(r);
rMax=max(r);
rGrid=linspace(rMin,rMax,rRes);

%extract deformation vector
etaA=data(:,2);
etaARes=dataLength/nnz(etaA==etaA(1));
etaARes=etaARes*percent/100;
%etaARes=70;                             %best looking resolution up to now
etaaMin=min(etaA);
etaaMax=max(etaA);
etaaGrid=linspace(etaaMin,etaaMax,etaARes);


V=data(:,4);

%build grid and interpolate data
[Xinterp,Yinterp] = meshgrid(etaaGrid,rGrid);
%Zinterp = griddata(etaA,r,V,Xinterp,Yinterp,'cubic');
Interpolant= TriScatteredInterp(data(:,1),data(:,2),data(:,4));
Zinterp=Interpolant(Xinterp,Yinterp);
%ObjectiveFcn = @(x) Interpolant(x(:,1),x(:,2));

%mirroring along etaA=0 axis
Xinterp=[-fliplr(Xinterp) Xinterp];
Yinterp=[fliplr(Yinterp) Yinterp];
Zinterp=[fliplr(Zinterp) Zinterp];

%data visualization
fullscreen = get(0,'ScreenSize');
figure('Position',[0 -50 fullscreen(3) fullscreen(4)]);
if nargin==2, 
    set(gcf,'visible','off'); 
end
%surface(Xinterp,Yinterp,Zinterp); hold('on');
%V(V>20)=20;
plot3(r,etaA,V,'*');
%plot customization
mins=importdata(['localminimanobounds' fileName '.mat']);
X=[mins.X];
elongations=X(1:2:end);
delta=X(2:2:end);
energies=[mins.Fval];
mins=[elongations' delta' energies'];
hold on;
plot3(elongations,delta,energies,'*r');
axis tight;
view([159 48]);
set( gca                       , ...
    'FontName'   , 'Helvetica' );
hTitle=title(['PES for nuclei  ' '^{' num2str(A) '}' num2str(Z) '. Percent: '...
    num2str(percent)],'fontsize',14,'FontWeight' , 'bold');
hXLabel=xlabel('deformation','fontsize',14,'FontName','AvantGarde','Rotation',8);
%set(hXLabel,'Position',get(hXLabel,'Position') + [-.3 -.7  0]);
hYLabel=ylabel('elongation(fm)','fontsize',14,'Rotation',-47,'FontName','AvantGarde'); 
%set(hYLabel,'Position',get(hYLabel,'Position') + [-.16 -4 0]);
hZLabel=zlabel('energy(MeV)','fontsize',14,'Rotation',90,'FontName','AvantGarde'); 
%set(hzLabel,'Position',get(hzLabel,'Position') + [-.16 -4 0]);
%arrow3([0 5.24 380],[0 5.24 350],'1_b',0.6);
axis normal
%text([0 5.24 380],'Ground state','FontSize',18);
% light the front
%g = light;
%set(g,'Style','infinite',...
%    'position',[0.08 0.08 1]);
%material shiny;
% light the back
lighting gouraud
%export plot if required
if nargin==2,
    opts = struct('FontMode','fixed','FontSize',16,'Color','cmyk','bounds','loose');
    exportfig(gcf,'gouraud.eps',opts);
end;

end


