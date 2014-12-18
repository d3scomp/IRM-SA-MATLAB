classdef Event < handle
   
    properties
        EventTime;
        EventAction;
    end
    
    methods
        
        % Constructor
        function event = Event(action, time)
            event.EventTime = time;
            event.EventAction = action;
        end
        
        function nextEvent(event)
            nextOccurrence = event.EventAction.NextOccurrence;
            if(nextOccurrence ~= -1)
                event.EventTime = event.EventTime + nextOccurrence;
            else
%                fprintf('\n%d\n    ', event.EventTime);
                event.EventTime = -1;
            end
        end
        
        % Overloading comparision operators
        function ret = lt(a, b)
            ret = a.EventTime < b.EventTime;
        end
        function ret = gt(a, b)
            ret = a.EventTime > b.EventTime;
        end
        function ret = le(a, b)
            ret = a.EventTime <= b.EventTime;
        end
        function ret = ge(a, b)
            ret = a.EventTime >= b.EventTime;
        end
        function ret = ne(a, b)
            ret = a.EventTime ~= b.EventTime;
        end
        function ret = eq(a, b)
            ret = a.EventTime == b.EventTime;
        end
    end
    
end