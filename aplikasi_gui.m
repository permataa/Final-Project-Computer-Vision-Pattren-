function varargout = aplikasi_gui(varargin)
% APLIKASI_GUI MATLAB code for aplikasi_gui.fig
%      APLIKASI_GUI, by itself, creates a new APLIKASI_GUI or raises the existing
%      singleton*.
%
%      H = APLIKASI_GUI returns the handle to a new APLIKASI_GUI or the handle to
%      the existing singleton*.
%
%      APLIKASI_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APLIKASI_GUI.M with the given input arguments.
%
%      APLIKASI_GUI('Property','Value',...) creates a new APLIKASI_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before aplikasi_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to aplikasi_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help aplikasi_gui

% Last Modified by GUIDE v2.5 06-Jun-2023 08:37:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @aplikasi_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @aplikasi_gui_OutputFcn, ...
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

%background 


function aplikasi_gui_OpeningFcn(hObject, eventdata, handles)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to kelompokRozaqdll (see VARARGIN)

% Choose default command line output for kelompokRozaqdll
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%buat axes
ah= axes('unit', 'normalized', 'position', [0 0 1 1]);
%import background
bg = imread ('p.jpg'); imagesc(bg);
%matikan axes dan tampilkan background
set (ah,'handlevisibility', 'off','visible','off')

% --- Executes just before aplikasi_gui is made visible.
function PatternRecog(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to aplikasi_gui (see VARARGIN)

% Choose default command line output for aplikasi_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
movegui(hObject, 'center');

% UIWAIT makes aplikasi_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = aplikasi_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%memanggil menu browse file
[nama_file, nama_folder] = uigetfile('*.jpg');

%jika ada nama file yang dipilih maka akan mengeksekusi perintah dibawah
%ini
if~isequal(nama_file,0);
     %membaca file rgb
    Img = imread(fullfile(nama_folder,nama_file));
    %menampilkan citra rgb pada axes
    axes(handles.axes1)
    imshow(Img)
    title('Citra RGB')
    %menampilkan nama file pada edit text 
    set(handles.edit1,'String', nama_file)
    
    %menyimpan variabel Img pada lokasi handles agar dapat dipanggil oleh
    %pushbpotton yang lain
    handles.Img = Img;
    guidata(hObject,handles)
else 
    %jika tidak ada nama file yang dipilih maka akan kembali
    return
end
    

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%memanggil variabel Img yang ada d lokasi handles
Img = handles.Img;
 %mengkonversi citra rgb menjadi citra grayscale
    gr=graythresh(Img);%grayscale
    bw = im2bw(Img, gr);
%     figure, imshow(bw);
    %melakukan operasi komplemen
    bw = imcomplement(bw);
%     figure, imshow(bw)
%     melakukan operasi morfologi filling holes
    bw = imfill(bw,'holes');
    %menampilkan citra binner pada axes
    axes(handles.axes3)
    imshow(bw)
    title('Citra Biner')
    
    %menyimpan variabel bw pada lokasi handles agar dapat dipanggil oleh
    %pushbpotton yang lain
    handles.bw = bw;
    guidata(hObject,handles)
    



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, ~, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% memanggil variabel Img dan bw yang ada di lokasi handles
Img = handles.Img;
bw = handles.bw;

 %ekstrasi ciri 
    %melakukan konversi citra rgb ,enjadi citra hsv
    HSV = rgb2hsv(Img);
%     figure, imshow(HSV)
    % mengekstrak komponen h,s,v
    H = HSV(:,:,1); %Hue
    S = HSV(:,:,2); %Saturation
    V = HSV(:,:,3); %Value
    %mengubah nilai pixel background menjadi nol
    H(~bw) = 0;
    S(~bw) = 0;
    V(~bw) = 0;
%     figure, imshow(H)
%     figure, imshow(S)
%     figure, imshow(V)
    %menghitung nilai rata-rata h,s,v
    Hue = sum(sum(H))/sum(sum(bw));
    Saturation = sum(sum(S))/sum(sum(bw));
    Value = sum(sum(V))/sum(sum(bw));
    %menghitung luas objek
    Luas= sum (sum(bw));
    %mengisi variabel ciri_latih dengan ciri ekstraksi
    ciri_testing(1,1) = Hue;
    ciri_testing(1,2) = Saturation;
    ciri_testing(1,3) = Value;
    ciri_testing(1,4) = Luas;
    
    % menampilkan ciri hasil ekstraksi pada tabel 
    ciri_tabel = cell(4,2);
    ciri_tabel{1,1} = 'Hue';
    ciri_tabel{2,1} = 'Saturation';
    ciri_tabel{3,1} = 'Value';
    ciri_tabel{4,1} = 'Luas';
    ciri_tabel{1,2} = num2str(Hue);
    ciri_tabel{2,2} = num2str(Saturation);
    ciri_tabel{3,2} = num2str(Value);
    ciri_tabel{4,2} = num2str(Luas);
    set(handles.uitable1,'Data',ciri_tabel,'RowName',1:4);
    
    %menyimpan variabel ciri_testing pada lokasi handles agar dapat dipanggil oleh
    %pushbpotton yang lain
    handles.ciri_testing = ciri_testing;
    guidata(hObject,handles)

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%memanggil variabel cri uji yanga ada di lokasi hendles
ciri_testing = handles.ciri_testing;

%memanggil model naive bayes hasil training
 load Mdl
%membaca kelas keluaran hasil training
hasil_testing = predict(Mdl,ciri_testing);
% menampilkan kelas keluaran hasil training
set(handles.edit2,'String', hasil_testing(1))

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% mereset tampilan gui 
set(handles.edit1,'String',[])
set(handles.edit2,'String',[])

axes(handles.axes1)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes3)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

set(handles.uitable1,'Data',[], 'RowName',{'' '' '' ''})




function edit1_Callback(hObject, eventdata, ~)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','black');
end



function edit2_Callback(~, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
