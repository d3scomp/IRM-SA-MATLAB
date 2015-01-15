classdef RegTreeClassification
    %REGTREECLASSIFICATION defines methods for data classification based on the
    %regression tree method.
    %   An instance of this class needs to learn on some data sample at
    %   first. Then it provides methods for classification of given data.
    
    properties
        TrainPercentage; % The percentage of data that will be used for the training. The rest will be used for testing.
    end
    
    properties (Constant)
        plotClasses = false; % Indicates whether the classes of data will be plotted.
    end
    
    methods
        function obj = RegTreeClassification()
        % REGTREECLASSIFICATION constructs an instance of the class.
        % There is also defined the percentage of data that is used
        % for training the model. The rest of the data will be used
        % to test the model.
            obj.TrainPercentage = 0.5;
        end
        
        function successRate = learnAndTest(obj, components, monitors, targetMonitor)
        % LEARNANDTEST trains the model for the classification.
        % The training follows these steps:
        %  1) The data for the training is prepared
        %    a) Training data are distances measured by the given monitors
        %    b) Each monitor is associated with one type of data and
        %       defines the metric over these data. The distances are
        %       allways measured on the data samples from two components
        %       taken at the same time
        %    c) The distances are taken from all the pairs of the components
        %    d) All the distances measured by the given monitors are used
        %       as the input training data
        %    e) The targetMonitor is used to classify the data "close"/"far"
        %  2) The model is trained on RegTreeClassification.TrainPercentage
        %     of the data 
        %  3) The rest of the data is used for testing the prediction
        %  4) The success rate of the prediction test is returned
            trainData = [];
            trainDataHits = [];
            trainDataMisses = [];
            testData = [];
            testDataHits = [];
            testDataMisses = [];
            trainCls = [];
            testCls = [];
            componentsCnt = size(components,2);
            trainEnd = intmax;
            testEnd = intmax;
            
            fprintf('Classifying using regression tree method ...\n');
            
            % Find the shortest data vector among all the data vectors in the components and remember its length 
            for i = 1:componentsCnt
                c1 = components(i);
                trainEnd = min(trainEnd, floor(obj.TrainPercentage * c1.getMinDataFieldLength()));
                testEnd = min(testEnd, c1.getMinDataFieldLength());
            end
            
            % Gather the vector of classified data among all the pairs of components
            for i = 1:componentsCnt % Do the computation for all the pairs of components - Component 1
                    c1 = components(i);
                    for j = (i+1):componentsCnt % Do the computation for all the pairs of components - Component 2
                        c2 = components(j);
                        classificationData = targetMonitor.classify(c1, c2);
                        trainCls = [trainCls, classificationData(1:trainEnd)];
                        testCls = [testCls, classificationData(trainEnd:testEnd)];
                    end
            end
            
            % Prepare the input for each monitor among all the pairs of components
            for mIndex = 1:size(monitors, 2) % For each monitor prepare one input data "attribute" values
                monitor = monitors(mIndex);
                monitorTrainData = [];
                monitorTestData = [];
                for i = 1:componentsCnt % Do the computation for all the pairs of components - Component 1
                    c1 = components(i);
                    for j = (i+1):componentsCnt % Do the computation for all the pairs of components - Component 2
                        c2 = components(j);
                        distances = monitor.distances(c1, c2);
                        monitorTrainData = [monitorTrainData, distances(1:trainEnd)];
                        monitorTestData = [monitorTestData, distances(trainEnd:testEnd)];
                    end
                end
                trainData = [trainData; monitorTrainData];
                testData = [testData; monitorTestData];
            end
            
            if obj.plotClasses
                % Separate the data for the visualization in a plot
                for i = 1:size(trainCls, 2)
                    if trainCls(i)
                        trainDataHits = [trainDataHits, trainData(:,i)];
                    else
                        trainDataMisses = [trainDataMisses, trainData(:,i)];
                    end
                end
                for i = 1:size(testCls, 2)
                    if testCls(i)
                        testDataHits = [testDataHits, testData(:,i)];
                    else
                        testDataMisses = [testDataMisses, testData(:,i)];
                    end
                end

                fprintf('Train data dimensions (hits): [%d:%d]\n', size(trainDataHits, 1), size(trainDataHits, 2));
                fprintf('Train data dimensions (misses): [%d:%d]\n', size(trainDataMisses, 1), size(trainDataMisses, 2));
                % Plot the class distribution depending on the first two attributes
                figure('Name', 'Regression Tree');
                hold on;
                title('Train');
                plot(trainDataHits(1,:), trainDataHits(2,:), 'rx', trainDataMisses(1,:), trainDataMisses(2,:), 'bo');
                hold off;
                figure('Name', 'Regression Tree');
                hold on;
                title('Test');
                plot(testDataHits(1,:), testDataHits(2,:), 'rx', testDataMisses(1,:), testDataMisses(2,:), 'bo');
                hold off;
                % Plot the class distribution depending on the first three attributes
%                scatter3(trainDataHits(1,:), trainDataHits(2,:), trainDataHits(3,:));
%                scatter3(trainDataMisses(1,:), trainDataMisses(2,:), trainDataMisses(3,:));
            end

            % Train the model
            mdl = fitrtree(transpose(trainData), trainCls);
            
            % Test data prediction
            predictedCls = predict(mdl, transpose(testData));
            
            hits = 0;
            for i = 1:size(testData, 2)
                if testCls(i) == predictedCls(i);
                    hits = hits + 1;
                end
            end
            
            fprintf('Classification completed.\n');
            
            successRate = hits / size(testData, 2);
        end
    end
    
end

