function thresholdSelection( thresholds )
%THRESHOLDSELECTION computes the correct/incorrect answers of
%classification prediction models for the given thresholds.
% The numbers are written into a file.

outputFile = 'thresholdsAnswers.txt';
DataLengthLimit = 100000;

knnc = KNNClassification();
rtc = RegTreeClassification();

tpLabel = 'True Positives';
fpLabel = 'False Positives';
tnLabel = 'True Negatives';
fnLabel = 'False Negatives';

permutationBase = randperm(DataLengthLimit);
knnVariants = [5 20 100];
regTreeLabel = 'Regression Tree';
knnLabel = '%d-nearest neighbors';
values = containers.Map();
values(regTreeLabel) = [];
for variant = knnVariants
    values(sprintf(knnLabel, variant)) = [];
end

for t = thresholds
    fprintf('Threshold: %d\n', t);
    load(sprintf('simulationData%ddeg.mat', t));
    sampleLength = min(size(data, 1), DataLengthLimit);
    permutation = permutationBase(1:sampleLength);
    
    shuffData = data(permutation,:);
    shuffClasses = classes(permutation);

    subData = shuffData(1:sampleLength,:);
    subClasses = shuffClasses(1:sampleLength);
    fprintf('Sample length: %d\n', sampleLength);
    
    [truePositives, falsePositives, trueNegatives, falseNegatives] = ...
        rtc.positives(subData, subClasses);
    values(regTreeLabel) = [values(regTreeLabel); t, truePositives, ...
        falsePositives, trueNegatives, falseNegatives];
    fprintf('%s: %d\n', tpLabel, truePositives);
    fprintf('%s: %d\n', fpLabel, falsePositives);
    fprintf('%s: %d\n', tnLabel, trueNegatives);
    fprintf('%s: %d\n', fnLabel, falseNegatives);
    
    for j = knnVariants
        [truePositives, falsePositives, trueNegatives, falseNegatives] = ...
            knnc.positives(subData, subClasses, j);
        values(sprintf(knnLabel, j)) = [values(sprintf(knnLabel, j)); t, ...
            truePositives, falsePositives, trueNegatives, falseNegatives];
        fprintf('%s: %d\n', tpLabel, truePositives);
        fprintf('%s: %d\n', fpLabel, falsePositives);
        fprintf('%s: %d\n', tnLabel, trueNegatives);
        fprintf('%s: %d\n', fnLabel, falseNegatives);
    end
end

fid = fopen(outputFile, 'w');
for k = values.keys
    fprintf(fid, '\n%s\n', k{1});
    fprintf(fid, '%s\t%s\t%s\t%s\t%s\n', 'Threshold', tpLabel, fpLabel, tnLabel, fnLabel);
    v = values(k{1});
    for i = 1:size(v, 1)
        fprintf(fid, '%d\t%d\t%d\t%d\t%d\n', v(i,1), v(i,2), v(i,3), v(i,4), v(i,5));
    end
end
fclose(fid);

end

