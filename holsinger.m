function [RR_int, detect_times, mean_HR] = holsinger(MLII, start_duration, end_duration, fs, k, draw_signal, draw_consecutives_hist)
  
    T = 1 / fs;
    t = 0 : T : (end_duration - start_duration) - T;
    
    if(draw_signal)
        figure
        plot(t, MLII,'Color','black')
        hold on
        lb=round(min(MLII), 1);
        lb=lb-0.2;
        ub=round(max(MLII), 1);
        ub=ub+0.2;
        vl=lb:0.1:ub;
        hl=0:0.04:10;
        axis equal
        ylim([lb,ub])
        xlim([0, end_duration - start_duration])
        xlabel('Vrijeme [s]')
        ylabel('Amplituda [mV]')
        title('EKG signal')
        grid on
    end
    
    peaks = [];
    detector_ctr = 0;
    consecutives = [];
    prev_time = 0;
    RR_int = [];
    detect_times = [];
    for i = 1 : length(MLII) - 1
        delta_A = MLII(i + 1) - MLII(i);
        %modifying k based on detector_ctr value
        if detector_ctr == 3 || detector_ctr == 4
                k = k + 0.001;
            elseif detector_ctr == 7
                k = k - 0.1;
        end
        if delta_A < k
            detector_ctr = detector_ctr + 1;
        else
            %looking for at least 3 consecutive detections
             if detector_ctr >= 3 %&& t(i) - prev_time > (1 / fs) * 4
                 consecutives(end + 1) = detector_ctr;
                 peaks(end + 1) = MLII(i - detector_ctr);
                 RR_int(end + 1) = t(i) - prev_time;
                 detect_times(end + 1) = t(i);
                 if(draw_signal)
                     plot(t(i), peaks(end), '.r', 'MarkerSize', 30)
                 end
                 prev_time = t(i);
                 k = -0.105;
             end
            detector_ctr = 0;
        end
    end
    
    HR = zeros(1, length(RR_int) - 1);
    for i = 1 : length(RR_int) - 1
        HR(i) = 60 / RR_int(i);
    end
    mean_HR = mean(HR);
    
    if draw_consecutives_hist
        figure
        histogram(consecutives);
    end

end