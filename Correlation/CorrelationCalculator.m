classdef CorrelationCalculator
    
    properties(Access = private, Constant = true)
        Treshold = 0.9; % The treshold of the correlation level.
        SegmentLength = 50; % The number of elements in each segment that is used for the correlation computation.
    end
    
    methods(Static = true)
        
        function correlations = segmentCorrelations(v1, v2)
            [ev1, ev2] = CorrelationCalculator.ensureCompatibility(v1, v2);
            length = size(ev1, 2);
            stepCnt = ceil((size(ev1, 2)-1)/CorrelationCalculator.SegmentLength);
            correlations = zeros(1, stepCnt);
            
            step = 1;
            while step * CorrelationCalculator.SegmentLength < length
                finish = step * CorrelationCalculator.SegmentLength;
                begin = finish - CorrelationCalculator.SegmentLength + 1;
                correlations(step) = CorrelationCalculator.correlation(ev1, ev2, begin, finish);
                step = step + 1;
            end
            if (step-1) * CorrelationCalculator.SegmentLength < length - 1
                begin = (step-1) * CorrelationCalculator.SegmentLength + 1;
                correlations(step) = CorrelationCalculator.correlation(ev1, ev2, begin, length);
            end
            
        end
        
        function value = correlation(varargin)
        % CORRELATION computes the correlation degree between the given
        % vectors.
        %    value = CORRELATION(v1, v2) computes the correlation between
        %    v1 and v2.
        %    value = CORRELATION(v1, v2, begin, end) computes the
        %    correlation between v1 and v2 on the values starting at
        %    'begin' and ending at 'finish'.
            
            switch(nargin)
                case 2
                    begin = 1;
                    finish = size(varargin{1}, 2);
                case 4
                    begin = varargin{3};
                    finish = varargin{4};
                    if(begin >= finish)
                      error('CorrelationCalculator.correlation ''begin'' must be smaller than ''end''.');
                    end
                    if(finish > size(varargin{1}, 2))
                        error('CorrelationCalculator.correlation ''end'' mustn''t be greater than vector size.');
                    end
                    if(begin < 1)
                        error('CorrelationCalculator.correlation ''begin'' mustn''t be smaller than 1.');
                    end
                otherwise
                    error('CorrelationCalculator.correlation called with wrong arguments.');
            end
            
            [ev1, ev2] = CorrelationCalculator.ensureCompatibility(varargin{1}, varargin{2});
            
            if(size(ev1, 2) ~= size(ev2, 2))
                error('CorrelationCalculator.correlation correlation calculation requires the vectors to be the same length.');
            end
            
            n = finish - begin + 1;
            v1 = ev1(begin:finish);
            v2 = ev2(begin:finish);

            sum1 = sum(v1); % sum of elements
            sum2 = sum(v2);
            sum1_2 = sum(v1.^2); % element-wise 2nd power
            sum2_2 = sum(v2.^2);
            sum12 = sum(v1.*v2); % element-wise multiplication

            % Compute the correlation
            value = (n*sum12 - sum1*sum2)/ ...
                   (sqrt(n*sum1_2 - sum1^2)* ...
                    sqrt(n*sum2_2 - sum2^2));
        end
        
        function [v1, v2] = ensureCompatibility(in1, in2)
        % ENSURECOMPATIBILITY if the given vectors doesn't have the same
        % length this function will pick values from the longer vector
        % evenly and returns the vectors with the same length.
        
            length1 = size(in1, 2);
            length2 = size(in2, 2);
        
            if length1 == length2
                v1 = in1;
                v2 = in2;
                return;
            end
            
            if length1 == 0 || length2 == 0
                v1 = [];
                v2 = [];
                return;
            end
        
            if length1 < length2
                shorter = in1;
                longer = in2;
                shorterLength = length1;
                longerLength = length2;
            else
                shorter = in2;
                longer = in1;
                shorterLength = length2;
                longerLength = length1;
            end
            
            shrunken = zeros(1, shorterLength);
            
            step = longerLength / shorterLength;
            for i = 1:shorterLength
                shrunken(i) = longer(round(i*step));
            end
            
            if length1 < length2
                v1 = shorter;
                v2 = shrunken;
            else
                v1 = shrunken;
                v2 = shorter;
            end
        end
        
    end
end








































