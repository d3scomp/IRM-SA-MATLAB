classdef EventCalendar < handle
   
    properties
        
        Events;
        
    end
    
    methods
        
        % Constructor
        function obj = EventCalendar
            obj.Events = [];
        end
        
        function insert(obj, event)
            obj.Events = [obj.Events, event];
        end
        
        function min = remove(obj)
            minIndex = obj.minIndex();
            if(minIndex == -1)
                min = [];
                return;
            end
            
            min = obj.Events(minIndex);
            obj.Events(minIndex) = [];
        end
        
        function executeNext(obj)
            nextEvent = obj.remove();
            if(isempty(nextEvent))
                return;
            end
            
            nextEvent.EventAction.execute();
            
            % Prepare next occurrence of the event
            nextEvent.nextEvent();
            
            % Plan the event again if required
            if(nextEvent.EventTime ~= -1)
                obj.insert(nextEvent);
            end
        end
        
        function ret = isNext(obj)
            ret = size(obj.Events, 2) > 0;
        end
    end
    
    methods(Access = private)
        function index = minIndex(obj)
            count = size(obj.Events, 2);
            if(count == 0)
                index = -1;
                return;
            end
            
            min = 1;
            for i=1:count
                if(obj.Events(min) > obj.Events(i))
                    min = i;
                end
            end
            index = min;
        end
    end
    
end