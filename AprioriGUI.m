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

% Last Modified by GUIDE v2.5 03-May-2018 09:47:41

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
[filename, pathname, filterindex] = uigetfile({'*.csv'}, '请选择训练集');
%global fileName;
if ~isequal(filterindex, 0)
    fileName = fullfile(pathname, filename);
    set(handles.trainName, 'string', fileName);
    fid = fopen(fileName);
    train = textscan(fid, '%f %f %f %s', 'HeaderLines', 1, 'Delimiter', ',');
    fclose(fid);
    global time;
    global value;
    global label;
    time = train{1, 1};
    value = train{1, 2};
    label = train{1, 3};
    id = train{1, 4};
    global ids;
    global len;
    global lenID;
    len = length(time);
    [ids, ia] = unique(id);
    sortIa = sort(ia);
    lenID = length(ids);
    global idIndex;
    idIndex = zeros(lenID, 2);
    for i = 1 : lenID
        idIndex(i, 1) = ia(i, 1);
        temp = find(sortIa == ia(i, 1));
        if temp == 26
            idIndex(i, 2) = len;
        else
            idIndex(i, 2) = sortIa(temp + 1, 1) - 1;
        end
        i = i + 1;
    end
    set(handles.IDPopup, 'string', ids);
    set(handles.testID, 'string', ids);
end


% --- Executes on button press in choiceTest.
function choiceTest_Callback(hObject, eventdata, handles)
% hObject    handle to choiceTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile({'*.csv'}, '请选择测试集');
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
global idIndex;
global time;
global value;
global label;
startX = idIndex(index, 1);
endX = idIndex(index, 2);
t = time(startX:endX, 1);
v = value(startX:endX, 1);
l = label(startX:endX, 1);
er = find(l == 1);
plot(handles.trainAxes, t,v,'b');
grid on;
text(handles.trainAxes, t(er),v(er),'*','color','r');

lenL = length(l);
lenEr = length(er);
pie(handles.proportionAxes, [lenEr, lenL], [0, 1]);

% if isequal(nowID, 'KPI ID')
%     helpdlg('请选择KPI ID', '提示');
% else 
%     for i = 2:len + 1
%         if flag == 0 && isequal(trainRaw{i, 4}, nowID)
%             startX = i;
%             flag = 1;
%         else if flag == 1 && (~isequal(trainRaw{i, 4}, nowID) || i == len + 1)
%                 endX = i - 1;
%                 break;
%             end
%         end
%     end
%   startX = startX - 1;
%   endX = endX - 1;

           

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


% --- Executes on selection change in testID.
function testID_Callback(hObject, eventdata, handles)
% hObject    handle to testID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns testID contents as cell array
%        contents{get(hObject,'Value')} returns selected item from testID


% --- Executes during object creation, after setting all properties.
function testID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function trainbutton_Callback(hObject, eventdata, handles)
% hObject    handle to trainbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = get(handles.testID, 'Value');
global idIndex;
global time;
global value;
global label;
startX = idIndex(index, 1);
endX = idIndex(index, 2);
mid = floor(0.8 * (endX - startX) + startX);
trainTime = time(startX:mid, 1);
testTime = time(mid + 1:endX, 1);
trainValue = value(startX:mid, 1);
testValue = value(mid + 1:endX, 1);
trainLabel = label(startX:mid, 1);
testLabel = label(mid + 1:endX, 1);
er = find(trainLabel == 1);
lenTest = length(testTime);
lenEr = length(er);
predictLabel = zeros(lenTest, 1);
erArray = [];
erIndex = 1;
for i = 2:lenEr
    if i == 2
        erArray(erIndex, 1) = er(1, 1);
    else if er(i, 1) ~= er(i - 1, 1) + 1
            erArray(erIndex, 2) = er(i - 1, 1);
            erIndex = erIndex + 1;
            erArray(erIndex, 1) = er(i, 1);
        end
    end
end
erArray(erIndex, 2) = er(lenEr, 1);
indexLen = length(erArray(:, 1));
for i = 1 : indexLen
    nowStart = erArray(i, 1);
    nowEnd = erArray(i, 2);
    if nowEnd - nowStart < 5
        continue;
    end
    erValue = trainValue(nowStart:nowEnd, 1);
    erValue = erValue';
    lenValue = length(erValue);
    for k = 1:lenTest - lenValue
        endTest = k + lenValue - 1;
        tValue = testValue(k : endTest, 1)';
        y = [erValue; tValue];
        [m,n]=size(y);
        y1=mean(y');%对每一项指标求均值
        y1=y1';%转置为一列
        for s=1:m
            for x=1:n
                y2(s,x)=y(s,x)/y1(s);
            end
        end   %均值化变换
        for s=2:m
            for x=1:n
                y3(s-1,x)=abs(y2(s,x)-y2((s-1) ,x));
            end
        end   %差序列,其中元素均大于0小于1
        a=1;b=0;
        for s=1:m-1
            for x=1:n
                if(y3(s,x)<=a)
                    a=y3(s,x);%a为最小值
                elseif(y3(s,x)>=b)
                    b=y3(s,x);%b为最大值
                end
            end
        end
        for s=1:m-1
            for x=1:n
                y4(s,x)=(a+0.5*b)/(y3(s,x)+0.5*b);
            end
        end
        y5=sum(y4')/(n-1)
        if y5(1, 1) > 0.8
            predictLabel(k : endTest, 1) = 1;
        end
    end
end

%global ids;
% nowID = ids{1, index};
% if isequal(nowID, 'KPI ID')
%     hepldlg('请选择KPI ID', '提示');
% else
%     global trainNum;
%     global IDIndex;
%     startX = IDIndex(index - 1, 1);
%     endX = IDIndex(index - 1, 2);
%     mid = floor(0.8 * (endX - startX)) + startX;
%     trainTime = trainNum(startX : mid, 1);
%     testTime = trainNum(mid + 1 : endX, 1);
%     trainValue = trainNum(startX : mid, 2);
%     testValue = trainNum(mid + 1: endX, 2);
%     trainLabel = trainNum(startX : mid, 3);
%     testLabel = trainNum(mid + 1: endX, 3);
% %     trainDay = trainNum(startX : mid, 5);
% %     testDay = trainNum(mid + 1 : endX, 5);
% %     trainHour = trainNum(startX : mid, 6);
% %     testHour = trainNum(mid + 1 : endX, 6);
%     p = find(trainLabel == 1);
%     t = find(trainLabel == 0);
%     tNum = trainNum(t);
%     testLen = length(testTime);
%     trainLen = length(trainTime);
%     predictLabel = zeros(testLen, 1);
%
%     %Apriori算法进行异常挖掘
%     findexs = [];
%     findex = 1;
%     pLen = length(p);
%     tLen = length(t);
%     for i = 1 : pLen
%         sup = find(tNum == trainNum(i, 1)) / trainLen;
%         if sup < 0.15
%             findexs(findex) = i;
%             findex = findex + 1;
%         end
%     end
%     for i = 1 : length(findexs)
%        for j = 1 : testLen
%            if trainValue(i, 1) == testValue(j, 1) %roundn(trainValue(i, 1), -5) == roundn(testValue(j, 1), -5)
%                predictLabel(j, 1) = 1;
%            end
%         end
%     end

%按照24小时算出平均值和方差进行识别
%     for hour = 0 : 23
%         nowIndex = find(trainHour == hour);
%         nowMean = mean(trainValue(nowIndex));
%         nowStd = std(trainValue(nowIndex));
%         max = nowMean + nowStd;
%         min = nowMean - nowStd;
%         for i = 1 : testLen
%             if ((testHour(i, 1) == hour) && (testValue(i, 1) > max || testValue(i, 1) < min))
%                 predictLabel(i, 1) = 1;
%             end
%         end
%     end

tp = 0;
fp = 0;
fn = 0;
for i = 1 : lenTest
    if testLabel(i, 1) == 0
        if predictLabel(i, 1) == 1
            fp = fp + 1;
        end
    else
        if predictLabel(i, 1) == 1
            tp = tp + 1;
        else
            fn = fn + 1;
        end
    end
end
precision = tp / (tp + fp);
recall = tp / (tp + fn);
score = (2 * precision * recall) / (precision + recall);
set(handles.precision, 'string', ['精确度：', num2str(precision)]);
set(handles.recall, 'string', ['召回率：', num2str(recall)]);
set(handles.score, 'string', ['F-Score：', num2str(score)]);

er = find(testLabel == 1);
plot(handles.axes5, testTime,testValue,'b');
grid on;
text(handles.axes5, testTime(er),testValue(er),'*','color','r');

er = find(predictLabel == 1);
plot(handles.axes6, testTime,testValue,'b');
grid on;
text(handles.axes6, testTime(er),testValue(er),'*','color','r');


% --- Executes during object creation, after setting all properties.
function uipanel2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function edit_Callback(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function tools_Callback(hObject, eventdata, handles)
% hObject    handle to tools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_11_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function saveImage_Callback(hObject, eventdata, handles)
% hObject    handle to saveImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function saveTest_Callback(hObject, eventdata, handles)
% hObject    handle to saveTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function clearData_Callback(hObject, eventdata, handles)
% hObject    handle to clearData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear;
clc;
close all;

% --------------------------------------------------------------------
function color_Callback(hObject, eventdata, handles)
% hObject    handle to color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function big_Callback(hObject, eventdata, handles)
% hObject    handle to big (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function small_Callback(hObject, eventdata, handles)
% hObject    handle to small (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function train_Callback(hObject, eventdata, handles)
% hObject    handle to train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile({'*.csv'}, '请选择训练集');
%global fileName;
if ~isequal(filterindex, 0)
    fileName = fullfile(pathname, filename);
    set(handles.trainName, 'string', fileName);
    fid = fopen(fileName);
    train = textscan(fid, '%f %f %f %s', 'HeaderLines', 1, 'Delimiter', ',');
    fclose(fid);
    global time;
    global value;
    global label;
    time = train{1, 1};
    value = train{1, 2};
    label = train{1, 3};
    id = train{1, 4};
    global ids;
    global len;
    global lenID;
    len = length(time);
    [ids, ia] = unique(id);
    sortIa = sort(ia);
    lenID = length(ids);
    global idIndex;
    idIndex = zeros(lenID, 2);
    for i = 1 : lenID
        idIndex(i, 1) = ia(i, 1);
        temp = find(sortIa == ia(i, 1));
        if temp == 26
            idIndex(i, 2) = len;
        else
            idIndex(i, 2) = sortIa(temp + 1, 1) - 1;
        end
        i = i + 1;
    end
    set(handles.IDPopup, 'string', ids);
    set(handles.testID, 'string', ids);
end



% --------------------------------------------------------------------
function test_Callback(hObject, eventdata, handles)
% hObject    handle to test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile({'*.csv'}, '请选择测试集');
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


% --------------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes during object creation, after setting all properties.
function axes5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes5
title('测试集检测结果');


% --- Executes during object creation, after setting all properties.
function axes6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes6
title('测试集原结果');


% --- Executes during object creation, after setting all properties.
function uibuttongroup4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function Untitled_15_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = zoom;
setAxesZoomMotion(h, handles.trainAxes, 'both');
zoom on;
set(h, 'direction', 'out');


% --------------------------------------------------------------------
function Untitled_16_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = zoom;
setAxesZoomMotion(h, handles.axes5, 'both');
zoom on;
set(h, 'direction', 'out');


% --------------------------------------------------------------------
function Untitled_17_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = zoom;
setAxesZoomMotion(h, handles.axes6, 'both');
zoom on;
set(h, 'direction', 'out');


% --------------------------------------------------------------------
function Untitled_12_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = zoom;
setAxesZoomMotion(h, handles.trainAxes, 'both');
zoom on
set(h, 'direction', 'in');



% --------------------------------------------------------------------
function Untitled_13_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = zoom;
setAxesZoomMotion(h, handles.axes5, 'both');
zoom on
set(h, 'direction', 'in');


% --------------------------------------------------------------------
function Untitled_14_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = zoom;
setAxesZoomMotion(h, handles.axes6, 'both');
zoom on
set(h, 'direction', 'in');
