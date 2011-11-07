function [ result ] = tcsm(Z,A,mode)
%TCSM Finds corresponding tcsm mass for given Z,A
%   Example: 
%      tcsm(92,235)
%      tcsm(92,235,'beta')
%      tcsm(92,235,'shellcorrection')

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

isRead=evalin('base','exist(''M_tcsm'',''var'')');
if ~isRead, 
    assert(exist('groundstates.dat','file')==2, ...
        'File tcsm.dat should be   in current directory');
    table=read_tcsm;
else
    table=evalin('base','M_tcsm');
end
assert(numel(Z)==numel(A),'Number of elements in Z and A must be equal')
if size(Z,2)~=1, Z=Z';end;
if size(A,2)~=1, A=A';end;
[~, index_tcsm]=ismember([Z A],table(:,[1 2]),'rows');
if nargin==2,mode='';end
switch lower(mode)
    case {'','mass'}
        result=table(index_tcsm,4);
    case {'beta','beta2'}
        result=table(index_tcsm,3);
    case {'shell','correction','shellcorrection'}
        result=table(index_tcsm,5);
    otherwise
        error(['Unknown third option. Possible options are ''beta''' ...
        ',''shell'',''correction'',''shellcorrection'' or simply no option']);
        exit;
end
if isempty(result), result=NaN; end
end

function [M_tcsm] = read_tcsm
M_tcsm=importdata('groundstates.dat');	
assignin('base','M_tcsm',M_tcsm);
end