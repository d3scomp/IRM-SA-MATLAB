classdef PositionMonitor < ProximityMonitor

    properties (SetAccess = private)
    
        Label1;
        Label2;
        
    end
        
    methods
        
        function obj = PositionMonitor(boundary)
            obj = obj@ProximityMonitor('positionX', boundary);
            obj.Label1 = obj.Label;
            obj.Label2 = 'positionY';
        end
        
        function wasClose = wasClose(obj, component1, component2, sampleIndex)
            
            distance = obj.getDistance(component1, component2, sampleIndex);          
            wasClose = (distance <= obj.Boundary);
            
        end
        
        function value = getDistance(obj, component1, component2, sampleIndex)
        
            x1 = component1.getDataFieldHistory(obj.Label1);
            x2 = component2.getDataFieldHistory(obj.Label1);
            y1 = component1.getDataFieldHistory(obj.Label2);
            y2 = component2.getDataFieldHistory(obj.Label2);
            
            value = sqrt((x1(sampleIndex) - x2(sampleIndex))^2 ...
                          + (y1(sampleIndex) - y2(sampleIndex))^2);
            
        end
        
    end
    
end