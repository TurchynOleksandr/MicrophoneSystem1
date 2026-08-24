clear; close all; clc;

%% Налаштування
portName = "COM5";       % Заміни на свій порт
baudRate = 9600;         % Швидкість UART
N = 1024;                % Кількість семплів з АЦП
marker = uint8([0xAA 0xBB 0xCC 0xDD]); % Маркер початку кадру
bytesPerFrame = N * 2;   % 2048 байт (1024 uint16 * 2 байти)

%% Відкриваємо порт
s = serialport(portName, baudRate);
configureTerminator(s, "LF");
flush(s);

%% Налаштування графіка
figure('Name', 'Real-time ADC Waveform', 'NumberTitle', 'off');
t = 1:N; % Вісь X (просто номери семплів)

% Створюємо початковий графік і зберігаємо вказівник
hLine = plot(t, zeros(1, N));
xlabel('Номер семплу');
ylabel('Значення АЦП (0 - 4095)');
title('Сигнал з аналогового каналу (Сирі дані)');
grid on;

% Фіксуємо масштаб осі Y для 12-бітного АЦП
ylim([0, 4100]); 

disp('Читання даних... Закрий вікно графіка, щоб зупинити.');

%% Головний цикл оновлення
try
    while ishandle(hLine)
        found = false;
        buf = uint8([]);
        
        % 1. Шукаємо маркер початку кадру
        while ~found && ishandle(hLine)
            if s.NumBytesAvailable > 0
                newByte = read(s, 1, "uint8");
                buf = [buf, newByte];
                
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
        
        if ~ishandle(hLine)
            break;
        end
        
        % 2. Дочитуємо решту кадру (2048 байт)
        bytesNeeded = bytesPerFrame - numel(buf);
        while bytesNeeded > 0 && ishandle(hLine)
            if s.NumBytesAvailable > 0
                bytesToRead = min(bytesNeeded, s.NumBytesAvailable);
                rest = read(s, bytesToRead, "uint8");
                buf = [buf, rest];
                bytesNeeded = bytesPerFrame - numel(buf);
            else
                pause(0.01);
            end
        end
        
        % 3. Перетворюємо байти у uint16 та оновлюємо графік
        if ishandle(hLine) && numel(buf) == bytesPerFrame
            % Збираємо uint16 з байтів
            adc_values = typecast(buf, 'uint16');
            
            % Оновлюємо дані на графіку
            set(hLine, 'YData', adc_values);
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