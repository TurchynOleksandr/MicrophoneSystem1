clear; close all; clc;

%% Налаштування
portName = "COM5";       % заміни на свій порт
baudRate = 9600;
N = 512;                 % кількість точок спектру (FFT_SAMPLES/2)
marker = uint8([0xAA 0xBB 0xCC 0xDD]);

%% Відкриваємо порт
s = serialport(portName, baudRate);
configureTerminator(s, "LF");   % не критично, бо дані бінарні
flush(s);

%% Пошук маркера початку кадру
found = false;
buf = uint8([]);
tic;
while ~found
    if s.NumBytesAvailable > 0
        newByte = read(s, s.NumBytesAvailable, "uint8");
        buf = [buf, newByte];
        idx = strfind(buf, marker);
        if ~isempty(idx)
            % відкидаємо все до маркера включно
            buf = buf(idx(1)+4:end);
            found = true;
        end
    end
    if toc > 5
        error("Маркер не знайдено — перевір підключення/порт/бодрейт");
    end
end

%% Дочитуємо решту кадру (2048 байт = 512 float32)
bytesNeeded = N*4 - numel(buf);
if bytesNeeded > 0
    rest = read(s, bytesNeeded, "uint8");
    buf = [buf, rest];
end

%% Перетворюємо байти у float32
spectrum = typecast(uint8(buf(1:N*4)), 'single');

clear s;  % закриваємо порт

%% Побудова графіка
figure;
Fs = 8e6 / 492;   % ≈ 16260.16 Гц
N = 512;
f = (0:N-1) * Fs / (2*N);

plot(f, spectrum);
xlabel('Частота, Гц');
ylabel('Амплітуда');
title('Спектр сигналу з A0 (STM32F411)');
grid on;
grid on;