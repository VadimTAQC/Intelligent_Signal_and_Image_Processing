clear; close all

% 1-2.Завантажуємо з бібліотеки тестове зображення і відображуємо на
% екрані ПК
image = im2double(imread('ocean.jpg'));

figure;
imshow(image);
title('Вихідне зображення (ocean.jpg)');

% 3-4.Здійснюємо процедуру перекручення зображення змінюючи параметри
% LEN і THETA та відображаємо на екрані ПК
LEN = 19;     % Довжина розмиття
THETA = 32;   % Кут розмиття
PSF = fspecial('motion', LEN, THETA); % PSF (Point Spread Function) - ядро 
% згортки, що відповідає розмиттю під час руху

% Згортка зображення з PSF:
blurred = imfilter(image, PSF, 'conv', 'circular');
% 'conv' означає згортку, 'circular' — граничні умови (зображення повторюється циклічно)

figure;
imshow(blurred);
title('Змазане (перекручене) зображення');

% 5-6.Виконуємо процедуру відновлення зображення та відображаємо зображення 
% після відновлення
wnr1 = deconvwnr(blurred, PSF, 0);  
% Тут 0 означає, що шуму немає або він дуже малий (NSR=0).

figure;
imshow(wnr1);
title('Відновлене (деblurred) зображення без урахування шуму');

% 7.Виконуємо зашумлення початкового зображення та повторюємо пункти 2-6
noisy = imnoise(image, 'gaussian', 0, 0.01);  

figure;
imshow(noisy);
title('Зашумлене вихідне зображення (гаусівський шум)');

noisy_blurred = imfilter(noisy, PSF, 'conv', 'circular');

figure;
imshow(noisy_blurred);
title('Перекручене (змазане) і зашумлене зображення');

wnr2 = deconvwnr(noisy_blurred, PSF, 0.01);

figure;
imshow(wnr2);
title('Відновлене (деblurred) зашумлене і перекручене зображення');


