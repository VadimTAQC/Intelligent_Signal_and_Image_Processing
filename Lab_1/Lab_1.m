clear, close all

% 1.Завантаження зображень з бібліотеки MATLAB
image1 = imread('car.png');  % Завантажили зображення у форматі PNG
image2 = imread('nature.tif'); % Завантажили зображення у форматі TIFF
image3 = imread('ocean.jpg'); % Завантажили зображення у форматі JPG

% 2.Відображення зображень на екрані
figure;
subplot(1, 3, 1); imshow(image1);
title('car.png');
subplot(1,3,2); imshow(image2);
title('nature.tif');
subplot(1,3,3); imshow(image3);
title('ocean.jpg');

% 3.Вказуємо шлях до зображення, яке зберігається в довільному каталозі і
% відображуємо його
imagePath = 'C:\Users\Vadim\Documents\MATLAB\clouds.jpg';
image4 = imread(imagePath);
figure, imshow(image4), title('clouds.jpg');

% 4.Одержуємо інформацію про завантажені зображення

info1 = imfinfo('car.png');
info2 = imfinfo('nature.tif');
info3 = imfinfo('ocean.jpg');
info4 = imfinfo('clouds.jpg');

disp('Info - car.png:'); disp(info1);
disp('Info - nature.tif:'); disp(info2);
disp('Info - ocean.jpg:'); disp(info3);
disp('Info - clouds.jpg:'); disp(info4);

size_image1 = size(image1);
class_image1 = class(image1);
disp(['Розмір car.png: ', num2str(size_image1)]);
disp(['Тип даних car.png: ', class_image1]);

size_image2 = size(image2);
class_image2 = class(image2);
disp(['Розмір nature.tif: ', num2str(size_image2)]);
disp(['Тип даних nature.tif: ', class_image2]);

size_image3 = size(image3);
class_image3 = class(image3);
disp(['Розмір ocean.jpg: ', num2str(size_image3)]);
disp(['Тип даних ocean.jpg: ', class_image3]);

size_image4 = size(image4);
class_image4 = class(image4);
disp(['Розмір clouds.jpg: ', num2str(size_image4)]);
disp(['Тип даних clouds.jpg: ', class_image4]);

% 5.Зберігаємо завантажені зображення в заданому каталозі з указівкою
imwrite(image1, '/car_saved.png');
imwrite(image2, '/nature_saved.tif');
imwrite(image3, '/ocean_saved.jpg');
imwrite(image4, '/clouds_saved.jpg');

% 6.Будуємо гістограми для зображень за допомогою команди imhist(I)
imhist(image1);
title("Гістограма car.png");
figure;
imhist(image2);
title("Гістограма nature.tif");
figure;
imhist(image3);
title("Гістограма ocean.jpg");
figure;
imhist(image4);
title("Гістограма clouds.jpg");
figure;

% 7.Контрастуємо зображення за допомогою команди imadjust(I)
image1_adjusted = imadjust(image1, R_adj, G_adj, B_adj);
subplot(1,2,1), imshow(image1), title('Оригінал car.png');
subplot(1,2,2), imshow(image1_adjusted), title('Контрастоване car.png (imadjust)');
R = image2(:,:,1);
G = image2(:,:,2);
B = image2(:,:,3);
R_adjusted = imadjust(R);
G_adjusted = imadjust(G);
B_adjusted = imadjust(B);
image2_adjusted = cat(3, R_adjusted, G_adjusted, B_adjusted);
figure;
subplot(1,2,1), imshow(image2), title('Оригінал nature.tif');
subplot(1,2,2), imshow(image2_adjusted), title('Контрастоване nature.tif (imadjust)');
R = image3(:,:,1);
G = image3(:,:,2);
B = image3(:,:,3);
R_adjusted = imadjust(R);
G_adjusted = imadjust(G);
B_adjusted = imadjust(B);
image3_adjusted = cat(3, R_adjusted, G_adjusted, B_adjusted);
figure;
subplot(1,2,1), imshow(image3), title('Оригінал ocean.jpg');
subplot(1,2,2), imshow(image3_adjusted), title('Контрастоване ocean.jpg (imadjust)');

% 8.Відображаємо негатив зображення
image1_negative = imcomplement(image1);
image2_negative = imcomplement(image2);
image3_negative = imcomplement(image3);
image4_negative = imcomplement(image4);

figure;
subplot(1,2,1), imshow(image1), title('Оригінал car.png');
subplot(1,2,2), imshow(image1_negative), title('Негатив car.png');

figure;
subplot(1,2,1), imshow(image2), title('Оригінал nature.tif');
subplot(1,2,2), imshow(image2_negative), title('Негатив nature.tif');

figure;
subplot(1,2,1), imshow(image3), title('Оригінал ocean.jpg');
subplot(1,2,2), imshow(image3_negative), title('Негатив ocean.jpg');

figure;
subplot(1,2,1), imshow(image4), title('Оригінал clouds.jpg');
subplot(1,2,2), imshow(image4_negative), title('Негатив clouds.jpg');

% 9.З використанням Help MATLAB ознайомлюємось більш детально з
% особливостями процедури контрастування зображень imadjust.
help imadjust

R = image4(:,:,1);
G = image4(:,:,2);
B = image4(:,:,3);
%% Приклад 1: Сильне розтягнення контрасту

R_adj1 = imadjust(R, [0.2 0.8], [0 1]);
G_adj1 = imadjust(G, [0.2 0.8], [0 1]);
B_adj1 = imadjust(B, [0.2 0.8], [0 1]);
cat_adj1 = cat(3, R_adj1, G_adj1, B_adj1);
%% Приклад 2: Менше розтягнення контрасту

R_adj2 = imadjust(R, [0.3 0.7], [0 1]);
G_adj2 = imadjust(G, [0.3 0.7], [0 1]);
B_adj2 = imadjust(B, [0.3 0.7], [0 1]);
cat_adj2 = cat(3, R_adj2, G_adj2, B_adj2);
%% Приклад 3: Інверсія зображення

R_adj3 = imadjust(R, [0 1], [1 0]);
G_adj3 = imadjust(G, [0 1], [1 0]);
B_adj3 = imadjust(B, [0 1], [1 0]);
cat_adj3 = cat(3, R_adj3, G_adj3, B_adj3);

figure;
subplot(2,2,1), imshow(image4), title('Оригінал clouds.jpg');
subplot(2,2,2), imshow(cat_adj1), title('[0.2, 0.8] -> [0, 1]');
subplot(2,2,3), imshow(cat_adj2), title('[0.3, 0.7] -> [0, 1]');
subplot(2,2,4), imshow(cat_adj3), title('Інверсія: [0, 1] -> [1, 0]');

% 10.Контрольні питання
