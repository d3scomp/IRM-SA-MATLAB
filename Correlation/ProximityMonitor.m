classdef (Abstract = true) ProximityMonitor
	% ProximityMonitor class is an abstract class that represents a calculator
	% that can indicate for two data values whether they are "close" or "far"
	% based on the specified boundary. The ProximityMonitor class needs to be
	% extended in order to define a metric for specific values.
	
    properties (SetAccess = protected)
        Label; % A label that identifies the data for inherited Monitor class.
        Boundary; % The boundary for the metric that delimits the notion of "close" and "far".
    end
    
    methods
        function obj = ProximityMonitor(label, boundary)
		% Constructs the ProximityMonitor object and assigns the given label
		% and boundary to the instance.
            obj.Label = label;
            obj.Boundary = boundary;
        end
        
        function [closePercentage, farPercentage, closeMean, closeStd, farMean, farStd] = ...
                calculateProximityStats(firstMonitor, components, secondMonitor)
        % CALCULATEPROXIMITYSTATUS calculates the percentage of "close" data
		% in the given components using the given secondMonitor. The firstMonitor
		% is used to filter the data for the secondMonitor. The data are filtered
		% for twice. At first only the "close" data (based on the firstMonitor) are
		% used to compute the "close" percentage (based on the secondMonitor). Then
		% the "far" data (based on the firstMonitor) are used to compute the "close"
		% percentage (based on the second monitor). The second computation is for
		% checking the strength of the first percentage. For example if both
		% the percentages are very high then it doesn't mean there is a dependency
		% between the data for the firstMonitor and the data for the secondMonitor.
		% On the other hand if the first percentage is high and the second percentage
		% is low than it means that there is a dependency between the data for
		% the firstMonitor and the data for the secondMonitor.
		% 
		% Parameters:
		%   firstMonitor - Filters the data for the calculations ("far", "close" data).
		%   secondMonitor - Computes the "close" data percentage.
		%   components - Components on which the computation is performed.
		%
		% Returns:
		%   closePercentage - Percentage of "close" data (secondMonitor) of
		%					  "close" data (firstMonitor).
		%   farPercentage - Percentage of "close" data (secondMonitor) of
		%					"far" data (firstMonitor).
		%   closeMean - The mean value of the data distances computed
		%				by the secondMonitor and filtered ("close")
		%				by the firstMonitor.
		%   closeStd - The standard deviation of the data distances computed
		%			   by the secondMonitor and filtered ("close")
		%			   by the firstMonitor.
		%   farMean - The mean value of the data distances computed
		%			  by the secondMonitor and filtered ("far") by the firstMonitor.
		%   farStd - The standard deviation of the data distances computed
		%			 by the secondMonitor and filtered ("far") by the firstMonitor.
            componentsCnt = size(components,2);
            entriesCnt = size(components(1).getDataFieldHistory(firstMonitor.Label),2);
            
            closeMatches = zeros(0, componentsCnt * size(components(1),2) * entriesCnt); % It will store the "close" values (secondMonitor) filtered as "close" (firstMonitor)
            closeMatchesCnt = 0;
            closeMisses = zeros(0, componentsCnt * size(components(1),2) * entriesCnt); % It will store the "far" values (secondMonitor) filtered as "close" (firstMonitor)
            closeMissesCnt = 0;
            farMatches = zeros(0, componentsCnt * size(components(1),2) * entriesCnt); % It will store the "close" values (secondMonitor) filtered as "far" (firstMonitor)
            farMatchesCnt = 0;
            farMisses = zeros(0, componentsCnt * size(components(1),2) * entriesCnt); % It will store the "far" values (secondMonitor) filtered as "far" (firstMonitor)
            farMissesCnt = 0;
            
            fprintf('Dependencies Stats:     ');
            progress = 0;
            loopsCnt = ProximityMonitor.numberOfLoops(firstMonitor, secondMonitor, components);
            steps = 1;

            for i = 1:componentsCnt % Do the computation for all the pairs of components - Component 1
                c1 = components(i);
                for j = (i+1):componentsCnt % Do the computation for all the pairs of components - Component 2
                    c2 = components(j);
                    index = 1;
                    while firstMonitor.indexInBounds(c1, c2, index) ...
                            && secondMonitor.indexInBounds(c1, c2, index) % Cycle over all the data in the vector
                        if firstMonitor.wasClose(c1, c2, index) % firstMonitor "close"
                            if secondMonitor.wasClose(c1, c2, index) % secondMonitor "close"
                                closeMatchesCnt = closeMatchesCnt + 1;
                                closeMatches(closeMatchesCnt) = ...
                                    secondMonitor.getDistance(c1, c2, index);
                            else % secondMonitor "far"
                                closeMissesCnt = closeMissesCnt + 1;
                                closeMisses(closeMissesCnt) = ...
                                    secondMonitor.getDistance(c1, c2, index);
                            end
                        else % firstMonitor "far"
                            if secondMonitor.wasClose(c1, c2, index) % secondMonitor "close"
                                farMatchesCnt = farMatchesCnt + 1;
                                farMatches(farMatchesCnt) = ...
                                    secondMonitor.getDistance(c1, c2, index);
                            else % secondMonitor "far"
                                farMissesCnt = farMissesCnt + 1;
                                farMisses(farMissesCnt) = ...
                                    secondMonitor.getDistance(c1, c2, index);
                            end
                        end
                        index = index + 1;
                        
                        if(floor(progress) ~= floor((steps/loopsCnt)*100)) % Display progress
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
    end
    
    methods (Access = protected)
        function inBounds = indexInBounds(obj, component1, component2, sampleIndex)
        % INDEXINBOUNDS indicates whether the given sampleIndex doesn't exceed
		% the bounds of the data vector in the given components.
            inBounds = (sampleIndex <= size(component1.getDataFieldHistory(obj.Label),2) ...
                    && sampleIndex <= size(component2.getDataFieldHistory(obj.Label),2)); 
        end
    end
    
    methods (Access = protected, Static = true)
        function loopsCnt = numberOfLoops(monitor1, monitor2, components)
		% NUMBEROFLOOPS returns the number of elements, that can be sequentially
		% accessed without exceeding the vector bounds, times the number
		% of components pair combinations. The count represents the number
		% of loops taken in the calculateProximityStats function.
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
		% SORTPERMUTE finds the permutation that sorts the firstArray.
		% The permutation is than applied to the firstArray and the secondArray.
		% It results in sorting the firstArray and permuting the secondArray
		% in such a way, that the elements in the secondArray are on the positions
		% of the corresponding elements in the firstArray as they were in the given arrays.
		%
		% Parameters:
		%   firstArray - The array of elements that will be sorted.
		%   secondArray - The array of elements that will be permuted by the same
		%				  permutation as the firstArray.
		%   low - The index delimiting the start position in the arrays from which
		%		  the sorting begins.
		%   high - The index delimiting the end position in the arrays at which
		%		   the sorting ends.
		%
		% Returns:
		%   firstSorted - The firstArray sorted by the permutation P.
		%    secondPermuted - The secondArray permuted by the permutation P.
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
        wasClose = wasClose(obj, component1, component2, sampleIndex); % Indicate whether the values at sampleIndex in the data vectors denoted by the ProximityMonitor in component1 and component2 are "close".
        value = getDistance(obj, component1, component2, sampleIndex); % Computes the distance of the data values at sampleIndex in the data vectors denoted by the ProximityMonitor in component1 and component2.
    end
end