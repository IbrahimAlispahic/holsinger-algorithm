clc
close all

no_of_signals = 48;

accuracy = zeros(1, no_of_signals);
precision = zeros(1, no_of_signals);
sensitivity = zeros(1, no_of_signals);

for j = 1 : no_of_signals
    %% Holsigner Algorithm %%
    
    curr_signal = j;
        
    fprintf('Signal No: %d\n', curr_signal);
    load(sprintf('SIGNALS/%d.mat', curr_signal));
    ECG = val(1,:);
    L = length(ECG);
    % sampling time 4ms
    fs = 360;
    start_duration = 0;
    end_duration = L / fs - 1;

    ECG1 = ECG(start_duration * fs + 1 : 1 : end_duration * fs);
    ECG1 = ECG1 - mean(ECG1);
    MLII = (ECG1 - 1024) ./ 200;
    %k = -0.129; %first value that generates 3 consecutive candidates for fs =
    %360
    % experimentaly identified value for k which produces best results
    k = -0.105; 

    [RR_int, detect_times, HR] = holsinger(MLII, start_duration, end_duration, fs, k, false, false);
    %fprintf('Average heart rate: %f\n', HR)
    
    %% Confusion matrix and metrics %%

    fileEntireDataSet = importdata(sprintf('SIGNALS/%d.txt', curr_signal));
    orig_times = fileEntireDataSet(:,1).data;
    orig_label = fileEntireDataSet.textdata(:,2);
    % orig_times = extractBetween(orig_times, 4, 12);
    % orig_times = cell2mat(orig_times);
    % orig_times = str2num(orig_times).';
    orig_times = orig_times(2 : end).';

    [accuracy(j), precision(j), sensitivity(j)] = confusionMatrixMetrics(orig_times, detect_times);
end

metrics = [accuracy; precision; sensitivity];
%plot(accuracy); hold on; plot(precision); hold on; plot(sensitivity);
% mean(accuracy) 
% mean(precision) 
% mean(sensitivity)

%% signal spectrum %%

% n = 2^nextpow2(L);
% f = fs * (0 : 1 : (n/2)) / n;
% fourirerSpectar = fft(MLII, n); %moramo imati 2^potenciju uzoraka, omega ima uzoraka koliko i signal f(n)
% 
% absF = abs(fourirerSpectar / L);
% figure
% grid on
% plot(f, absF(1 : 1 : (n/2)+1))

