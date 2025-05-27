clear; close all

% 1.Завантаження зображень з бібліотеки MATLAB
image1 = imread('car.png'); 
image2 = imread('nature.tif'); 

% 2.Відображення вихідних зображень на екрані ПК
figure;
subplot(1, 2, 1); imshow(image1); title('car.png');
subplot(1,2,2); imshow(image2); title('nature.tif');

% 3.Здійснюємо процедуру зашумлення зображення нормальним білим
%шумом і імпульсною перешкодою з різною щільністю
image1_gauss = imnoise(image1, 'gaussian', 0, 0.01);
image1_sp    = imnoise(image1, 'salt & pepper', 0.02);
image2_gauss = imnoise(image2, 'gaussian', 0, 0.05);
image2_sp    = imnoise(image2, 'salt & pepper', 0.05);

% 4.Відображаємо зашумлені зображення
figure;
subplot(1,2,1), imshow(image1_gauss), title('Car + Gaussian Noise');
subplot(1,2,2), imshow(image1_sp),    title('Car + Salt & Pepper Noise');

figure;
subplot(1,2,1), imshow(image2_gauss), title('Nature + Gaussian Noise');
subplot(1,2,2), imshow(image2_sp),    title('Nature + Salt & Pepper Noise');

% 5.Виконуємо фільтрацію вихідних зображень лінійними фільтрами з
% використанням віконних фільтрів низьких і високих частот, і процедури
% imfilter(I,h);
h_avg    = fspecial('average', [3 3]);      % 3x3 усереднювальний фільтр
h_gauss  = fspecial('gaussian', [3 3], 0.5);% 3x3 гаусівський фільтр, sigma=0.5
h_unsharp= fspecial('unsharp');             % фільтр для підсилення різкості

%--- Car ---
% Gaussian noise
cam_gauss_avg    = imfilter(image1_gauss, h_avg);
cam_gauss_gauss  = imfilter(image1_gauss, h_gauss);
cam_gauss_unsharp= imfilter(image1_gauss, h_unsharp);

% Salt & Pepper noise
cam_sp_avg       = imfilter(image1_sp, h_avg);
cam_sp_gauss     = imfilter(image1_sp, h_gauss);
cam_sp_unsharp   = imfilter(image1_sp, h_unsharp);

% --- Nature ---
% Gaussian noise
pep_gauss_avg    = imfilter(image2_gauss, h_avg);
pep_gauss_gauss  = imfilter(image2_gauss, h_gauss);
pep_gauss_unsharp= imfilter(image2_gauss, h_unsharp);

% Salt & Pepper noise
pep_sp_avg       = imfilter(image2_sp, h_avg);
pep_sp_gauss     = imfilter(image2_sp, h_gauss);
pep_sp_unsharp   = imfilter(image2_sp, h_unsharp);

% 6.Відображаэмо зображення після фільтрації

figure('Name','Car Salt & Pepper Noise - Linear Filters');
subplot(1,3,1), imshow(cam_gauss_avg),     title('Average Filter');
subplot(1,3,2), imshow(cam_gauss_gauss),   title('Gaussian Filter');
subplot(1,3,3), imshow(cam_gauss_unsharp), title('Unsharp Filter');

figure('Name','Car Salt & Pepper Noise - Linear Filters');
subplot(1,3,1), imshow(cam_sp_avg),     title('Average Filter');
subplot(1,3,2), imshow(cam_sp_gauss),   title('Gaussian Filter');
subplot(1,3,3), imshow(cam_sp_unsharp), title('Unsharp Filter');

figure('Name',' Nature Gaussian Noise - Linear Filters');
subplot(1,3,1), imshow(pep_gauss_avg),     title('Average Filter');
subplot(1,3,2), imshow(pep_gauss_gauss),   title('Gaussian Filter');
subplot(1,3,3), imshow(pep_gauss_unsharp), title('Unsharp Filter');

figure('Name',' Nature Salt & Pepper Noise - Linear Filters');
subplot(1,3,1), imshow(pep_sp_avg),     title('Average Filter');
subplot(1,3,2), imshow(pep_sp_gauss),   title('Gaussian Filter');
subplot(1,3,3), imshow(pep_sp_unsharp), title('Unsharp Filter');

% 7-8.Фільтрування різними лінійними фільтрами зображення, на прикладі WIENER2
cam_gauss_wiener = wiener2(image1_gauss, [5 5]);
cam_sp_wiener    = wiener2(image1_sp,    [5 5]);

figure;
subplot(1,2,1), imshow(cam_gauss_wiener), title('Gaussian Noise - Wiener');
subplot(1,2,2), imshow(cam_sp_wiener),    title('Salt & Pepper - Wiener');

pr_gauss = image2_gauss(:,:,1); pg_gauss = image2_gauss(:,:,2); 
pb_gauss = image2_gauss(:,:,3);
pr_sp = image2_sp(:,:,1); pg_sp = image2_sp(:,:,2);    
pb_sp = image2_sp(:,:,3);

% Фільтруємо кожен канал
pr_gauss_w = wiener2(pr_gauss,[5 5]);
pg_gauss_w = wiener2(pg_gauss,[5 5]);
pb_gauss_w = wiener2(pb_gauss,[5 5]);
pr_sp_w    = wiener2(pr_sp,[5 5]);
pg_sp_w    = wiener2(pg_sp,[5 5]);
pb_sp_w    = wiener2(pb_sp,[5 5]);

% Об'єднуємо назад
pep_gauss_wiener = cat(3, pr_gauss_w, pg_gauss_w, pb_gauss_w);
pep_sp_wiener    = cat(3, pr_sp_w,    pg_sp_w,    pb_sp_w);

figure;
subplot(1,2,1), imshow(pep_gauss_wiener), title('Gaussian Noise - Wiener');
subplot(1,2,2), imshow(pep_sp_wiener),    title('Salt & Pepper - Wiener');

% 9.Здійснюэмо фільтрацію зашумлених зображень нелінійним медіанним
%фільтром
% --- Car ---
cam_gauss_med = medfilt2(image1_gauss, [3 3]);
cam_sp_med = medfilt2(image1_sp,    [3 3]);

figure;
subplot(1,2,1), imshow(cam_gauss_med), title('Gaussian Noise - Median');
subplot(1,2,2), imshow(cam_sp_med),    title('Salt & Pepper Noise - Median');

% --- Nature ---
% Медіанний фільтр до кожного каналу
pr_gauss_med = medfilt2(pr_gauss, [3 3]);
pg_gauss_med = medfilt2(pg_gauss, [3 3]);
pb_gauss_med = medfilt2(pb_gauss, [3 3]);
pep_gauss_med = cat(3, pr_gauss_med, pg_gauss_med, pb_gauss_med);

pr_sp_med = medfilt2(pr_sp, [3 3]);
pg_sp_med = medfilt2(pg_sp, [3 3]);
pb_sp_med = medfilt2(pb_sp, [3 3]);
pep_sp_med = cat(3, pr_sp_med, pg_sp_med, pb_sp_med);

figure;
subplot(1,2,1), imshow(pep_gauss_med), title('Gaussian Noise - Median');
subplot(1,2,2), imshow(pep_sp_med), title('Salt & Pepper Noise - Median');





