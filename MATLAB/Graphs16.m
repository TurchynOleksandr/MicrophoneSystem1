clear; close all; clc;

%% Settings
portName = "COM5";
baudRate = 115200;
NUM_CHANNELS = 16;
SAMPLES_PER_CHANNEL = 256;

marker = uint8([0xAA 0xBB 0xCC 0xDD]);

% Package: marker(4) + chanel index(1) + samples(SAMPLES_PER_CHANNEL * 2)
channelIndexBytes = 1;
samplesBytes = SAMPLES_PER_CHANNEL * 2;
packetPayloadLen = channelIndexBytes + samplesBytes;   % without marker
packetTotalLen = 4 + packetPayloadLen;                 % with marker

%% Opening port
s = serialport(portName, baudRate);
s.InputBufferSize = 65536;
flush(s);

%% Setting graphs
figure('Name', 'Real-time ADC (16 Channels)', 'NumberTitle', 'off', ...
       'Position', [50 0 1200 800]);

tl = tiledlayout(4, 4, 'TileSpacing', 'compact', 'Padding', 'compact');
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

rxBuf = uint8([]);

%% Main cycle
try
    while all(isgraphics(hLines))

        % 1. Reading all
        nAvail = s.NumBytesAvailable;
        if nAvail > 0
            newData = read(s, nAvail, "uint8");
            rxBuf = [rxBuf, newData]; 
        else
            pause(0.005);
            continue;
        end

        % 2. Waiting for one package
        if numel(rxBuf) < packetTotalLen
            continue;
        end

        % 3. Searching for markers
        idx = strfind(rxBuf, marker);

        if isempty(idx)
            % Protecting from infinity buffer if there is no next
            if numel(rxBuf) > 4 * packetTotalLen
                rxBuf = rxBuf(end - packetTotalLen + 1:end);
            end
            continue;
        end

        % Getting the last marker
        validStart = idx(idx + 4 + packetPayloadLen - 1 <= numel(rxBuf));
        if isempty(validStart)
            rxBuf = rxBuf(idx(end):end);
            continue;
        end

        payloadStart = validStart(end) + 4;
        chIndex = double(rxBuf(payloadStart));

        sampleBytesStart = payloadStart + channelIndexBytes;
        sampleBytes = rxBuf(sampleBytesStart : sampleBytesStart + samplesBytes - 1);

        rxBuf = rxBuf(sampleBytesStart + samplesBytes:end);

        % 4. Checking index
        if chIndex >= 0 && chIndex < NUM_CHANNELS
            samples = typecast(sampleBytes, 'uint16');
            set(hLines(chIndex + 1), 'YData', double(samples));
            drawnow limitrate;
        else
            fprintf('[!] Recieved incorrect chanel index: %d \n', chIndex);
        end
    end
catch ME
    disp('Error:');
    disp(ME.message);
end

%% Closing port
clear s;
disp('Port closed.');