classdef PositionMonitor < ProximityMonitor
	% PositionMonitor class extends the ProximityMonitor class and represents
	% a calculator that can indicate for two data values whether they are "close"
	% or "far" based on the specified boundary. The PositionMonitor class
	% defines a metric for the position data values.
	
    properties (SetAccess = private)
        CoordinateX; % The label of data of a component representing the X coordinate of its position
        CoordinateY; % The label of data of a component representing the Y coordinate of its position
    end
        
    methods
        function obj = PositionMonitor(boundary)
		% Constructs an instance of the PositionMonitor class.
		% The given boundary will delimit the notion of "close" and "far" for
		% the instance.
            obj = obj@ProximityMonitor('positionX', boundary); % Invoke the constructor of the super class
            obj.CoordinateX = 'positionX';
            obj.CoordinateY = 'positionY';
        end
        
        function wasClose = wasClose(obj, component1, component2, sampleIndex)
        % WASCLOSE indicates whether the data values in the component1 and component2
		% that are stored in vectors labeled by PositionMonitor.CoordinateX and
		% PositionMonitor.CoordinateY at the index sampleIndex are "close" (true)
		% or "far" (false) based on the specified PositionMonitor.Boundary value.
            distance = obj.getDistance(component1, component2, sampleIndex);          
            wasClose = (distance <= obj.Boundary);
        end
        
        function value = getDistance(obj, component1, component2, sampleIndex)
        % GETDISTANCE compute the distance between the position of component1
		% and component2 at the time given by sampleIndex. The position of a
		% component is stored in data vectors labeled by PositionMonitor.CoordinateX
		% and PositionMonitor.CoordinateY. The metric of the distance is euclidean
		% distance.
            x1 = component1.getDataFieldHistory(obj.CoordinateX);
            x2 = component2.getDataFieldHistory(obj.CoordinateX);
            y1 = component1.getDataFieldHistory(obj.CoordinateY);
            y2 = component2.getDataFieldHistory(obj.CoordinateY);
            
            value = sqrt((x1(sampleIndex) - x2(sampleIndex))^2 ...
                          + (y1(sampleIndex) - y2(sampleIndex))^2);     
        end
    end
end