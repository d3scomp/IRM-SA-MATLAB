classdef TemperatureMonitor < ProximityMonitor
	% TemperatureMonitor class extends the ProximityMonitor class and represents
	% a calculator that can indicate for two data values whether they are "close"
	% or "far" based on the specified boundary. The TemperatureMonitor class
	% defines a metric for the temperature data values.
   
    methods
        function obj = TemperatureMonitor(boundary)
		% Constructs an instance of the TemperatureMonitor class.
		% The given boundary will delimit the notion of "close" and "far" for
		% the instance.
            obj = obj@ProximityMonitor('temperature', boundary);
        end
        
        function wasClose = wasClose(obj, component1, component2, sampleIndex)
        % WASCLOSE indicates whether the data values in the component1 and component2
		% that are stored in vector labeled by TemperatureMonitor.Label
		% at the index sampleIndex are "close" (true) or "far" (false) based
		% on the specified TemperatureMonitor.Boundary value.
            wasClose = (obj.getDistance(component1, component2, sampleIndex) <= obj.Boundary);
        end
        
        function value = getDistance(obj, component1, component2, sampleIndex)
        % GETDISTANCE compute the distance between the temperature of component1
		% and component2 at the time given by sampleIndex. The value of the
		% component is stored in data vector labeled by TemperatureMonitor.Label.
		% The metric of the distance is a difference of the values.
            t1 = component1.getDataFieldHistory(obj.Label);
            t2 = component2.getDataFieldHistory(obj.Label);
            
            value = abs(t1(sampleIndex) - t2(sampleIndex));
        end
        
        function distances = distances(obj, component1, component2)
        % DISTANCES compute the distances between corresponding temperatures
		% of component1 and component2. The value of the component is stored
        % in data vector labeled by TemperatureMonitor.Label
		% The metric of the distance is a difference of the values.
            t1 = component1.getDataFieldHistory(obj.Label);
            t2 = component2.getDataFieldHistory(obj.Label);
            dataLength = obj.dataBounds(component1, component2);
            
            distances = abs(t1(1:dataLength) - t2(1:dataLength));
        end
    end
end