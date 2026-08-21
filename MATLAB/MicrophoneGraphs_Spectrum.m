clear; close all; clc;

%% Налаштування
portName = "COM5";
baudRate = 9600;
N = 512; % Number of points (FFT_SAMPLES/2)
marker = uint8([0xAA 0xBB 0xCC 0xDD]); % Start marker
bytesPerFrame = N * 4;   % 2048 bytes (512 float32 * 4 байти)

%% Opening port
s = serialport(portName, baudRate);
configureTerminator(s, "LF");
flush(s);

%% Налаштування графіка (виконується один раз)
figure('Name', 'Real-time Spectrum', 'NumberTitle', 'off');
Fs = 8e6 / 492;   % ≈ 16260.16 Гц
f = (0:N-1) * Fs / (2*N);

% Створюємо початковий графік (нулями) і зберігаємо вказівник на лінію у змінну hLine
hLine = plot(f, zeros(1, N));
xlabel('Частота, Гц');
ylabel('Амплітуда');
title('Спектр сигналу з A0 (STM32F411)');
grid on;

% Фіксуємо масштаб осі Y, щоб графік не "стрибав" при кожному оновленні
% ylim([0, 500]); % Підлаштуй це значення під реальні амплітуди твого сигналу

disp('Читання даних... Закрий вікно графіка, щоб зупинити.');

%% Головний цикл оновлення
% Цикл працює доти, доки існує вікно графіка (ishandle(hLine))
try
    while ishandle(hLine)
        found = false;
        buf = uint8([]);
        
        % 1. Шукаємо маркер початку кадру
        while ~found && ishandle(hLine)
            if s.NumBytesAvailable > 0
                newByte = read(s, 1, "uint8");
                buf = [buf, newByte];
                
                % Перевіряємо, чи є в буфері наш маркер
                if length(buf) >= 4
                    idx = strfind(buf, marker);
                    if ~isempty(idx)
                        % Відкидаємо все до маркера включно, залишаємо лише дані
                        buf = buf(idx(end)+4:end); 
                        found = true;
                    end
                end
            else
                pause(0.01); % Робимо паузу, щоб не перевантажувати процесор ПК
            end
        end
        
        % Якщо вікно закрили під час очікування — виходимо з циклу
        if ~ishandle(hLine)
            break;
        end
        
        % 2. Дочитуємо решту кадру (2048 байт = 512 float32)
        bytesNeeded = bytesPerFrame - numel(buf);
        while bytesNeeded > 0 && ishandle(hLine)
            if s.NumBytesAvailable > 0
                % Читаємо стільки, скільки є в буфері, але не більше ніж потрібно
                bytesToRead = min(bytesNeeded, s.NumBytesAvailable);
                rest = read(s, bytesToRead, "uint8");
                buf = [buf, rest];
                bytesNeeded = bytesPerFrame - numel(buf);
            else
                pause(0.01);
            end
        end
        
        % 3. Перетворюємо байти та оновлюємо графік
        % 3. Перетворюємо байти та оновлюємо графік
        if ishandle(hLine) && numel(buf) == bytesPerFrame
            spectrum = typecast(buf, 'single');
            
            % Оновлюємо лише дані по осі Y
            set(hLine, 'YData', spectrum);
            
            % --- НОВИЙ БЛОК: Динамічний масштаб осі Y ---
            currentMax = max(spectrum);
            if currentMax > 450
                ylim([0, currentMax * 1.1]); % Розширюємо межу + 10% запасу зверху
            else
                ylim([0, 500]); % Повертаємось до базового масштабу, якщо сигнал впав
            end
            % --------------------------------------------
            
            % Малюємо оновлення на екрані
            drawnow limitrate;
        end
    end
catch ME
    disp('Error:');
    disp(ME.message);
end

%% Closing port 
clear s;
disp('Порт закрито, програму зупинено.');