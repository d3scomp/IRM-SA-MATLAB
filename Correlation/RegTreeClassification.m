classdef RegTreeClassification
    %REGTREECLASSIFICATION defines methods for data classification based on the
    %regression tree method.
    %   An instance of this class needs to learn on some data sample at
    %   first. Then it provides methods for classification of given data.
    
    properties
        TrainPercentage; % The percentage of data that will be used for the training. The rest will be used for testing.
    end
    
    methods
        function obj = RegTreeClassification()
        % REGTREECLASSIFICATION constructs an instance of the class.
        % There is also defined the percentage of data that is used
        % for training the model. The rest of the data will be used
        % to test the model.
            obj.TrainPercentage = 0.5;
        end
        
        function successRate = learnAndTest(obj, data, classes)
        % LEARNANDTEST trains the model for the classification.
        % The regression tree model is trained on a portion of the given
        % data with corresponding classes. The portion is defined by
        % RegTreeClassification.TrainPercentage.
        % The rest of the data and classes is used to test the accuracy of
        % the predicition using the trained model.
            trainEnd = floor(obj.TrainPercentage * size(data, 1));
            testEnd = size(data, 1);
            trainData = data(1:trainEnd,:);
            testData = data(trainEnd:testEnd,:);
            trainCls = classes(1:trainEnd);
            testCls = classes(trainEnd:testEnd);
                        
            fprintf('Classifying using regression tree method ...\n');
            
            % Train the model
            mdl = fitrtree(trainData, trainCls);
            
            % Test data prediction
            predictedCls = predict(mdl, testData);
            
            hits = 0;
            for i = 1:size(testCls, 2)
                if testCls(i) == predictedCls(i);
                    hits = hits + 1;
                end
            end
            
            fprintf('Classification completed.\n');
            
            successRate = hits / size(testCls, 2);
        end
    end
    
end

