clear; close all; clc; %[cite: 6]

%% Налаштування
portName = "COM5";       % Заміни на свій порт[cite: 6]
baudRate = 9600;         % Швидкість UART[cite: 6]
N = 1024;                % Кількість семплів з АЦП[cite: 6]
marker = uint8([0xAA 0xBB 0xCC 0xDD]); % Маркер початку кадру[cite: 6]
bytesPerFrame = N * 2;   % 2048 байт (1024 uint16 * 2 байти)[cite: 6]

% Приблизна частота дискретизації АЦП для осі частот.
% Якщо таймер налаштований інакше, заміни на своє значення.
Fs = 16000;              

%% Відкриваємо порт
s = serialport(portName, baudRate); %[cite: 6]
configureTerminator(s, "LF"); %[cite: 6]
flush(s); %[cite: 6]

%% Налаштування ПЕРШОГО вікна (Сигнал у часі)
fig1 = figure('Name', 'Real-time ADC Waveform', 'NumberTitle', 'off'); %[cite: 6]
t = 1:N; % Вісь X (просто номери семплів)[cite: 6]

hLine1 = plot(t, zeros(1, N)); %[cite: 6]
xlabel('Номер семплу'); %[cite: 6]
ylabel('Значення АЦП (0 - 4095)'); %[cite: 6]
title('Сигнал з аналогового каналу (Сирі дані)'); %[cite: 6]
grid on; %[cite: 6]
ylim([0, 4100]); %[cite: 6]

%% Налаштування ДРУГОГО вікна (Спектр)
fig2 = figure('Name', 'Real-time Spectrum', 'NumberTitle', 'off');
f = Fs*(0:(N/2))/N; % Фізична вісь частот (в Герцах)

hLine2 = plot(f, zeros(1, N/2 + 1));
xlabel('Частота (Гц)');
ylabel('Амплітуда');
title('Спектр сигналу (ШПФ)');
grid on;
ylim([0, 100]); % Базовий масштаб спектра

disp('Читання даних... Закрий БУДЬ-ЯКЕ вікно графіка, щоб зупинити.'); %[cite: 6]

%% Головний цикл оновлення
buf = uint8([]); 

try %[cite: 6]
    % Працюємо, поки обидва вікна залишаються відкритими
    while ishandle(hLine1) && ishandle(hLine2) 
        
        % 1. Читаємо всі доступні дані одразу
        if s.NumBytesAvailable > 0
            newBytes = read(s, s.NumBytesAvailable, "uint8");
            buf = [buf, newBytes];
        end
        
        % 2. Перевіряємо чи є цілий кадр
        if numel(buf) >= (4 + bytesPerFrame)
            
            idx = strfind(buf, marker); %[cite: 6]
            if ~isempty(idx) %[cite: 6]
                last_idx = idx(end);
                
                if numel(buf) >= (last_idx + 3 + bytesPerFrame)
                    
                    % Витягуємо сирі дані з АЦП
                    frameData = buf(last_idx+4 : last_idx+3+bytesPerFrame);
                    adc_values = typecast(frameData, 'uint16'); %[cite: 6]
                    
                    %% --- Оновлення Графіка 1 (Сигнал) ---
                    set(hLine1, 'YData', adc_values); %[cite: 6]
                    
                    %% --- Обчислення та оновлення Графіка 2 (Спектр) ---
                    % Видаляємо постійну складову (DC offset)
                    adc_double = double(adc_values);
                    adc_zero_mean = adc_double - mean(adc_double);
                    
                    % Виконуємо вбудоване перетворення Фур'є в MATLAB
                    Y = fft(adc_zero_mean);
                    
                    % Рахуємо реальні амплітуди (односторонній спектр)
                    P2 = abs(Y / N);
                    P1 = P2(1 : N/2+1);
                    P1(2:end-1) = 2 * P1(2:end-1);
                    
                    set(hLine2, 'YData', P1);
                    
                    % Динамічний масштаб осі Y для спектра
                    currentMax = max(P1);
                    if currentMax > 50
                        ylim(hLine2.Parent, [0, currentMax * 1.1]);
                    else
                        ylim(hLine2.Parent, [0, 50]);
                    end
                    
                    %% --- Відмальовуємо вікна ---
                    drawnow;
                    
                    % Очищаємо оброблений кадр з буфера
                    buf = buf(last_idx + 4 + bytesPerFrame : end);
                end
            else
                if numel(buf) > 3
                    buf = buf(end-2:end);
                end
            end
        end
        
        % Пауза для розвантаження процесора і роботи кнопок інтерфейсу
        pause(0.02); 
    end
catch ME %[cite: 6]
    disp('Виникла помилка:'); %[cite: 6]
    disp(ME.message); %[cite: 6]
end %[cite: 6]

%% Закриття порту
clear s; %[cite: 6]
disp('Порт закрито.'); %[cite: 6]