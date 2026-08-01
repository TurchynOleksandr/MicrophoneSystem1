portName = 'COM5';
baudRate = 115200;

clear s; 
close all; 
clc;

disp('Connecting UART...');

%Opening port
try
    s = serialport(portName, baudRate);
    % Adding \r\n to the end of lines
    configureTerminator(s, "CR/LF"); 
catch
    error('Reading error');
end

fig = figure('Name', 'STM32 ADC 16 Channels', 'NumberTitle', 'off','Position', [100,100,1200,600]);

lines = gobjects(16, 1);

for i = 1:16
    subplot(4,4,i);
    lines(i) = animatedline('Color', [0 0.4470 0.7410], 'LineWidth', 1.5, 'MaximumNumPoints', 100);
    
    % ПРИБРАНО: ylim([0 4096]); - тепер масштабування буде динамічним
    title(sprintf('CH%d', i-1), 'FontWeight', 'bold');
    grid on;
    
    % Clear X-label
    set(gca, 'XTickLabel', []);
end

disp('Reading from UART started');

tic;

while isgraphics(fig) 
    try
        rawData = readline(s);
        
        if strlength(rawData) > 0
            parsed = sscanf(rawData, 'CH%d: %d');
            
            if length(parsed) == 2
                chIdx = parsed(1);
                adcVal = parsed(2);
                
                if chIdx >= 0 && chIdx <= 15
                    t = toc;
                    currLine = lines(chIdx + 1);
                    addpoints(currLine, t, adcVal);
                    
                    % --- БЛОК АВТОМАСШТАБУВАННЯ ---
                    % Отримуємо значення Y з поточних 100 точок на графіку
                    [~, yData] = getpoints(currLine);
                    
                    if ~isempty(yData)
                        yMin = min(yData);
                        yMax = max(yData);
                        
                        % Захист від помилки MATLAB: межі графіка не можуть бути однаковими
                        if yMin == yMax
                            yMin = max(0, yMin - 10);
                            yMax = min(4096, yMax + 10);
                        else
                            % Додаємо невеликий запас (+/- 50) для наочності, 
                            % але обмежуємо фізичними межами 12-бітного АЦП STM32
                            yMin = max(0, yMin - 50);
                            yMax = min(4096, yMax + 50);
                        end
                        
                        % Застосовуємо нові межі. currLine.Parent вказує на осі (axes) цього графіка
                        ylim(currLine.Parent, [yMin, yMax]);
                    end
                    % ---------------------------------
                end
            end
        end
        
        drawnow limitrate; 
        
    catch ME
        disp('Connection stopped');
        disp(ME.message);
        break;
    end
end

clear s;
disp('Ending...');