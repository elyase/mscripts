%LIST_CORRECTER Makes corrections to nuclear list files
%   LIST_CORRECTER Displays a file selection dialog and sorts selected file
%   according to first column(Z), then second(A) and so on. Also
%   eliminates non-unique rows.
%   Usage: 
%      list_correcter

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

Z_MIN=50;
Z_MAX=160;
%select input file
[fileName,pathName] = uigetfile('*.dat','Select data file');
if isequal(fileName,0)
    disp('No file selected. Exiting ...');
    return;
end
groundstates=importdata(fileName);

%sort according to rows
table=sortrows(groundstates);
%filters
table(table(:,1)<Z_MIN | table(:,1)>Z_MAX | isnan(table(:,1)),:)=[];
%unique elements
[~, uniqueIndexes, ~]=unique([table(:,1) table(:,2)],'rows');
table=table(uniqueIndexes,:);
disp('Output in variable "table". Format:');
disp('Z A beta GroundState ShellCorrection');
clear i Z_MIN Z_MAX fileName pathName groundstates temp1 temp2 uniqueIndexes
