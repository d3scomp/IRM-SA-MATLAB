function precisionOfModels(allData, allClasses)
%PRECISIONOFMODELS trains the models on the portions of the given data. The
%portion is increasing for each model. There is a plot created that
%illustrates the accuracy of the models based on the number of samples.

knnc = KNNClassification();

sampleLengths = generateSampleLengths(size(allClasses, 1));

plotRates = zeros(size(sampleLengths, 2), size(allData, 3));

for r = 1:size(allData, 3)
%    load(sprintf('simulationData_run%d.mat', r));
    data = allData(:,:,r);
    classes = transpose(allClasses(:,r));
    fprintf('Data length: %d\n', size(classes, 1));
    
    testData = data(floor(size(data, 1)/2):size(data, 1),:);
    testCls = classes(floor(size(classes, 2)/2):size(classes, 2));
    fprintf('Test data length: %d\n', size(testCls, 1));

    for i = 1:size(sampleLengths, 2)
        sampleLength = sampleLengths(i);
        trainData = data(1:sampleLength,:);
        trainCls = classes(1:sampleLength);
        fprintf('Train data length: %d\n', sampleLength);
        
        plotRates(i, r) = knnc.learnAndTest(trainData, trainCls, ...
            testData, testCls, 20);
        fprintf('Success rate: %0.3f\n', plotRates(i, r));
    end
end

% save('plotData.mat', 'plotRates', 'sampleLengths');

figure('Name', 'Variants');
boxplot(transpose(plotRates)*100, 'labels', sampleLengths);
xlabel('Number of Training Samples');
ylabel('Prediction Accuracy (%)');

end

function sampleLengths = generateSampleLengths(maxSampleCnt)
% GENERATESAMPLELENGTHS prepares an array containing "logaritmic" scale of
% sample lengths on which prediction models will be sequentially trained.
    scale = [100 200 500];
    scaleEnd = size(scale, 2);
    sampleLengths = [50];
    
    while scale(scaleEnd) < maxSampleCnt
        sampleLengths = [sampleLengths scale];
        scale = scale * 10; % Shift the scale by an order of magnitude
    end
end