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
handles.comPort = 'COM13';
handles.bufferlength = 200;
%handles.magrawdata = zeros(handles.bufferlength,1);
handles.index = 1:handles.bufferlength; % 1 to upto 200 increment by one
handles.alpha = 0.5;

handles.magraw_dx = zeros(handles.bufferlength,1);
handles.magraw_dy = zeros(handles.bufferlength,1);
handles.magraw_dz = zeros(handles.bufferlength,1);

handles.magfil_dx = zeros(handles.bufferlength,1);
handles.magfil_dy = zeros(handles.bufferlength,1);
handles.magfil_dz = zeros(handles.bufferlength,1);

%handles.magfiltdata = zeros(handles.bufferlength,1);
G = SpriteKit.Game.instance('Title','Galaxy','Size',[800 400]);
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
handles.calco = calibrate(handles.accelerometer.s);
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
%guidata(hObject,handles);




function timer(hObject,eventdata,handles)

% This function draws and update the plot

%contents{get(hObject,'Value')}
if get(handles.start,'UserData')
    
    G = SpriteKit.Game.instance('Title','Galaxy','Size',[800 400]);
    bkg = SpriteKit.Background('img/galaxy.png');
    bkg.Scale = 1.8;
    addBorders(G);

    scale_1 = 1.2;
    scale_2 = 0.4;

    % spaceship 
    s = SpriteKit.Sprite('ship');
    s.initState('roaming','img/space.png',true);
    s.initState('explosion','img/explosion.png',true);
    s.Scale = scale_1;
    s.Location = [50 300];
    s.State = 'roaming';

    % meteorite sprites

    a = SpriteKit.Sprite('a');
    a.initState('on','img/meteorite.png',true);
    a.initState('explosion','img/explosion.png',true);
    a.Location = [randi([25 G.Size(1)-25]) randi([25 G.Size(2)-25])];
    a.Scale = scale_1;
    a.State = 'on';

    b = SpriteKit.Sprite('b');
    b.initState('on','img/meteorite.png',true);
    b.initState('explosion','img/explosion.png',true);
    b.Location = [randi([25 G.Size(1)-25]) randi([25 G.Size(2)-25])];
    b.Scale = scale_1;
    b.State = 'on';

    c = SpriteKit.Sprite('c');
    c.initState('on','img/meteorite.png',true);
    c.initState('explosion','img/explosion.png',true);
    c.Location = [randi([25 G.Size(1)-25]) randi([25 G.Size(2)-25])];
    c.Scale = scale_1;
    c.State = 'on';

    d = SpriteKit.Sprite('d');
    d.initState('on','img/meteorite.png',true);
    d.initState('explosion','img/explosion.png',true);
    d.Location = [randi([25 G.Size(1)-25]) randi([25 G.Size(2)-25])];
    d.Scale = scale_1;
    d.State = 'on';

    e = SpriteKit.Sprite('e');
    e.initState('on','img/meteorite.png',true);
    e.initState('explosion','img/explosion.png',true);
    e.Location = [randi([25 G.Size(1)-25]) randi([25 G.Size(2)-25])];
    e.Scale = scale_1;
    e.State = 'on';


    addprop(s,'accel');
    s.accel = [0 0];
    
else
    % spriteKit.delete(G);
    
end

% Run while the button string reads 'Stop'

    while (get(handles.start,'UserData'))

    % Read accel data
    %  [gx gy gz]= readAcc(handles.accelerometer,handles.calco);
    %  % Calculate magnitude from raw data
    %  rawmag = sqrt(gx^2+gy^2+gz^2);

    %  
    %  % update the vectors with raw data
    %  handles.magraw_dx = [handles.magraw_dx(2:end);gx];
    %  handles.magraw_dy = [handles.magraw_dy(2:end);gy];
    %  handles.magraw_dz = [handles.magraw_dz(2:end);gz];
    %  
    %  % setup the filters  
    %  filtmag_dx = (1 - handles.alpha)*handles.magfil_dx(end) + handles.alpha*rawmag;
    %  filtmag_dy = (1 - handles.alpha)*handles.magfil_dy(end) + handles.alpha*rawmag;
    %  filtmag_dz = (1 - handles.alpha)*handles.magfil_dz(end) + handles.alpha*rawmag;
    %      
    %  % Calculate filtered magnitude
    %  handles.magfil_dx = [handles.magfil_dx(2:end); filtmag_dx];
    %  handles.magfil_dy = [handles.magfil_dy(2:end); filtmag_dy];
    %  handles.magfil_dz = [handles.magfil_dz(2:end); filtmag_dz];
    % 
    %  % Put new filtered data on end of vector and shift old data up 1 spot
    %  plot(handles.index,handles.magfil_dx,'b'); %,handles.index,handles.magfil_dy,'k');
    %  % Plot raw and filtered data
    % 
    %  %legend('raw data','filtered data');
    %  axis([0 handles.bufferlength -1 10]);
     % Set axis limits
     
     %% game controlls
     
         
     s.accel = s.accel*0.97;
     L = s.Location;
     L = L + s.accel;
     s.Location = L;

     a.Angle = a.Angle-1;
     b.Angle = b.Angle-1;
     c.Angle = c.Angle-1;
     d.Angle = d.Angle-1;
     e.Angle = e.Angle-1;

     bkg.scroll('right',1);

     a.Location(1) = a.Location(1)-1;
     b.Location(1) = b.Location(1)-1;
     c.Location(1) = c.Location(1)-1;
     d.Location(1) = d.Location(1)-1;
     e.Location(1) = e.Location(1)-1;
     
     if a.Location(1) < 0
        a.Location = [randi([25 G.Size(2)-35])+650 randi([G.Size(1)-100])];
        a.State = 'on';
        a.Scale = scale_1;
    elseif b.Location(1) < 0
        b.Location = [randi([25 G.Size(2)-35])+650 randi([G.Size(1)-100])];           
        b.State = 'on';
        b.Scale = scale_1;
    else
    end
        
    if c.Location(1) < 0                
        c.Location = [randi([25 G.Size(2)-35])+650 randi([G.Size(1)-100])];
        c.State = 'on';
        c.Scale = scale_1;
    elseif d.Location(1) < 0
        d.Location = [randi([25 G.Size(2)-35])+650 randi([G.Size(1)-100])];
        d.State = 'on';
        d.Scale = scale_1;
    else            
    end
    if e.Location(1) < 0
        e.Location = [randi([25 G.Size(2)-35])+650 randi([G.Size(1)-100])];
        e.State = 'on';
        e.Scale = scale_1;
     end
     
     drawnow % Force redraw of figure
     guidata(hObject, handles);
    end
