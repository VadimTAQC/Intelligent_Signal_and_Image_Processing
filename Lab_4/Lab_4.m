clear; close all

% 1.Завантаження зображень з бібліотеки MATLAB
image1 = imread('ocean.jpg'); 
image2 = imread('nature.tif');
target_size = size(image1);
image2 = imresize(image2, [target_size(1), target_size(2)]);


figure;
subplot(1, 2, 1); imshow(image1); title('ocean.jpg');
subplot(1,2,2); imshow(image2); title('nature.tif');

% 2. З використанням функції F = fft2(f) формуємо й відображаємо
% двовимірні спектри зображень.
F1 = fft2(image1);
F2 = fft2(image2);

% Обчислюємо модуль (амплітуду) без зсуву
mag1_noShift = abs(F1);
mag2_noShift = abs(F2);

% Логарифмічна шкала для візуалізації
logMag1_noShift = log(1 + mag1_noShift);
logMag2_noShift = log(1 + mag2_noShift);

% Нормалізація та масштабування для відображення
normMag1_noShift = mat2gray(logMag1_noShift);
normMag2_noShift = mat2gray(logMag2_noShift);
scaledMag1_noShift = uint8(255 * normMag1_noShift);
scaledMag2_noShift = uint8(255 * normMag2_noShift);

figure;
subplot(1,2,1), imshow(scaledMag1_noShift, []), title('Спектр (без зсуву) Зображення 1');
subplot(1,2,2), imshow(scaledMag2_noShift, []), title('Спектр (без зсуву) Зображення 2');


% 3. З використанням функції fftshift приводимо нульову частоту в
% спектрі до центру вікна відображення.
F1_shifted = fftshift(F1);
F2_shifted = fftshift(F2);

mag1_shifted = abs(F1_shifted);
mag2_shifted = abs(F2_shifted);

logMag1_shifted = log(1 + mag1_shifted);
logMag2_shifted = log(1 + mag2_shifted);

normMag1_shifted = mat2gray(logMag1_shifted);
normMag2_shifted = mat2gray(logMag2_shifted);
scaledMag1_shifted = uint8(255 * normMag1_shifted);
scaledMag2_shifted = uint8(255 * normMag2_shifted);

figure;
subplot(1,2,1), imshow(scaledMag1_shifted, []), title('Спектр (зсунутий) Зображення 1');
subplot(1,2,2), imshow(scaledMag2_shifted, []), title('Спектр (зсунутий) Зображення 2');


% 4. З використанням функції ifft2(F) відновлюємо зображення за його
% спектром.
ampF1 = abs(F1);
ampF2 = abs(F2);

img1_restored_amp = ifft2(F1);
img2_restored_amp = ifft2(F2);

figure;
subplot(1,2,1), imshow(mat2gray(abs(img1_restored_amp))), title('Відновлене зображення 1');
subplot(1,2,2), imshow(mat2gray(abs(img2_restored_amp))), title('Відновлене Зображення 2');

% 5. З використанням функції fspecial('gaussian') задаємо двовимірний
% фільтр із параметрами [M N], sigma в області просторових змінних.
M = 20;  
N = 20;  
sigma1 = 2;
sigma2 = 5;

H1_small = fspecial('gaussian', [M N], sigma1);
H2_small = fspecial('gaussian', [M N], sigma2);

figure;
subplot(1,2,1), imshow(H1_small, []), title('Фільтр Гауса H1');
subplot(1,2,2), imshow(H2_small, []), title('Фільтр Гауса H2');

H1_fft_small = fft2(H1_small);
H2_fft_small = fft2(H2_small);

figure;
subplot(1,2,1), imshow(abs(fftshift(H1_fft_small)), []), title('Частотна характеристика H1 (20x20)');
subplot(1,2,2), imshow(abs(fftshift(H2_fft_small)), []), title('Частотна характеристика H2 (20x20)');

% 6. Визначаємо вигляд частотної характеристики даного фільтра.
[rows1, cols1] = size(image1);
[rows2, cols2] = size(image2);

% FFT зображень з розмірами оригіналу
FFT_image1 = fft2(image1, rows1, cols1);
FFT_image2 = fft2(image2, rows2, cols2);

% FFT фільтрів з нульовим доповненням до розмірів зображень
FFT_filter1_forImage1 = fft2(H1_small, rows1, cols1);
FFT_filter2_forImage2 = fft2(H2_small, rows2, cols2);

% Перемноження в частотній області
product1 = FFT_image1 .* FFT_filter1_forImage1;
product2 = FFT_image2 .* FFT_filter2_forImage2;

% Зворотне перетворення
filteredImageFreq1 = ifft2(product1);
filteredImageFreq2 = ifft2(product2);

% Нормалізація для відображення
filteredImageFreq1_show = uint8(255*mat2gray(real(filteredImageFreq1)));
filteredImageFreq2_show = uint8(255*mat2gray(real(filteredImageFreq2)));

% Для візуалізації спектрів після фільтрації (логарифмічна шкала)
logSpec1 = mat2gray(log(1 + abs(fftshift(product1))));
logSpec2 = mat2gray(log(1 + abs(fftshift(product2))));

figure;
subplot(2,2,1), imshow(logSpec1, []), title('Спектр (Зображення 1*H1)');
subplot(2,2,2), imshow(logSpec2, []), title('Спектр (Зображення 2*H2)');
subplot(2,2,3), imshow(filteredImageFreq1_show, []), title('Відфільтр. Зображення 1 (ФЧ)');
subplot(2,2,4), imshow(filteredImageFreq2_show, []), title('Відфільтр. Зображення 2 (ФЧ)');

% 7. Виконуємо фільтрацію у просторі.
image1_spatial_H1 = imfilter(image1, H1_small, 'conv', 'same');
image1_spatial_H2 = imfilter(image1, H2_small, 'conv', 'same');
image2_spatial_H1 = imfilter(image2, H1_small, 'conv', 'same');
image2_spatial_H2 = imfilter(image2, H2_small, 'conv', 'same');

figure;
subplot(2,2,1), imshow(image1_spatial_H1, []), title('Зображення 1, H1 (простір)');
subplot(2,2,2), imshow(image1_spatial_H2, []), title('Зображення 1, H2 (простір)');
subplot(2,2,3), imshow(image2_spatial_H1, []), title('Зображення 2, H1 (простір)');
subplot(2,2,4), imshow(image2_spatial_H2, []), title('Зображення 2, H2 (простір)');

% 8. Порівняння результатів для Зображення 1 (частотна й просторова філтрації). 
targetSize = size(filteredImageFreq1);
if numel(targetSize) > 2
    targetSize = targetSize(1:2);
end


image1_spatial_H1_resized = imresize(image1_spatial_H1, targetSize);
image1_spatial_H1_resized = double(image1_spatial_H1_resized);

filteredImageFreq1_real = double(real(filteredImageFreq1));
diffImage1_H1 = abs(filteredImageFreq1_real - image1_spatial_H1_resized);

figure;
subplot(1,3,1), imshow(filteredImageFreq1_show, []), title('ФЧ (Зображення 1, H1)');
subplot(1,3,2), imshow(mat2gray(image1_spatial_H1_resized)), title('Простор. (зображення 1, H1)');
subplot(1,3,3), imshow(mat2gray(diffImage1_H1)), title('Різниця');

% 9. Порівняння результатів для Зображення 2 (частотна й просторовa фільтрація).
targetSize = size(filteredImageFreq2);
if numel(targetSize) > 2
    targetSize = targetSize(1:2);
end


image2_spatial_H2_resized = imresize(image2_spatial_H2, targetSize);
image2_spatial_H2_resized = double(image2_spatial_H2_resized);

filteredImageFreq2_real = double(real(filteredImageFreq2));
diffImage2_H2 = abs(filteredImageFreq2_real - image1_spatial_H1_resized);

figure;
subplot(1,3,1), imshow(filteredImageFreq2_show, []), title('ФЧ (Зображення 2, H2)');
subplot(1,3,2), imshow(image2_spatial_H2, []), title('Простор. (Зображення 2, H2)');
subplot(1,3,3), imshow(mat2gray(diffImage2_H2), []), title('Різниця');