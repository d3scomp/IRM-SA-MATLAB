function precisionOfModels(data, classes)
%PRECISIONOFMODELS trains the models on the portions of the given data. The
%portion is increasing for each model. There is a plot created that
%illustrates the accuracy of the models based on the number of samples.

knnc = KNNClassification();
rtc = RegTreeClassification();


sampleLengths = [1000 5000 10000 50000 100000];
knnVariants = [5 20 100];
successRates = zeros(size(sampleLengths, 2), size(knnVariants, 2) + 1);
plotLegends = {'Regression Tree', '5-nearest neighbors', '20-nearest neighbors', '100-nearest neighbors'};

permutation = randperm(size(data, 1));
shuffData = data(permutation,:);
shuffClasses = classes(permutation);

for i = 1:size(sampleLengths, 2)
    sampleLength = sampleLengths(i);
    subData = shuffData(1:sampleLength,:);
    subClasses = shuffClasses(1:sampleLength);
    fprintf('Sample length: %d\n', sampleLength);
    
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
    plot(sampleLengths, successRates(:,i));
end
legend(plotLegends);
hold off;

end

