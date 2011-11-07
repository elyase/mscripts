%QV_fid = fopen(fullfile(pwd,'QValues.txt'));
%data = textscan(QV_fid, '%f %f %f %f %f %f %*[^\n]');
%fclose(QV_fid);
mirrordata=table;
%y=cell2mat(mirrordata(:,1));
%x=cell2mat(mirrordata(:,2))-y;
%z=cell2mat(mirrordata(:,3));
y=mirrordata(:,1);
x=mirrordata(:,2)-y;
z=mirrordata(:,5);
%z(z>25)=25;
    % Define the resolution of the grid:
xres=max(x)-min(x)+1;
yres=max(y)-min(y)+1;
    % Define the range and spacing of the x- and y-coordinates,
    % and then fit them into X and Y:
xv = linspace(min(x), max(x), xres);
yv = linspace(min(y), max(y), yres);
[Xinterp,Yinterp] = meshgrid(xv,yv);


    % Calculate Z in the X-Y interpolation space, which is an
    % evenly spaced grid:
Zinterp = (griddata(x,y,z,Xinterp,Yinterp,'cubic'));
%Zinterp(find(Zinterp==NaN))=-4;


% Generate the mesh plot (CONTOUR can also be used):
%hf4 = figure;
%pcolor(Xinterp,Yinterp,Zinterp), hold;

    %Maximize plotting window throw figure command
fullscreen = get(0,'ScreenSize');
figure('Position',[0 -50 fullscreen(3) fullscreen(4)]);


[C,h] = surface(Xinterp,Yinterp,Zinterp);hold;
%clabel(C,h)
%colormap(grey);

    %Set axis properties
axis tight
%ylim([-0.9 0.9]);

%set(gca,'YTick',-0.9:0.1:0.8)
%h = findobj('Type','patch');
%set(h,'LineWidth',1)

    %Set the right perspective
%frontsideperspective=[0.2924, 0.9563, 0 ,    -0.6243;...
%    -0.6147, 0.1879, 0.7660,-0.1696;...
%    -0.7326, 0.2240,-0.6428, 9.2359;...
%    0     , 0     , 0     , 1];
%view([73 40]);

%plot3(x,y,z,'o');
%colormap(cool(8))
    
        %Anotate plot
title('Q alpha values');
xlabel 'N';
ylabel 'Z';
zlabel 'QValues';


%har=annotation('textarrow',x_arrow,y_arrow);
%set(har,'String','Valley','Fontsize',8)
clear C h Xinterp Yinterp Zinterp mirrordata x y z xv yv yres xres

