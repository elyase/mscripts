function f = surfaceFun(pop,data)
%surfaceFun finds the interpolated Z energy value from a grid of points
Interpolant= TriScatteredInterp(data(:,1),data(:,2),data(:,4));
f=Interpolant(pop(:,1),pop(:,2));
end
