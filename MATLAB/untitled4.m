clear; close all; clc;

%% Налаштування (мають збігатись з main.c!)
portName = "COM5";
baudRate = 115200;           % Має збігатися з huart1.Init.BaudRate
NUM_CHANNELS = 3;
SAMPLES_PER_CHANNEL = 256;

marker = uint8([0xAA 0xBB 0xCC 0xDD]);
bytesPerFrame = NUM_CHANNELS * SAMPLES_PER_CHANNEL * 2;

%% Відкриваємо порт
s = serialport(portName, baudRate);
% Великий вхідний буфер - запас на випадок, якщо цикл малювання
% (drawnow) на мить забере більше часу, ніж триває передача кадру
s.InputBufferSize = 65536;
flush(s);

%% Налаштування графіків
figure('Name', 'Real-time ADC (3 Channels)', 'NumberTitle', 'off', ...
       'Position', [100 0 800 800]);

tl = tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact');
hLines = gobjects(NUM_CHANNELS, 1);
t_axis = 1:SAMPLES_PER_CHANNEL;

for ch = 1:NUM_CHANNELS
    nexttile;
    hLines(ch) = plot(t_axis, zeros(1, SAMPLES_PER_CHANNEL));
    title(sprintf('Канал %d', ch - 1));
    ylim([0, 4100]);
    xlim([1, SAMPLES_PER_CHANNEL]);
    grid on;
end

disp('Читання даних... Закрий вікно графіка, щоб зупинити.');

%% Кільцевий (persistent) буфер байтів, що накопичується між ітераціями
rxBuf = uint8([]);

% Скільки байтів треба мати в rxBuf, щоб гарантовано вмістити маркер
% + повний кадр даних
frameTotalLen = 4 + bytesPerFrame;

%% Головний цикл оновлення
try
    while all(isgraphics(hLines))

        % 1. Одним викликом забираємо ВСЕ, що встигло накопичитись
        %    в буфері порту -- це на порядки швидше за читання по 1 байту
        %    і не дає драйверу губити дані через те, що MATLAB не встигає.
        nAvail = s.NumBytesAvailable;
        if nAvail > 0
            newData = read(s, nAvail, "uint8");
            rxBuf = [rxBuf, newData]; %#ok<AGROW>
        else
            pause(0.005);
            continue;
        end

        % 2. Чекаємо, поки в буфері накопичиться хоча б один повний кадр
        if numel(rxBuf) < frameTotalLen
            continue;
        end

        % 3. Шукаємо ВСІ входження маркера в накопиченому буфері.
        %    Якщо їх кілька -- це означає, що ми відстаємо від потоку
        %    (наприклад, drawnow забрав забагато часу), і варто взяти
        %    ОСТАННІЙ повний кадр, а старі відкинути, щоб не накопичувати
        %    затримку і не малювати застарілі дані.
        idx = strfind(rxBuf, marker);

        if isempty(idx)
            % Маркера ще нема в буфері - але щоб він не ріс нескінченно
            % при повній відсутності зв'язку, ріжемо його з розумом
            if numel(rxBuf) > 4 * frameTotalLen
                rxBuf = rxBuf(end - frameTotalLen + 1:end);
            end
            continue;
        end

        % Беремо останній маркер, для якого після нього достатньо байтів
        % на повний кадр
        validStart = idx(idx + 4 + bytesPerFrame - 1 <= numel(rxBuf));
        if isempty(validStart)
            % маркер є, але кадр після нього ще не прийшов повністю -
            % чекаємо наступну ітерацію, старі байти ДО маркера прибираємо
            rxBuf = rxBuf(idx(end):end);
            continue;
        end

        frameStart = validStart(end) + 4;
        frameBytes = rxBuf(frameStart : frameStart + bytesPerFrame - 1);

        % Усе, що до кінця цього кадру, більше не потрібне
        rxBuf = rxBuf(frameStart + bytesPerFrame:end);

        % 4. Перетворюємо на семпли й розкладаємо по каналах
        raw = typecast(frameBytes, 'uint16');
        samplesMatrix = reshape(raw, NUM_CHANNELS, SAMPLES_PER_CHANNEL);

        for ch = 1:NUM_CHANNELS
            set(hLines(ch), 'YData', samplesMatrix(ch, :));
        end
        drawnow limitrate;
    end
catch ME
    disp('Виникла помилка:');
    disp(ME.message);
end

%% Закриття порту
clear s;
disp('Порт закрито.');