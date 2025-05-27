clear; clc; close all;

% 1. Завантажуємо з бібліотеки MATLAB декілька кольорових і чорно-білих
%зображень різного характеру
colorFiles = {'forest.jpg', 'waterfall.jpg'};
grayFiles  = {'mountain.jpg', 'mountain.jpg'};
quantSteps = [0.01, 0.05, 0.1, 0.2]; 

allFiles = [colorFiles, grayFiles];
isColor  = [true(1,numel(colorFiles)), false(1,numel(grayFiles))];

figure('Name','1. Оригінальні','Units','normalized','Position',[0.05 0.05 0.9 0.9]);
tiledlayout(2, numel(allFiles)/2,'TileSpacing','compact','Padding','compact');
for i = 1:numel(allFiles)
    I = imread(allFiles{i});
    nexttile;
    imshow(I);
    title(allFiles{i}, 'Interpreter','none');
end

% 2. З використанням функції rgb2gray перетворюємо кольорові зображення
% в чорно-білі.
figure('Name','2. rgb2gray','Units','normalized','Position',[0.1 0.1 0.8 0.6]);
tiledlayout(1, numel(colorFiles),'TileSpacing','compact','Padding','compact');
for i = 1:numel(colorFiles)
    C = imread(colorFiles{i});
    G = rgb2gray(C);
    nexttile;
    imshow(G);
    title(['Gray: ' colorFiles{i}], 'Interpreter','none');
end

% 3. З використанням функції dct2 виконуємо дискретне косинусне
% перетворення зображень.
figure('Name','3. DCT2 спектр','Units','normalized','Position',[0.1 0.1 0.8 0.6]);
tiledlayout(1, numel(allFiles),'TileSpacing','compact','Padding','compact');
for i = 1:numel(allFiles)
    J = imread(allFiles{i});
    if isColor(i)
        J = rgb2gray(J);
    end
    D = dct2(im2double(J));
    nexttile;
    imshow(log(abs(D)+eps), []);
    title(sprintf('DCT log: %s', allFiles{i}), 'Interpreter','none');
end

% 4. З використанням функції idct2 відновлюємо зображення за дискретно 
% косинусним перетворенням спектру.
tiledlayout(1, numel(allFiles),'TileSpacing','compact','Padding','compact');
for i = 1:numel(allFiles)
    J = imread(allFiles{i});
    if isColor(i)
        J = rgb2gray(J);
    end
    figure('Name','4. IDCT2 реконструкція','Units','normalized','Position',[0.1 0.1 0.8 0.6]);
    R = idct2(dct2(im2double(J)));
    nexttile;
    imshow(R, []);
    title(sprintf('Recons: %s', allFiles{i}), 'Interpreter','none');
end

% 5-6-7. Квантування дискретного косинусного перетворення, відображення
% у логарифмічному масштабі та реконструкція зображень.
for i = 1:numel(allFiles)
    fname = allFiles{i};
    I = imread(fname);
    if isColor(i)
        I = rgb2gray(I);
    end
    I = im2double(I);
    D = dct2(I);
    figName = sprintf('5–7. Квантування DCT: %s', fname);
    figure('Name', figName, 'Units','normalized','Position',[0.05 0.05 0.9 0.8]);
    tiledlayout(2, numel(quantSteps),'TileSpacing','compact','Padding','compact');
    for k = 1:numel(quantSteps)
        N = quantSteps(k);
        Dq = N * round(D / N);
        nexttile;
        imshow(log(abs(Dq)+eps), []);
        title(sprintf('DCTq log N=%.2f', N));
        Rq = idct2(Dq);
        nexttile;
        imshow(Rq, []);
        title(sprintf('Recons N=%.2f', N));
    end
end

% 9. Робимо квантове перетворення з використанням процедури I =
% (round(J/n))*n.
for i = 1:numel(allFiles)
    fname = allFiles{i};
    J = imread(fname);
    if isColor(i)
        J = rgb2gray(J);
    end
    I = im2double(J);
    figName = sprintf('9. Квантування I: %s', fname);
    figure('Name', figName, 'Units','normalized','Position',[0.2 0.2 0.6 0.6]);
    tiledlayout(1, numel(quantSteps),'TileSpacing','compact','Padding','compact');
    for k = 1:numel(quantSteps)
        N = quantSteps(k);
        Iq = N * round(I / N);
        nexttile;
        imshow(Iq, []);
        title(sprintf('I quant N=%.2f', N));
    end
end



