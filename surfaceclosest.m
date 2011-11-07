function [ PES_mass ] = surfaceclosest(data,R,delta)
%SURFACECLOSEST Find minimum in elongation-deformation space 
% of data structure(R=data(:,1),R=data(:,2),R=data(:,3))
[temp,indexR]=min(abs(data(:,1)-R));
[temp,indexD]=min(abs(data(indexR:end,2)-delta));
PES_mass=data(indexR+indexD-1,3);
end