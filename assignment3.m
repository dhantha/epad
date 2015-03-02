function varargout = assignment3(varargin)
% ASSIGNMENT3 MATLAB code for assignment3.fig
%      ASSIGNMENT3, by itself, creates a new ASSIGNMENT3 or raises the existing
%      singleton*.
%
%      H = ASSIGNMENT3 returns the handle to a new ASSIGNMENT3 or the handle to
%      the existing singleton*.
%
%      ASSIGNMENT3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASSIGNMENT3.M with the given input arguments.
%
%      ASSIGNMENT3('Property','Value',...) creates a new ASSIGNMENT3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before assignment3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to assignment3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help assignment3

% Last Modified by GUIDE v2.5 13-Feb-2015 13:31:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @assignment3_OpeningFcn, ...
                   'gui_OutputFcn',  @assignment3_OutputFcn, ...
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


% --- Executes just before assignment3 is made visible.
function assignment3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to assignment3 (see VARARGIN)

% Choose default command line output for assignment3
handles.output = hObject;
handles.comPort = 'COM11';
handles.bufferlength = 200;
handles.magrawdata = zeros(handles.bufferlength,1);
handles.index = 1:handles.bufferlength; % 1 to upto 200 increment by one
handles.alpha = 0.5;
% set(handles.alphadisp,'String',['Alpha = 'num2str(handles.alpha)]);
handles.magfiltdata = zeros(handles.bufferlength,1);

handles.tap=2;
%set(handles.smatap,'String',['SMA Taps = ' num2str(handles.tap)]);
handles.threshvalue=1;
handles.threshplot=handles.threshvalue*ones(handles.bufferlength,1);
handles.threshnum=0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes assignment3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = assignment3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in serialSetup.
function serialSetup_Callback(hObject, eventdata, handles)
% hObject    handle to serialSetup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (~exist('handles.serialFlag','var'))
 [handles.accelerometer.s, handles.serialFlag]=setupSerial(handles.comPort);
end
guidata(hObject, handles);
handles.calco=calibrate(handles.accelerometer.s);
guidata(hObject, handles);



% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.start,'UserData',1); % set to on 
set(handles.stop,'UserData',0);
timer(hObject, eventdata, handles);
guidata(hObject,handles);

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.start,'UserData',0);
set(handles.stop,'UserData',1);
timer(hObject, eventdata, handles);
guidata(hObject,handles);


% --- Executes on button press in Close.
function Close_Callback(hObject, eventdata, handles)
% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.start,'UserData',0);
set(handles.stop,'UserData',1);
closeSerial


% --- Executes on selection change in filter.
function filter_Callback(hObject, eventdata, handles)
% hObject    handle to filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filter contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filter


% --- Executes during object creation, after setting all properties.
function filter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in popupmenu.
function popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu


% --- Executes during object creation, after setting all properties.
function popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function thresh_Callback(hObject, eventdata, handles)
% hObject    handle to thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresh as text
%        str2double(get(hObject,'String')) returns contents of thresh as a double


% --- Executes during object creation, after setting all properties.
function thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in threshVal.
function threshVal_Callback(hObject, eventdata, handles)
% hObject    handle to threshVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns threshVal contents as cell array
%        contents{get(hObject,'Value')} returns selected item from threshVal


% --- Executes during object creation, after setting all properties.
function threshVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function timer(hObject,eventdata,handles)

% This function draws and update the plot

%contents{get(hObject,'Value')}
axes(handles.axes1)
% Run while the button string reads 'Stop'
while (get(handles.start,'UserData'))
 [gx gy gz]= readAcc(handles.accelerometer,handles.calco);
 % Read accelerometer data
 rawmag = sqrt(gx^2+gy^2+gz^2);
 % Calculate magnitude from raw data
 handles.magrawdata = [handles.magrawdata(2:end);rawmag];
 % Put new raw data on end of vector and shift old data up 1 spot
 
 contents = get(handles.filter,'String'); 

 % let the user select the filter 
 if (strcmp(contents{get(handles.filter,'Value')},'Alpha Filter'));
      % gets the alpha value from the user 
     % a = handles.magfiltdata(end)
     % contents = get(handles.popupmenu,'String');
     % if it a alpha filter set the alpha value choose by ht user
     alpha = get(handles.popupmenu,'Value');
     switch alpha
         case 2
             alpha = 0.1;
         case 3
             alpha = 0.2;
         case 4
             alpha = 0.3;
         case 5
             alpha = 0.4;
         case 6
             alpha = 0.5;
         case 7
             alpha = 0.6;
         case 8
             alpha = 0.7;
         case 9
             alpha = 0.8;
         case 10
             alpha = 0.9;
         case 11
             alpha = 1;
     end
            
     filtmag =  (1 - alpha)*handles.magfiltdata(end) + alpha*rawmag; 
     % Calculate filtered magnitude
     handles.magfiltdata = [handles.magfiltdata(2:end); filtmag];
     % Put new filtered data on end of vector and shift old data up 1 spot
     plot(handles.index,handles.magrawdata,'b',handles.index,handles.magfiltdata,'k');
     % Plot raw and filtered data
 else
     % if it's a SMA filter let the user choose the threshold parameters 
     filtmag = mean(handles.magrawdata(end-handles.tap+1:end));
     handles.magfiltdata = [handles.magfiltdata(2:end); filtmag];
     handles.threshvalue = get(handles.threshVal,'Value')-1;
     handles.threshplot = handles.threshvalue*ones(handles.bufferlength,1);
     if filtmag > handles.threshvalue && ...
         handles.magfiltdata(end-1)<handles.threshvalue
         handles.threshnum=handles.threshnum+1;
         set(handles.thresh,'String',['Threshold Count =' ...
         num2str(handles.threshnum)])
     end
     % Put new filtered data on end of vector and shift old data up 1 spot
     plot(handles.index,handles.magrawdata,'b',handles.index,handles.magfiltdata,'k',...
     handles.index,handles.threshplot,'g');
 
 
 end
 %legend('raw data','filtered data');
 axis([0 handles.bufferlength -1 10]);
 % Set axis limits
 drawnow % Force redraw of figure
 guidata(hObject, handles);
end
