clc;
clear;
close all;
warning off all;

%penetapan nama folder
nama_folder = 'Data Testing';
%membaca nama file yang berekstensi .jpg
nama_file = dir(fullfile(nama_folder,'*.jpg'));
%membaca jumlah file yang berekstensi .jpg
jumlah_file = numel(nama_file);

%inisialisasi variabel Data_Training
ciri_testing = zeros(jumlah_file,4);

%melakukan pengolahan citra terhadap seluruh file 
for k = 1:jumlah_file
    %membaca file rgb
    Img = imread(fullfile(nama_folder,nama_file(k).name));
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
    ciri_testing(k,1) = Hue;
    ciri_testing(k,2) = Saturation;
    ciri_testing(k,3) = Value;
    ciri_testing(k,4) = Luas;
end

%menetapkan kelas_testing
kelas_testing = cell(jumlah_file, 1);
for k = 1:5
    kelas_testing{k} = 'jahit';%img jahit
end

for k = 6:10
    kelas_testing{k} = 'peniti';%img peniti
end

for k = 11:15
    kelas_testing{k} = 'pentul';%img pentul
end


%memanggil model naive bayes,knn, tree,discriminant hasil training
 load Mdl
%membaca kelas keluaran hasil training
hasil_testing = predict(Mdl,ciri_testing);

%menghitung akurasi testing
jumlah_benar = 0;
for k = 1:jumlah_file
    if isequal(hasil_testing{k}, kelas_testing{k})
        jumlah_benar = jumlah_benar+1;
    end
end

akurasi_testing = jumlah_benar/jumlah_file*100




