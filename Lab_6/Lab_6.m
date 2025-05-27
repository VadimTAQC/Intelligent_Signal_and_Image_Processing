clear; clc; close all;

% 1. Завантажуємо з бібліотеки MATLAB декілька кольорових і чорно-білих
%зображень різного характеру
imgs = {'forest.jpg', 'waterfall.jpg', 'mountain.jpg'};

figure('Name','1. Початкові зображення','Units','normalized','OuterPosition',[0 0 1 1]);
for i = 1:numel(imgs)
    subplot(1,numel(imgs),i)
    I = imread(imgs{i});
    imshow(I,'InitialMagnification','fit')
    title(['Оригінал: ', imgs{i}],'Interpreter','none')
end

% 2. З використанням функції rgb2gray перетворюємо кольорові зображення
% в чорно-білі.
grayImgs = cell(size(imgs));
for i = 1:numel(imgs)
    I = imread(imgs{i});
    if ndims(I) == 3
        grayImgs{i} = rgb2gray(I);
    else
        grayImgs{i} = I;
    end
end

% 3-4-5. Виконуємо поблочне дискретне косинусне перетворення зображень
% з використанням функції B = blockproc(I,[N N],dct) і відображаємо
% результат. Відновлюємо зображення за його ДКП-спектром.
N = 8;                   
T = dctmtx(N);           
dct    = @(bs) T * double(bs.data) * T';  
invdct = @(bs) T' * bs.data * T;          

padOpts = {'PadPartialBlocks', true, 'PadMethod', 'symmetric'};

figure('Name','Поблочне ДКП та відновлення','Units','normalized','OuterPosition',[0 0 1 1]);
for i = 1:numel(grayImgs)
    B = grayImgs{i};
    % Поблочне ДКП
    D = blockproc(B, [N N], dct, padOpts{:});
    
    % Відображення спектра ДКП з логарифмічною шкалою
    subplot(2, numel(grayImgs), i)
    imshow(log(abs(D)+1), [], 'InitialMagnification','fit')
    title(['Логарифмічна шкала: ', imgs{i}], 'Interpreter','none')
    
    % Відновлення зображення через зворотне ДКП
    Irec = uint8( blockproc(D, [N N], invdct, padOpts{:}) );
    subplot(2, numel(grayImgs), i+numel(grayImgs))
    imshow(Irec, 'InitialMagnification','fit')
    title(['Відновлення (100%): ', imgs{i}], 'Interpreter','none')
end

% 6. Виконуємо квантування результатів ДКП для різних значень
% кроку квантування N.
steps = [2, 5, 10];
for q = steps
    figure('Name',['6. Квантування q=',num2str(q)],'Units','normalized','OuterPosition',[0 0 1 1]);
    for i = 1:numel(grayImgs)
        B = grayImgs{i};
        % спочатку обчислюємо DCT-спектр
        D = blockproc(B, [N N], dct, padOpts{:});
        % Квантування
        Dq = blockproc(D, [N N], @(bs) q * round(bs.data / q), padOpts{:});
        
        % Відображення спектра після квантування
        subplot(2, numel(grayImgs), i)
        imshow(log(abs(Dq)+1), [], 'InitialMagnification','fit')
        title(['Спектр квантування q=',num2str(q),': ', imgs{i}], 'Interpreter','none')
        
        % Відновлення зображення зі спектра ДКП після квантування
        Iq = uint8( blockproc(Dq, [N N], invdct, padOpts{:}) );
        subplot(2, numel(grayImgs), i+numel(grayImgs))
        imshow(Iq, 'InitialMagnification','fit')
        title(['Відновлення q=',num2str(q),': ', imgs{i}], 'Interpreter','none')
    end
end

% 7-8. Виконуємо квантування коефіцієнтів ДКП та відновлюємо зображення
% за його квантованим ДКП-спектром.
mask = [1 1 1 1 0 0 0 0;
        1 1 1 0 0 0 0 0;
        1 1 0 0 0 0 0 0;
        1 0 0 0 0 0 0 0;
        zeros(4,8)];
figure('Name','Квантування маскою та відновлення','Units','normalized','OuterPosition',[0 0 1 1]);
for i = 1:numel(grayImgs)
    B = grayImgs{i};
    D  = blockproc(B, [N N], dct, padOpts{:}); % DCT-спектр
    Dm = blockproc(D, [N N], @(bs) mask .* bs.data, padOpts{:});  % маска
    
    % Відображення спектра з маскою
    subplot(2, numel(grayImgs), i)
    imshow(log(abs(Dm)+1), [], 'InitialMagnification','fit')
    title(['Спектр з маскою: ', imgs{i}], 'Interpreter','none')
    
    % Відновлення після маски
    Icm = uint8( blockproc(Dm, [N N], invdct, padOpts{:}) );
    subplot(2, numel(grayImgs), i+numel(grayImgs))
    imshow(Icm, 'InitialMagnification','fit')
    title(['Відновлення: ', imgs{i}], 'Interpreter','none')
end
