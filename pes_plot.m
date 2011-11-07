function [] = pes_plot(nuclei,n_index)
%PES_PLOT Plot data contained in "nuclei" structure

	%Retrieve information from nuclei structure
%data=nuclei(n_index).PES(1:4*end/5,:);
data=nuclei(n_index).PES(1:end,:);
mirrordata=data;
mirrordata(:,2)=-mirrordata(:,2);
mirrordata=[data;mirrordata];
x=mirrordata(:,1);
y=mirrordata(:,2);
z=mirrordata(:,5);
    % Define the resolution of the grid:
xres=51;
yres=90;
    % Define the range and spacing of the x- and y-coordinates,
    % and then fit them into X and Y:
xv = linspace(min(x), max(x), xres);
yv = linspace(min(y), max(y), yres);
[Xinterp,Yinterp] = meshgrid(xv,yv);


    % Calculate Z in the X-Y interpolation space, which is an
    % evenly spaced grid:
Zinterp = griddata(x,y,z,Xinterp,Yinterp,'cubic');
%Zinterp(find(Zinterp==NaN))=-4;


% Generate the mesh plot (CONTOUR can also be used):
%hf4 = figure;
%pcolor(Xinterp,Yinterp,Zinterp), hold;

    %Maximize plotting window throw figure command
fullscreen = get(0,'ScreenSize');
figure('Position',[0 -50 fullscreen(3) fullscreen(4)]);


surf(Xinterp,Yinterp,Zinterp);hold;
%colormap(grey);

    %Set axis properties
axis tight
%ylim([-0.9 0.9]);
ylim([-1 1]);
%set(gca,'YTick',-0.9:0.1:0.8)
%h = findobj('Type','patch');
%set(h,'LineWidth',1)

    %Set the right perspective
frontsideperspective=[0.2924, 0.9563, 0 ,    -0.6243;...
    -0.6147, 0.1879, 0.7660,-0.1696;...
    -0.7326, 0.2240,-0.6428, 9.2359;...
    0     , 0     , 0     , 1];
view([73 40]);

%plot3(x,y,z,'o');
%colormap(cool(8))
    
        %Anotate plot
title(['Z=',num2str(nuclei(n_index).Z),' A=',num2str(nuclei(n_index).A)]);
xlabel 'Elongation (fm)';
ylabel 'Mass asymmetry';
zlabel 'Potential energy (MeV)';
        %Now start placing the text arrows
x1=0.5;
y1=0.5;
x2=x1+0.3;
y2=y1-0.1;
x_arrow=[x2 x1];
y_arrow=[y2 y1];
%har=annotation('textarrow',x_arrow,y_arrow);
%set(har,'String','Valley','Fontsize',8)


end

