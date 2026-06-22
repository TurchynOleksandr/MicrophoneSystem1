portName = 'COM5';
baudRate = 9600;

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
    
    ylim([0 4096]);
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
                    addpoints(lines(chIdx + 1), t, adcVal);
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