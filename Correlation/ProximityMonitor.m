classdef (Abstract = true) ProximityMonitor
    
    properties (SetAccess = protected)
        
        Label;
        Boundary;
        
    end
    
    methods
       
        function obj = ProximityMonitor(label, boundary)
            obj.Label = label;
            obj.Boundary = boundary;
        end
        
        function [closePercentage, farPercentage, closeMean, closeStd, farMean, farStd] = ...
                calculateProximityStats(firstMonitor, components, secondMonitor)
            
            componentsCnt = size(components,2);
            entriesCnt = size(components(1).getDataFieldHistory(firstMonitor.Label),2);
            
            closeMatches = zeros(0, componentsCnt * size(components(1),2) * entriesCnt);
            closeMatchesCnt = 0;
            closeMisses = zeros(0, componentsCnt * size(components(1),2) * entriesCnt);
            closeMissesCnt = 0;
            farMatches = zeros(0, componentsCnt * size(components(1),2) * entriesCnt);
            farMatchesCnt = 0;
            farMisses = zeros(0, componentsCnt * size(components(1),2) * entriesCnt);
            farMissesCnt = 0;
            
            fprintf('Dependencies Stats:     ');
            progress = 0;
            loopsCnt = ProximityMonitor.numberOfLoops(firstMonitor, secondMonitor, components);
            steps = 1;

            for i = 1:componentsCnt
                c1 = components(i);
                for j = (i+1):componentsCnt
                    c2 = components(j);
                    index = 1;
                    while firstMonitor.indexInBounds(c1, c2, index) ...
                            && secondMonitor.indexInBounds(c1, c2, index)
                        if firstMonitor.wasClose(c1, c2, index)
                            if secondMonitor.wasClose(c1, c2, index)
                                closeMatchesCnt = closeMatchesCnt + 1;
                                closeMatches(closeMatchesCnt) = ...
                                    secondMonitor.getDistance(c1, c2, index);
                            else
                                closeMissesCnt = closeMissesCnt + 1;
                                closeMisses(closeMissesCnt) = ...
                                    secondMonitor.getDistance(c1, c2, index);
                            end
                        else
                            if secondMonitor.wasClose(c1, c2, index)
                                farMatchesCnt = farMatchesCnt + 1;
                                farMatches(farMatchesCnt) = ...
                                    secondMonitor.getDistance(c1, c2, index);
                            else
                                farMissesCnt = farMissesCnt + 1;
                                farMisses(farMissesCnt) = ...
                                    secondMonitor.getDistance(c1, c2, index);
                            end
                        end
                        index = index + 1;
                        
                        if(floor(progress) ~= floor((steps/loopsCnt)*100))
                            progress = (steps/loopsCnt)*100;
                            fprintf('\b\b\b\b');
                            fprintf('%3.0f%%', progress);
                        end
                        steps = steps + 1;
                    end
                end
            end
            
            fprintf('\n');

            closePercentage = closeMatchesCnt / (closeMatchesCnt + closeMissesCnt);
            farPercentage = farMatchesCnt / (farMatchesCnt + farMissesCnt);
            
            closeValues = [closeMatches(1:closeMatchesCnt), ...
                           closeMisses(1:closeMissesCnt)];
            farValues = [farMatches(1:farMatchesCnt), ...
                         farMisses(1:farMissesCnt)];
            
            closeMean = mean(closeValues);
            closeStd = std(closeValues);
            farMean = mean(farValues);
            farStd = std(farValues);
            
        end
       
        function [closeSegments, farSegments] = scanProximity(obj, component1, component2)
            
            closeSegments = [];
            farSegments = [];
            segment = DataSegment(1);
            index = 1;
            close = wasClose(component1, component2, 1);
            
            while obj.indexInBounds(component1, component2, index)
                    
                if wasClose(component1, component2, index) ~= close
                    segment.Finish = index-1;
                    if close
                        closeSegments = [closeSegments, segment];
                    else
                        farSegments = [farSegments, segment];
                    end
                    segment = DataSegment(index);
                    close = ~close;
                end
                
                index = index + 1;
            
            end
        
        end
        
    
    end
    
    methods (Access = protected)
        
        function inBounds = indexInBounds(obj, component1, component2, sampleIndex)
        
            inBounds = (sampleIndex <= size(component1.getDataFieldHistory(obj.Label),2) ...
                    && sampleIndex <= size(component2.getDataFieldHistory(obj.Label),2));
            
        end
        
    end
    
    methods (Access = protected, Static = true)
       
        function loopsCnt = numberOfLoops(monitor1, monitor2, components)
            
            loopsCnt = 0;
            
            componentsCnt = size(components,2);
            for i = 1:componentsCnt
                c1 = components(i);
                for j = (i+1):componentsCnt
                c2 = components(j);
                loopsCnt = loopsCnt + ...
                            min( ...
                                min( ...
                                    size(c1.getDataFieldHistory(monitor1.Label),2), ...
                                    size(c2.getDataFieldHistory(monitor1.Label),2)), ...
                                min( ...
                                    size(c1.getDataFieldHistory(monitor2.Label),2), ...
                                    size(c2.getDataFieldHistory(monitor2.Label),2)));
                end
            end
        end
        
        function [firstSorted, secondPermuted] = sortPermute(firstArray, secondArray, low, high)
            
            firstSorted = firstArray;
            secondPermuted = secondArray;
            
            pivot = firstSorted(ceil((low + high) / 2));
            left = low;
            right = high;
            
            while left <= right
                while firstSorted(left) < pivot && left < high
                    left = left + 1;
                end
                while firstSorted(right) > pivot && right > low
                    right = right - 1;
                end
                
                if left <= right
                    pom = firstSorted(left);
                    firstSorted(left) = firstSorted(right);
                    firstSorted(right) = pom;
                    pom = secondPermuted(left);
                    secondPermuted(left) = secondPermuted(right);
                    secondPermuted(right) = pom;
                    left = left + 1;
                    right = right - 1;
                end
            end
            
            if right > low
                [firstSorted, secondPermuted] = ProximityMonitor.sortPermute( ...
                    firstSorted, secondPermuted, low, right);
            end
            if left < high
                [firstSorted, secondPermuted] = ProximityMonitor.sortPermute( ...
                    firstSorted, secondPermuted, left, high);
            end
            
        end
        
    end
    
    methods (Abstract = true)
       
        wasClose = wasClose(obj, component1, component2, sampleIndex);
        value = getDistance(obj, component1, component2, sampleIndex);
        
    end
    
end