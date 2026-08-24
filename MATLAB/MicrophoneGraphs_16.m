clear; close all; clc;

%% Налаштування
portName = "COM5";       
baudRate = 9600;       % Швидкість UART бажано підняти, бо даних тепер вдвічі більше
numChannels = 16;        % Кількість каналів
samplesPerCh = 128;      % Семплів на один канал
bytesPerFrame = (numChannels * samplesPerCh) * 2; % 4096 байт
marker = uint8([0xAA 0xBB 0xCC 0xDD]);

%% Відкриваємо порт
s = serialport(portName, baudRate);
configureTerminator(s, "LF");
flush(s);

%% Налаштування сітки з 16 графіків
fig = figure('Name', '16 Channels ADC', 'NumberTitle', 'off', 'Position', [0 0 1200 800]);
t = tiledlayout(4, 4, 'TileSpacing', 'compact', 'Padding', 'compact');

hLines = gobjects(numChannels, 1);
t_axis = 1:samplesPerCh;

for i = 1:numChannels
    nexttile;
    hLines(i) = plot(t_axis, zeros(1, samplesPerCh));
    title(sprintf('Ch %d', i-1)); % Нумерація від 0 до 15 (як у CubeMX)
    ylim([0, 4100]);
    grid on;
end

disp('Читання даних... Закрий вікно графіка, щоб зупинити.');

%% Головний цикл оновлення
buf = uint8([]); 
try
    while ishandle(fig)
        % 1. Читаємо всі доступні байти
        if s.NumBytesAvailable > 0
            buf = [buf, read(s, s.NumBytesAvailable, "uint8")];
        end
        
        % 2. Перевіряємо наявність цілого кадру (маркер + 4096 байт)
        if numel(buf) >= (4 + bytesPerFrame)
            idx = strfind(buf, marker);
            
            if ~isempty(idx)
                last_idx = idx(end);
                
                if numel(buf) >= (last_idx + 3 + bytesPerFrame)
                    % Витягуємо сирі байти та перетворюємо у uint16
                    frameData = buf(last_idx+4 : last_idx+3+bytesPerFrame);
                    adc_values = typecast(frameData, 'uint16');
                    
                    % Розплутуємо масив: перетворюємо 1D масив у матрицю 16 x 128
                    adc_matrix = reshape(adc_values, numChannels, samplesPerCh);
                    
                    % Оновлюємо кожен з 16 графіків
                    for ch = 1:numChannels
                        set(hLines(ch), 'YData', adc_matrix(ch, :));
                    end
                    drawnow;
                    
                    % Очищаємо оброблений кадр
                    buf = buf(last_idx + 4 + bytesPerFrame : end);
                end
            else
                if numel(buf) > 3
                    buf = buf(end-2:end);
                end
            end
        end
        pause(0.01);
    end
catch ME
    disp(ME.message);
end

clear s;
disp('Порт закрито.');