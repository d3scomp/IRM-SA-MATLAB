classdef Event < handle
    % Event class represents a single event that can be stored into the EvendCalendar.
    % EventCalendar is a calendar used for the discrete simulation. Each
    % Event has a time in which it will be fired and action that will be
    % invoked at its time.
   
    properties
        EventTime; % The time in which the Event will be fired.
        EventAction; % The action that will be performed at the given time.
    end
    
    methods
        function event = Event(action, time)
            % Create new instance of Event with the given action and time.
            event.EventTime = time;
            event.EventAction = action;
        end
        
        function nextEvent(event)
            % If there is specified the next occurrence (period) of the
            % event in the EventAction then the EventTime of this Event
            % will be shifted to the next time. Otherwise the EventTime
            % is set to -1 which indicates no more occurrences of this
            % Event.
            nextOccurrence = event.EventAction.NextOccurrence;
            if(nextOccurrence ~= -1)
                event.EventTime = event.EventTime + nextOccurrence;
            else
                event.EventTime = -1;
            end
        end
        
        function ret = lt(a, b)
            % Overloaded comparison operator <.
            ret = a.EventTime < b.EventTime;
        end
        function ret = gt(a, b)
            % Overloaded comparison operator >.
            ret = a.EventTime > b.EventTime;
        end
        function ret = le(a, b)
            % Overloaded comparison operator <=.
            ret = a.EventTime <= b.EventTime;
        end
        function ret = ge(a, b)
            % Overloaded comparison operator >=.
            ret = a.EventTime >= b.EventTime;
        end
        function ret = ne(a, b)
            % Overloaded comparison operator ~=.
            ret = a.EventTime ~= b.EventTime;
        end
        function ret = eq(a, b)
            % Overloaded comparison operator ==.
            ret = a.EventTime == b.EventTime;
        end
    end
    
end