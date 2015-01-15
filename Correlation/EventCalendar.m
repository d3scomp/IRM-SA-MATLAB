classdef EventCalendar < handle
	% EventCalendar class represents the calendar for discrete simulation.
	% The calendar holds the events that will happen in the simulation.
	% Any event can be added into the calendar. The event with the smallest
	% time can be always removed.
   
    properties        
        Events; % An array of events in the calendar.
    end
    
    methods
        function obj = EventCalendar
		% Constructs the EventCalendar instance.
		% The new instance contains no events.
            obj.Events = [];
        end
        
        function insert(obj, event)
		% INSERT adds the given event into the calendar.
            obj.Events = [obj.Events, event];
        end
        
        function min = remove(obj)
		% REMOVE deletes the earliest event from the calendar and return it.
            minIndex = obj.minIndex();
            if(minIndex == -1)
                min = [];
                return;
            end
            
            min = obj.Events(minIndex);
            obj.Events(minIndex) = [];
        end
        
        function repeated = executeNext(obj)
		% EXECUTENEXT executes the next (earliest) event in the calendar and removes it
		% from the calendar. If the event is periodical (or needs to be executed
		% again) it will be planned into the calendar for the time defined
		% by the event.
            nextEvent = obj.remove();
            if(isempty(nextEvent))
                return;
            end
            
			% Execute the event
            nextEvent.EventAction.execute();
            % Prepare next occurrence of the event
            nextEvent.nextEvent();
            % Plan the event again if required
            if(nextEvent.EventTime ~= -1)
                obj.insert(nextEvent);
                repeated = true;
            else
                repeated = false;
            end
        end
        
        function ret = isNext(obj)
		% ISNEXT indicates whether there is any event in the calendar.
            ret = size(obj.Events, 2) > 0;
        end
    end
    
    methods (Access = private)
        function index = minIndex(obj)
		% MININDEX returns the index of the earliest event in the calendar.
		% If the calendar is empty a value of -1 is returned.
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