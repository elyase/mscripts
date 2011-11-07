function epsilon=efficiency(E,a,b,d,h)
%% Efficiency of a cylindrical detector for a Marinelli beaker source
%  This program calculates the efficiency of a cylindrical detector for a
%  Marinelli beaker source.
%  Usage:
%    Example 1: Calculate the efficiency for a simple parameter combination:
%    efficiency(80,2.75,5.4,0.07,20)
%
%    Example 2: Plot the dependency of the efficiency on energy:
%    E=80:0.5:95;
%    eff=efficiency(E,2.75,5.4,0.07,20);
%    plot(E,eff); 
%
%  References:
%  M.I. Abbas, Applied Radiation and Isotopes 54 (2001) 761-768
%  Selim, Y.S., Abbas, M.I., Fawzy, M.A., Radiat.Phys.Chem.53(1998), 589-592.
%  M.I. Abbasa, Y.S. Selima, M. Bassiounib, Radiation Physics and Chemistry 61 (2001) 429-431
%
%     Copyright(c)2011-2012
%         Yisel Martinez (yisel@instec.cu)
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

% TO DO
%
% E=80;               %energy in keV
%
% %% Geometry definition
% a=2.75;             %Crystal radio in cm
% b=5.4;              %Crystal length in cm(height)
% d=0.07;             %Thickness of the detector cover in cm(aluminium)
% h=20;               %Distance crystal-source

format long
%% Convert all inputs to the same number of elements
l=max([numel(E) numel(a) numel(b) numel(d) numel(h)]);
if numel(E)==1, E=E(1)*ones(1,l); end
if numel(a)==1, a=a(1)*ones(1,l); end
if numel(b)==1, b=b(1)*ones(1,l); end
if numel(d)==1, d=d(1)*ones(1,l); end
if numel(h)==1, h=h(1)*ones(1,l); end

%% Auxiliary functions
theta1=atan(a./(b+h));
theta2=atan(a./h);

%% Material properties
mu = 138.8*exp(-E/21.87)+1.636*exp(-E/365.8);
tau= 0.107002+5.323*exp(-E/20.36)+0.3192*exp(-E/526.9);

%% Efficiency
%Code could be better vectorized with quadv but it looses portability to
%other languages
for i=1:l
    f1=@(x) (1-exp(-mu(i)*b(i)./cos(x))).*exp(-tau(i)*d(i)./cos(x)).*sin(x);
    f2=@(x) (1-exp(mu(i)*h(i)./cos(x)-mu(i)*a(i)./sin(x))).*exp(-tau(i)*d(i)./cos(x)).*sin(x);
    epsilon(i)=0.5*(quad(f1,0,theta1(i))+quad(f2,theta1(i),theta2(i)));
end









