classdef TemperatureMonitor < ProximityMonitor
   
    methods
        
        function obj = TemperatureMonitor(boundary)
            obj = obj@ProximityMonitor('temperature', boundary);
        end
        
        function wasClose = wasClose(obj, component1, component2, sampleIndex)
            
            wasClose = (obj.getDistance(component1, component2, sampleIndex) <= obj.Boundary);
            
        end
        
        function value = getDistance(obj, component1, component2, sampleIndex)
            
            t1 = component1.getDataFieldHistory(obj.Label);
            t2 = component2.getDataFieldHistory(obj.Label);
            
            value = abs(t1(sampleIndex) - t2(sampleIndex));
            
        end
        
    end
    
end