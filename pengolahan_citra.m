clc;
clear;
close all;
warning off all;

%memanggil menu browse file
[nama_file, nama_folder] = uigetfile('*.jpg');

%jika ada nama file yang dipilih maka akan mengeksekusi perintah dibawah
%ini
if~isequal(nama_file,0);
     %membaca file rgb
    Img = imread(fullfile(nama_folder,nama_file));
    %figure, imshow(Img)
    %mengkonversi citra rgb menjadi citra grayscale
    gr=graythresh(Img);%grayscale
    bw = im2bw(Img, gr);
%     figure, imshow(bw);
    %melakukan operasi komplemen
    bw = imcomplement(bw);
%     figure, imshow(bw)
%     melakukan operasi morfologi filling holes
    bw = imfill(bw,'holes');
%     figure, imshow(bw)
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
    
 %memanggil model naive bayes hasil training
 load Mdl
%membaca kelas keluaran hasil training
hasil_testing = predict(Mdl,ciri_testing);

%menampilkan citra asli dan kelas keluaran hasil training
figure, imshow(Img)
title({['Nama file: ', nama_file], ['Kelas keluaran:', hasil_testing{1}]})
else 
    %jika tidak ada nama file yang dipilih maka akan kembali
    return
end
