clc;
clear;
close all;
warning off all;

%penetapan nama folder
nama_folder = 'Data Training';
%membaca nama file yang berekstensi .jpg
nama_file = dir(fullfile(nama_folder,'*.jpg'));
%membaca jumlah file yang berekstensi .jpg
jumlah_file = numel(nama_file);

%inisialisasi variabel Data_Training
ciri_training = zeros(jumlah_file,4);

%melakukan pengolahan citra terhadap seluruh file 
for k = 1:jumlah_file
    %membaca file rgb
    Img = imread(fullfile(nama_folder,nama_file(k).name));
%      figure, imshow(Img)
%     title('citra asli')
    %mengkonversi citra rgb menjadi citra grayscale
    gr=graythresh(Img);%grayscale otsu thresholding
    bw = im2bw(Img, gr);
%figure, imshow(bw);
    %melakukan operasi komplemen
    bw = imcomplement(bw);
% figure, imshow(bw)
%     melakukan operasi morfologi filling holes
    bw = imfill(bw,'holes');
%      figure, imshow(bw)
    %ekstrasi ciri 
    %melakukan konversi citra rgb ,enjadi citra hsv
    HSV = rgb2hsv(Img);
% figure, imshow(HSV)
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
    ciri_training(k,1) = Hue;
    ciri_training(k,2) = Saturation;
    ciri_training(k,3) = Value;
    ciri_training(k,4) = Luas;
end

%menetapkan kelas_training
kelas_training = cell(jumlah_file, 1);
for k = 1:15
    kelas_training{k} = 'jahit';%img jahit
end

for k = 16:30
    kelas_training{k} = 'peniti';%img peniti
end

for k = 31:45
    kelas_training{k} = 'pentul';%img pentul
end


%klasifikasi citra menggunakan algoritma naive bayes,knn, tree,
%discriminant
% Mdl = NaiveBayes.fit(ciri_training, kelas_training);
% Mdl = ClassificationKNN.fit(ciri_training, kelas_training);
% Mdl = ClassificationTree.fit(ciri_training, kelas_training);
Mdl = ClassificationDiscriminant.fit(ciri_training, kelas_training);

 
%membaca kelas keluaran hasil training
hasil_training = predict(Mdl,ciri_training);

%menghitung akurasi training
jumlah_benar = 0;
for k = 1:jumlah_file
    if isequal(hasil_training{k}, kelas_training{k})
        jumlah_benar = jumlah_benar+1;
    end
end

akurasi_training = jumlah_benar/jumlah_file*100

%menyimpan model naive bayes
save Mdl Mdl


