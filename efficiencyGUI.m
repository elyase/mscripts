function varargout = efficiencyGUI(varargin)
% EFFICIENCYGUI MATLAB code for efficiencyGUI.fig
%      EFFICIENCYGUI, by itself, creates a new EFFICIENCYGUI or raises the existing
%      singleton*.
%
%      H = EFFICIENCYGUI returns the handle to a new EFFICIENCYGUI or the handle to
%      the existing singleton*.
%
%      EFFICIENCYGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EFFICIENCYGUI.M with the given input arguments.
%
%      EFFICIENCYGUI('Property','Value',...) creates a new EFFICIENCYGUI or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before efficiencyGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to efficiencyGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help efficiencyGUI

% Last Modified by GUIDE v2.5 30-May-2011 14:18:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @efficiencyGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @efficiencyGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before efficiencyGUI is made visible.
function efficiencyGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to efficiencyGUI (see VARARGIN)

% Choose default command line output for efficiencyGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes efficiencyGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = efficiencyGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function efficiency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to energy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function height_Callback(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of height as text
%        str2double(get(hObject,'String')) returns contents of height as a double
height = str2double(get(hObject, 'String'));
if isnan(height)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new height value
handles.metricdata.height = height;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function energy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to energy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function energy_Callback(hObject, eventdata, handles)
% hObject    handle to energy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of energy as text
%        str2double(get(hObject,'String')) returns contents of energy as a double
energy = str2double(get(hObject, 'String'));
if isnan(energy)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new energy value
handles.metricdata.energy = energy;
guidata(hObject,handles)


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(gcbf, handles, true);

% --- Executes when selected object changed in unitgroup.
function unitgroup_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in unitgroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if (hObject == handles.english)
%     set(handles.text4, 'String', 'lb/cu.in');
%     set(handles.text5, 'String', 'cu.in');
%     set(handles.text6, 'String', 'lb');
% else
%     set(handles.text4, 'String', 'kg/cu.m');
%     set(handles.text5, 'String', 'cu.m');
%     set(handles.text6, 'String', 'kg');
% end

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

handles.metricdata.height = 20;
handles.metricdata.energy  = 80;

set(handles.height, 'String', handles.metricdata.height);
set(handles.energy,  'String', handles.metricdata.energy);
set(handles.efficiency, 'String', 0);

set(handles.unitgroup, 'SelectedObject', handles.english);

set(handles.text4, 'String', 'cm');
set(handles.text5, 'String', 'keV');
set(handles.text6, 'String', '');

% Update handles structure
guidata(handles.figure1, handles);



% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
E=handles.metricdata.energy;               %energy in keV

%% Geometry definition
a=2.75;                                    %Crystal radio in cm 
b=5.4;                                     %Crystal length in cm(height) 
d=0.07;                                    %Thickness of the detector cover in cm(aluminium)
h=handles.metricdata.height;               %Distance crystal-source

%% Auxiliary functions
theta1=atan(a/(b+h));
theta2=atan(a/h);

%% Material properties
mu = 138.8*exp(-E/21.87)+1.636*exp(-E/365.8);
tau= 0.107002+5.323*exp(-E/20.36)+0.3192*exp(-E/526.9);

%% Efficiency
f1=@(x) (1-exp(-mu*b./cos(x))).*exp(-tau*d./cos(x)).*sin(x);
f2=@(x) (1-exp(mu*h./cos(x)-mu*a./sin(x))).*exp(-tau*d./cos(x)).*sin(x);
epsilon=0.5*(quad(f1,0,theta1)+quad(f2,theta1,theta2));
set(handles.efficiency, 'String', epsilon);







