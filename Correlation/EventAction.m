classdef (Abstract = true) EventAction < handle
    
    properties (SetAccess = protected)
        
        NextOccurrence;
        
    end
    
    methods
        
        % Constructor
        function obj = EventAction(nextOccurrence)
            obj.NextOccurrence = nextOccurrence;
        end
        
        % NextOccurrence getter
        function nextOccurrence = get.NextOccurrence(obj)
            nextOccurrence = obj.NextOccurrence;
        end
        
    end
    
    methods (Abstract = true)
        
        obj = execute(obj);
        
    end
    
end