function [ result ] = table(Z,A,varargin)
%AUDI Returns corresponding Audi,Moller or TCSM data for given Z,A
%   Examples:
%      table(8,:,'audi','Z A mass')
%      table(100,250,'abs(moller-audi)','qalpha')
%
%     Copyright(c)2009-2010
%         Yaser Martinez (palenzuela@fias.uni-frankfurt.de)
%t
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
%
% TODO
% 1-[DONE]Fix Moller filename to make it compatible with directly downloaded
% filename
% 2-Upload tscm data file and set URL
% 3-[DONE]Set download URL for each table type
% 4-[DONE]Set parameter correspondence for each table
% 5-Improve help
% 6-Use 'EmptyValue' property in textscan.

global Z_temp; 
global A_temp;
Z_temp=''; 
A_temp=''; 

%input parameter parsing
p=inputParser;
%p.KeepUnmatched = true;
validateZA = @(x)validateattributes(x, {'numeric'}, ...
    {'integer', 'positive', '<=', 600});
p.addRequired('Z');         %no validation for Z,A
p.addRequired('A');
p.addRequired('TableType');
p.addRequired('Parameter');
% , @(x)ismember(x,{'error','beta2',...
%     'shell','t','halflife','qalpha','s1n','s1p','s2n','s2p','qbeta-',...
%     'qbeta+','talpha','tbeta-','beta','mass'}));
%assert(numel(Z)==numel(A),'Number of elements in Z and A must be equal');
p.parse(Z, A, varargin{:});
Parameter=p.Results.Parameter;
tableType=p.Results.TableType;

%if needed convert input vectors Z,A to column vectors
if size(Z,2)~=1, Z=Z';end;
if size(A,2)~=1, A=A';end;

%for loop for every parameter, ex: 'Z A mass'
Parameter=regexp(Parameter,' ','split');
tableTypeSplitted=regexp(tableType,'[^(tcsm)|(moller)|(audi)]','split');
for i=1:length(Parameter)
    tableCommand=['tablehelper(' mat2str(Z) ',' mat2str(A) ',''$1'',''' Parameter{i} ''')'];
    if ismember(upper(Parameter{i}),{'Z','A'}) ,
        strCommand=regexprep(tableTypeSplitted{1}, '(tcsm)|(moller)|(audi)', tableCommand);
    else
        strCommand=regexprep(tableType, '(tcsm)|(moller)|(audi)', tableCommand);
    end
    %Evaluate command
    if i==1,
        result=eval(strCommand);
    else
        result=[result eval(strCommand)];
    end
end
end


function [ result ] = tablehelper(Z,A,varargin)

p=inputParser;
p.addRequired('Z');
p.addRequired('A');
p.addRequired('TableType');
p.addRequired('Parameter');
p.parse(Z, A, varargin{:});

%mass excess in MeV
M_ALPHA = 2.4249156;         %alpha
M_N     = 8.0713171;         %neutron
M_P     = 7.28897050;        %proton

%Parameters for Viola-Seaborg Talpha calculation(Oganessian, PHYS. REV.
%C70, 064609(2004))
a_ogn=1.78722;
b_ogn=-21.398;
c_ogn=-0.25488;
d_ogn=-28.423;


%set up variables for call to function loadTable
TableType=p.Results.TableType;
Parameter=p.Results.Parameter;

switch TableType
    case 'audi'
        filename='nubtab03.asc';
        URL='http://amdc.in2p3.fr/nubase/nubtab03.asc';
    case 'moller'
        filename='table.dat';
        URL='http://t2.lanl.gov/publications/masses/compressed/table.dat.gz';
    case 'tcsm'
        filename='groundstates.dat';
        URL='https://files.me.com/yaser.martinez/w7arwa';
end

%Find out if variable is already loaded or still needs to be downloaded/read
table=loadTable(TableType,filename,URL);

%audi specific patches
if strcmpi(TableType,'audi')
    table(:,1)=floor(table(:,1)/10);
    [~, uniqueIndexes, ~]=unique([table(:,1) table(:,2)],'rows','first');
    table=table(uniqueIndexes,:);
    table(:,3)=table(:,3)/1000.0;            %keV to MeV conversion
    table(:,4)=table(:,4)/1000.0;            %keV to MeV conversion
end

%patch to convert null indexes into NaNs(used by findZA)
table(length(table)+1,:)=NaN;

%Patch to eliminate NaNs in vectorized case
if isequal(Z,':') || isequal(A,':'), isVectorized=1;else isVectorized=0;end

%Calculate Z and A 
%If expression involves multiple tables then
%take Z A only for the first table
global Z_temp;
global A_temp;
% isZalreadyLoaded=~isempty(Z_temp);
% isAalreadyLoaded=~isempty(A_temp);
%  if strcmpi(Parameter,'Z'), Z_temp=result;end;
%     if strcmpi(Parameter,'A'), A_temp=result;end;
% if isZalreadyLoaded && strcmpi(Parameter,'A'),Z=Z_temp 
% elseif isAalreadyLoaded,A=A_temp;  
% else
    if isequal(Z,':') && isequal(A,':'),
        Z=table(:,1);
        A=table(:,2);
    elseif isequal(Z,':')
        Z=unique(table(:,1));
        Z(isnan(Z))=[];
        nZ=length(Z);
        Z=repmat(Z,length(A),1);
        A=repmat(A,1,nZ)';
        A=A(:);
    elseif isequal(A,':')
        A=unique(table(:,2));
        A(isnan(A))=[];
        nA=length(A);
        A=repmat(A,length(Z),1);
        Z=repmat(Z,1,nA)';
        Z=Z(:);
    end
%end

index=findZA(Z,A,table);

%Select requested output according to parameter
switch lower(Parameter)
    case {'z'}
        result=table(index,1);
    case {'a'}
        result=table(index,2);
    case {'mass'}
        result=table(index,3);
    case {'error'}
        assert(strcmpi(TableType,'audi'),'Parameter only valid for audi table');
        result=table(index,4);
    case {'t','halflife'}
        assert(strcmpi(TableType,'audi'),'Parameter only valid for audi table');
        result=table(index,5);
    case {'qalpha','talpha'}
        indexDaugther=findZA(Z-2,A-4,table);
        result=table(index,3)-table(indexDaugther,3)-M_ALPHA;
        if strcmpi(Parameter,'talpha')
            result=(a_ogn*Z+b_ogn)./(sqrt(result))+c_ogn*Z + d_ogn;
        end
    case {'qbeta-','tbeta-'}
        indexDaugther=findZA(Z+1,A,table);
        result=table(index,3)-table(indexDaugther,3);
        if strcmpi(Parameter,'tbeta-')
            result=(a_ogn*Z+b_ogn)./(sqrt(result))+c_ogn*Z + d_ogn;
        end
    case {'qbeta+'}
        indexDaugther=findZA(Z-1,A,table);
        result=table(index,3)-table(indexDaugther,3);
    case {'s1p'}
        indexDaugther=findZA(Z-1,A-1,table);
        result=table(indexDaugther,3)-table(index,3)+M_P;
    case {'s2p'}
        indexDaugther=findZA(Z-2,A-2,table);
        result=table(indexDaugther,3)-table(index,3)+2*M_P;
    case {'s1n'}
        indexDaugther=findZA(Z,A-1,table);
        result=table(indexDaugther,3)-table(index,3)+M_N;
    case {'s2n'}
        indexDaugther=findZA(Z,A-2,table);
        result=table(indexDaugther,3)-table(index,3)+2*M_N;
    case {'shell'}
        assert(strcmpi(TableType,'tcsm') || strcmpi(TableType,'moller'),...
            'Parameter only valid for tables tcsm and moller ');
        result=table(index,4);
    case {'beta2','beta'}
        assert(strcmpi(TableType,'tcsm') || strcmpi(TableType,'moller'),...
            'Parameter only valid for tables tcsm and moller ');
        result=table(index,5);
end
if isVectorized, 
    result(isnan(result(:,1)),:)=[];
    %put Z A in workspace
    if strcmpi(Parameter,'Z'), Z_temp=result;end;
    if strcmpi(Parameter,'A'), A_temp=result;end;
end
end               %function table

function [index]=findZA(Z,A,table)
%find corresponding index according to Z,A
[~, index]=ismember([Z A],table(:,[1 2]),'rows');
%patch to convert null indexes into NaNs
index(~index)=length(table);
end

function [outputTable] = importFile(filename,TableType)
%Loads filename into variable
whitespace='';
fid = fopen(filename);
switch TableType
    case 'audi'
        fmt=['%3[^\r\n] %5[^\r\n] %9[^\r\n] %12[^\r\n] %9[^\r\n] '...
            '%5[^\r\n] %6[^\r\n] %8[^\r\n] %3[^\r\n] %9[^\r\n] %3[^\r\n] '...
            ' %7[^\r\n] %14[^\r\n] %2[^\r\n] %10[^\r\n] %76[^\r\n]'];
        idxs=num2cell([2 1 4 5 10]);
        [idxZ idxA idxMass idxErrSh idxBetaT]=idxs{:};
    case 'moller'
        fmt = '%6s %*5s %5s %*50s %10s %*30s %10s %10s %*[^\n]';
        idxs=num2cell([1 2 5 4 3]);
        [idxZ idxA idxMass idxErrSh idxBetaT]=idxs{:};
    case 'tcsm'
        fmt='%s %s %s %s %s';
        idxs=num2cell([1 2 4 5 3]);
        [idxZ idxA idxMass idxErrSh idxBetaT]=idxs{:};
        whitespace=' ';
end
data = textscan(fid,fmt,'whitespace',whitespace);
outputTable(:,1)=numcell2matrix(data{1,idxZ});                 %Z
outputTable(:,2)=numcell2matrix(data{1,idxA});                 %A
outputTable(:,3)=numcell2matrix(data{1,idxMass});           %mass
outputTable(:,4)=numcell2matrix(data{1,idxErrSh});          %error or shell
outputTable(:,5)=numcell2matrix(data{1,idxBetaT});          %beta2 or T
fclose(fid);
end

function [outputMatrix]=numcell2matrix(inputCell)
%Converts tables cell to matrix
%eliminate non-numeric symbols excepting dot and minus
tempCell=regexprep(inputCell,'[^0-9.-]','');
%convert tu numeric values
tempCell=cellfun(@str2num, tempCell,'UniformOutput', false);
%some values such as blank spaces will return empty matrix, so we must
%patch this as NaNs
locateEmpty=cellfun(@isempty, tempCell);
tempCell(locateEmpty)={NaN};
%convert cell to matrix
outputMatrix=cell2mat(tempCell);
end

function [table] = loadTable(TableType,filename,URL)
assignin('base','s',['table_' TableType]);
isTableInWorkSpace=evalin('base','exist(s,''var'')');
isTableInCurrentDirectory=exist(filename,'file')==2;
evalin('base','clear s');
if isTableInWorkSpace,
    table=evalin('base',['table_' TableType]);
elseif isTableInCurrentDirectory,
    table=importFile(filename,TableType);
    assignin('base',['table_' TableType],table);        %output to WS
else
    reply=input(['File ' filename ' not found in current directory.' ...
        'Do you want to download it?(y/n)[y]:'],'s');
    if isempty(reply) || lower(reply) == 'y'
        %Attempt to download file;
        disp('Downloading file...');
        if exist('w7arwa','file')==2,delete('w7arwa');end
        gunzip(URL);
        if strcmp(TableType,'tcsm'), movefile('w7arwa','groundstates.dat'); end
        isTableInCurrentDirectory=exist(filename,'file')==2;
        assert(isTableInCurrentDirectory, ...
            ['File ' filename ' could not be downloaded from ' URL '. Check your internet'...
            ' connection and try again or place manually the files '...
            'in the current directory']);
        disp('File downloaded.');
        table = loadTable(TableType,filename,URL);
    else
        error(['Data file not found. Please try to download it or place '...
            'the required file(' filename ') in the current directory']);
    end
end
end

function []=betaDecay(Z,A,Q)
m0_c2=510.998910;
alpha=1/137.03;
syms Z A epsilon;
gama=sqrt(1-alpha^2*Z.^2);
V0=1.81*alpha^2*Z.^(4/3);
epsilon=0:Q/100:Q;
E=1+epsilon/m0_c2;
% E2=1+(epsilon-V0)/m0_c2
p=sqrt(E.^2-1);
% p2=sqrt(E.^2-1);
R=1.2*A.^(1/3)*m0_c2/1000/299.792458/0.65821188926;
% hi=1.00325-3.32726e-4*Z-4.30736e-7*Z.^2+(3.11742e-6-3.12695e-7*Z-3.57783e-9*Z.^2).*epsilon;
% Zf=Z+1;
% F0=2*(gama+1)*(2*p*R)^(2*(gama-1))*exp(pi*alpha*Zf*E/p)*abs(gamma(gama+I*alpha*Zf*E/p)).^2./gamma(2*gama+1).^2;
% F:=(epsilon,Z,Zf,A)->F0(epsilon-V0,Z,Zf,A)*hi(epsilon,Z)*p(epsilon-V0(Z))*E(epsilon-V0(Z))/p(epsilon)/E(epsilon):
% Fm:=(epsilon,Z,A)->F(epsilon,Z,Z+1,A);
%t1_2:=10^5.5/evalf[16](Int(Fm(e,Z0,A0)*E(e)*p(e)*(E(Q)-E(e))^2/m0_c2,,method=_Gquad));
end