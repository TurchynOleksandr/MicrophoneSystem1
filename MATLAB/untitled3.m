clear; close all; clc;

%% Налаштування (мають збігатись з константами в main.c!)
portName = "COM5";           % Заміни на свій порт
baudRate = 9600;           % Має збігатись з huart1.Init.BaudRate
NUM_CHANNELS = 16;           % Має збігатись з NUM_CHANNELS в main.c
SAMPLES_PER_CHANNEL = 256;   % Має збігатись з SAMPLES_PER_CHANNEL в main.c

marker = uint8([0xAA 0xBB 0xCC 0xDD]);
bytesPerFrame = NUM_CHANNELS * SAMPLES_PER_CHANNEL * 2;  % uint16 = 2 байти

%% Відкриваємо порт
s = serialport(portName, baudRate);
flush(s);

%% Налаштування графіків (сітка 4x4, по одному на канал)
figure('Name', 'Real-time ADC Multi-Channel', 'NumberTitle', 'off', ...
       'Position', [50 0 1200 800]);

hLines = gobjects(NUM_CHANNELS, 1);
t = 1:SAMPLES_PER_CHANNEL;

for ch = 1:NUM_CHANNELS
    subplot(4, 4, ch);
    hLines(ch) = plot(t, zeros(1, SAMPLES_PER_CHANNEL));
    title(sprintf('CH%d', ch - 1));
    ylim([0, 4100]);
    xlim([1, SAMPLES_PER_CHANNEL]);
    grid on;
end

disp('Читання даних... Закрий вікно графіка, щоб зупинити.');

%% Головний цикл оновлення
try
    while all(isgraphics(hLines))
        found = false;
        buf = uint8([]);

        % 1. Шукаємо маркер початку кадру
        while ~found && all(isgraphics(hLines))
            if s.NumBytesAvailable > 0
                newByte = read(s, 1, "uint8");
                buf = [buf, newByte]; %#ok<AGROW>

                if length(buf) >= 4
                    idx = strfind(buf, marker);
                    if ~isempty(idx)
                        buf = buf(idx(end)+4:end);
                        found = true;
                    end
                end
            else
                pause(0.01);
            end
        end

        if ~all(isgraphics(hLines))
            break;
        end

        % 2. Дочитуємо решту кадру
        bytesNeeded = bytesPerFrame - numel(buf);
        while bytesNeeded > 0 && all(isgraphics(hLines))
            if s.NumBytesAvailable > 0
                bytesToRead = min(bytesNeeded, s.NumBytesAvailable);
                rest = read(s, bytesToRead, "uint8");
                buf = [buf, rest]; %#ok<AGROW>
                bytesNeeded = bytesPerFrame - numel(buf);
            else
                pause(0.01);
            end
        end

        % 3. Перетворюємо байти у uint16 і розкладаємо по каналах
        if all(isgraphics(hLines)) && numel(buf) == bytesPerFrame
            raw = typecast(buf, 'uint16');
            % Дані в буфері прошивки йдуть інтерліievано:
            % [ch0_s0, ch1_s0, ..., ch15_s0, ch0_s1, ch1_s1, ...]
            % Тобто це матриця NUM_CHANNELS x SAMPLES_PER_CHANNEL
            % при читанні по стовпцях (Fortran/column-major порядок MATLAB).
            samplesMatrix = reshape(raw, NUM_CHANNELS, SAMPLES_PER_CHANNEL);

            for ch = 1:NUM_CHANNELS
                set(hLines(ch), 'YData', samplesMatrix(ch, :));
            end
            drawnow limitrate;
        end
    end
catch ME
    disp('Виникла помилка:');
    disp(ME.message);
end

%% Закриття порту
clear s;
disp('Порт закрито.');
