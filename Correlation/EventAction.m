classdef (Abstract = true) EventAction < handle
	% EventAction class represents an action that is associated with an event.
	% It defines methods to execute the event action and to obtain the next time
	% when the event should be planned again if needed.
    
    properties (SetAccess = protected)
        NextOccurrence; % The time offset from the time when the event action is executed, specifying when the event needs to be planed again.
    end
    
    methods
        function obj = EventAction(nextOccurrence)
		% Constructs an EventAction instance.
		% The given nextOccurrence value defines the period of the event.
            obj.NextOccurrence = nextOccurrence;
        end
        
        function nextOccurrence = get.NextOccurrence(obj)
		% Getter of the NextOccurrence property.
		% Returns the time offset when to plan the next occurrence.
            nextOccurrence = obj.NextOccurrence;
        end
    end
    
    methods (Abstract = true)
        obj = execute(obj); % Execute the action of the event. It needs to be overridden in derived classes.
    end
    
end