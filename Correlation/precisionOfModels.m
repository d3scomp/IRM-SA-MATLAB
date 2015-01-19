function precisionOfModels(data, classes)
%PRECISIONOFMODELS trains the models on the portions of the given data. The
%portion is increasing for each model. There is a plot created that
%illustrates the accuracy of the models based on the number of samples.

knnc = KNNClassification();
rtc = RegTreeClassification();

measurementCnt = 1;
knnVariants = [5 20 100];
sampleLengths = zeros(1, measurementCnt);
successRates = zeros(measurementCnt, size(knnVariants, 2) + 1);

for i = 1:measurementCnt
    sampleLength = floor(size(classes, 2)/(measurementCnt-i+1));
    subData = data(1:sampleLength,:);
    subClasses = classes(1:sampleLength);
    fprintf('Sample length: %d\n', sampleLength);
    
    sampleLengths(i) = sampleLength;
    successRates(i, 1) = rtc.learnAndTest(subData, subClasses);
    fprintf('Success rate: %0.3f\n', successRates(i, 1));
    for j = 1:size(knnVariants, 2);
        successRates(i, j+1) = knnc.learnAndTest(subData, subClasses, knnVariants(j));
        fprintf('Success rate: %0.3f\n', successRates(i, j+1));
    end
end

figure('Name', 'Success rate');
hold all;
for i = 1:(size(knnVariants, 2)+1)
    plot(sampleLengths, successRates(:,i), 'x');
end
hold off;

end

