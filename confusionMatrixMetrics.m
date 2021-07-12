function [accuracy, precision, sensitivity] = confusionMatrixMetrics(orig_times, detect_times) 
    orig_ctr = 1;
    detect_ctr = 1;
    e = 0.6;
    TP = 0;
    FN = 0;
    FP = 0;

    for i = 1 : length(detect_times)
        if (abs(orig_times(orig_ctr) - detect_times(detect_ctr)) < e)
            TP = TP + 1;
            orig_ctr = orig_ctr + 1;
            detect_ctr = detect_ctr + 1;
        elseif (detect_times(detect_ctr) - orig_times(orig_ctr) > e)
            FN = FN + 1;
            orig_ctr = orig_ctr + 1;
        elseif (orig_times(orig_ctr) - detect_times(detect_ctr) > e)
            FP = FP + 1;
            detect_ctr = detect_ctr + 1;
        end
    end

    fprintf('TP: %d\n', TP)
    fprintf('FN: %d\n', FN)
    fprintf('FP: %d\n', FP)

    accuracy = TP / (TP + FN + FP);
    precision = TP / (TP + FP);
    sensitivity = TP / (TP + FN);
    specificity = 0; % ??
end