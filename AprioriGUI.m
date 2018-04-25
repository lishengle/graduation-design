function varargout = AprioriGUI(varargin)
%global 
% APRIORIGUI MATLAB code for AprioriGUI.fig
%      APRIORIGUI, by itself, creates a new APRIORIGUI or raises the existing
%      singleton*.
%
%      H = APRIORIGUI returns the handle to a new APRIORIGUI or the handle to
%      the existing singleton*.
%
%      APRIORIGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APRIORIGUI.M with the given input arguments.
%
%      APRIORIGUI('Property','Value',...) creates a new APRIORIGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AprioriGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AprioriGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AprioriGUI

% Last Modified by GUIDE v2.5 12-Apr-2018 13:39:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AprioriGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @AprioriGUI_OutputFcn, ...
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


% --- Executes just before AprioriGUI is made visible.
function AprioriGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AprioriGUI (see VARARGIN)

% Choose default command line output for AprioriGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AprioriGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AprioriGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in choiceTrain.
function choiceTrain_Callback(hObject, eventdata, handles)
% hObject    handle to choiceTrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%global trainName;
%global trainPath;
[filename, pathname, filterindex] = uigetfile({'*.csv'; '*.xlsx'; '*.xls'}, '请选择训练集');
%global fileName;
if ~isequal(filterindex, 0)
    fileName = fullfile(pathname, filename);
    set(handles.trainName, 'string', fileName);
    global trainNum;
    global trainRaw;
    [trainNum, txt, trainRaw] = xlsread(fileName);
    if ~isequal(trainRaw{1, 1}, 'timestamp') && ~isequal(trainRaw{1, 2}, 'value') && ~isequal(trainRaw{1, 3}, 'label') && ~isequal(trainRaw{1, 4}, 'KPI ID')
        warndlg('训练集首行格式不正确，请重新选择', '警告', 'modal');
    else
        len = length(trainNum(:, 1));
        allID = trainRaw(2:len + 1, 4);
        global ids;
        ids = {};
        idLen = 0;
        for i = 1:8000:len + 1
            flag = 0;
            for j = 1:idLen
                if isequal(trainRaw(i, 4), ids(1, j))
                    flag = 1;
                    break;
                end
            end
            if ~flag
                ids(1, idLen + 1) = trainRaw(i, 4);
                idLen = idLen + 1;
            end
        end
        set(handles.IDPopup, 'string', ids);
    end
end


% --- Executes on button press in choiceTest.
function choiceTest_Callback(hObject, eventdata, handles)
% hObject    handle to choiceTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile({'*.csv'; '*.xlsx'; '*.xls'}, '请选择测试集');
if ~isequal(filterindex, 0)
    fileName = fullfile(pathname, filename);
    set(handles.testName, 'string', fileName);
    global testNum;
    global testRaw;
    [testNum, txt, testRaw] = xlsread(fileName);
    if ~isequal(testRaw{1, 1}, 'timestamp') && ~isequal(testRaw{1, 2}, 'value') && ~isequal(testRaw{1, 3}, 'label') && ~isequal(testRaw{1, 4}, 'KPI ID')
        warndlg('测试集首行格式不正确，请重新选择', '警告', 'modal');
    end
end


% --- Executes during object creation, after setting all properties.
function trainAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trainAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate trainAxes
title('训练集KPI');


% --- Executes during object creation, after setting all properties.
function proportionAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to proportionAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate proportionAxes
title('异常KPI比例');


% --- Executes on selection change in IDPopup.
function IDPopup_Callback(hObject, eventdata, handles)
% hObject    handle to IDPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns IDPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from IDPopup


% --- Executes during object creation, after setting all properties.
function IDPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IDPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in draw.
function draw_Callback(hObject, eventdata, handles)
% hObject    handle to draw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = get(handles.IDPopup, 'Value');
global ids;
nowID = ids{1, index};
global trainNum;
global trainRaw;
len = length(trainNum(:, 1));
startX = 0;
endX = 0;
flag = 0;
if isequal(nowID, 'KPI ID')
    helpdlg('请选择KPI ID', '提示');
else 
    for i = 2:len + 1
        if flag == 0 && isequal(trainRaw{i, 4}, nowID)
            startX = i;
            flag = 1;
        else if flag == 1 && (~isequal(trainRaw{i, 4}, nowID) || i == len + 1)
                endX = i - 1;
                break;
            end
        end
    end
    startX = startX - 1;
    endX = endX - 1;
    t = trainNum(startX:endX, 1);
    v = trainNum(startX:endX, 2);
    l = trainNum(startX:endX, 3);
    er = find(l == 1);
    plot(handles.trainAxes, t,v,'b');
    grid on;
    text(handles.trainAxes, t(er),v(er),'*','color','r');
    
    lenL = length(l);
    lenEr = length(er);
    pie(handles.proportionAxes, [lenEr, lenL], [0, 1]);
end
                

% --- Executes on button press in mean.
function mean_Callback(hObject, eventdata, handles)
% hObject    handle to mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mean


% --- Executes on button press in standard.
function standard_Callback(hObject, eventdata, handles)
% hObject    handle to standard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of standard


% --- Executes on button press in media.
function media_Callback(hObject, eventdata, handles)
% hObject    handle to media (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of media


% --- Executes on button press in mode.
function mode_Callback(hObject, eventdata, handles)
% hObject    handle to mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mode


% --- Executes on selection change in range.
function range_Callback(hObject, eventdata, handles)
% hObject    handle to range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns range contents as cell array
%        contents{get(hObject,'Value')} returns selected item from range


% --- Executes during object creation, after setting all properties.
function range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in trainbutton.
function trainbutton_Callback(hObject, eventdata, handles)
% hObject    handle to trainbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

