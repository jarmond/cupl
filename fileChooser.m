function varargout = fileChooser(varargin)
% FILECHOOSER MATLAB code for fileChooser.fig
%      FILECHOOSER, by itself, creates a new FILECHOOSER or raises the existing
%      singleton*.
%
%      H = FILECHOOSER returns the handle to a new FILECHOOSER or the handle to
%      the existing singleton*.
%
%      FILECHOOSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILECHOOSER.M with the given input arguments.
%
%      FILECHOOSER('Property','Value',...) creates a new FILECHOOSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fileChooser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fileChooser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fileChooser

% Last Copyright (c) 2013 GUIDE v2.5 02-Mar-2012 19:35:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fileChooser_OpeningFcn, ...
                   'gui_OutputFcn',  @fileChooser_OutputFcn, ...
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


% --- Executes just before fileChooser is made visible.
function fileChooser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fileChooser (see VARARGIN)
handles.fileNames=varargin{1};

set(handles.lbFiles,'String',handles.fileNames,'Max',length(handles.fileNames),'Min',0);
set(handles.lbSelected,'String',{},'Max',length(handles.fileNames),'Min',0);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fileChooser wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fileChooser_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles)
    % Closed by close button.
    varargout{1} = [];
else
    % Closed by done button.
    varargout{1} = get(handles.lbSelected,'String');
    delete(hObject);
end

% --- Executes on selection change in lbFiles.
function lbFiles_Callback(hObject, eventdata, handles)
% hObject    handle to lbFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lbFiles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbFiles


% --- Executes during object creation, after setting all properties.
function lbFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lbSelected.
function lbSelected_Callback(hObject, eventdata, handles)
% hObject    handle to lbSelected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lbSelected contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbSelected


% --- Executes during object creation, after setting all properties.
function lbSelected_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbSelected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnDone.
function btnDone_Callback(hObject, eventdata, handles)
% hObject    handle to btnDone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume(handles.figure1);

% --- Executes on button press in btnRight.
function btnRight_Callback(hObject, eventdata, handles)
% hObject    handle to btnRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

alreadySelected = cellstr(get(handles.lbSelected,'String'));
available = cellstr(get(handles.lbFiles,'String'));
newSelected = get(handles.lbFiles,'Value');

% Add to right box
set(handles.lbSelected,'Value',1,'String',[alreadySelected; available(newSelected)]);

% Remove from left box
set(handles.lbFiles,'Value',1,'String',available(setdiff(1:length(available),newSelected)));

handles.selected = get(handles.lbSelected,'String');
guidata(hObject,handles);

% --- Executes on button press in btnLeft.
function btnLeft_Callback(hObject, eventdata, handles)
% hObject    handle to btnLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

alreadySelected = cellstr(get(handles.lbFiles,'String'));
available = cellstr(get(handles.lbSelected,'String'));
newSelected = get(handles.lbSelected,'Value');

% Add to left box
set(handles.lbFiles,'Value',1,'String',[alreadySelected; available(newSelected)]);

% Remove from right box
set(handles.lbSelected,'Value',1,'String',available(setdiff(1:length(available),newSelected)));

handles.selected = get(handles.lbSelected,'String');
guidata(hObject,handles);
