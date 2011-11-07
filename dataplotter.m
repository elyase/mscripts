%load driving_potentials.dat


%QValues(:,2)-QValues(:,1);
%QValues(:,1);
%QValues(:,4);

%data=driving_potentials;
%mirrordata=data(1:2*end/5,:);
%mirrordata(:,2)=-mirrordata(:,2);
%mirrordata=[data(1:4*end/5,:);mirrordata];
mirrordata=data;
%mirrordata((mirrordata(:,2)<-0.4),:)=[];
%mirrordata((mirrordata(:,1)<70),:)=[];
%mirrordata((mirrordata(:,1)>90),:)=[];
%mirrordata((mirrordata(:,5)>0.4),:)=[];
x=mirrordata(:,2);
%-mirrordata(:,1);
y=mirrordata(:,1);
z=abs(mirrordata(:,3));
% Define the resolution of the grid:
xres=length(mirrordata(:,1))/nnz(mirrordata(:,1)==mirrordata(1,1));
yres=length(mirrordata(:,2))/nnz(mirrordata(:,2)==mirrordata(1,2));
%xres=50;
%xres=(max(x)-min(x))*0.8;
%yres=(max(y)-min(y))*0.8;
% Define the range and spacing of the x- and y-coordinates,
% and then fit them into X and Y:
xv = linspace(min(x), max(x), xres);
yv = linspace(min(y), max(y), yres);
[Xinterp,Yinterp] = meshgrid(xv,yv);


% Calculate Z in the X-Y interpolation space, which is an 
% evenly spaced grid:
Zinterp = (griddata(x,y,z,Xinterp,Yinterp,'cubic'));
%Zinterp(Zinterp>0.41)=NaN;
%Zinterp(Zinterp<-0.41)=NaN;
%Zinterp(find(Zinterp==NaN))=-4;


% Generate the mesh plot (CONTOUR can also be used):
%hf4 = figure;
%pcolor(Xinterp,Yinterp,Zinterp), hold;
fullscreen = get(0,'ScreenSize');
figure('Position',[0 -50 fullscreen(3) fullscreen(4)]);
surface(Xinterp,Yinterp,Zinterp) , hold;
%colormap(grey);
axis tight
%ylim([-0.9 0.9]);
%set(gca,'YTick',[-0.9:0.1:0.8])
h = findobj('Type','patch');
set(h,'LineWidth',1)

view(0);
%plot3(x,y,z,'o');
%colormap(cool(8))
% xlabel 'asymetry';
% ylabel 'elongation'; 
% zlabel 'energy';
% title 'PES'
clear Xinterp Yinterp Zinterp h mirrordata x xres xv y yres yv z
