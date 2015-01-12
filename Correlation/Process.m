classdef (Abstract = true) Process < EventAction
	% Process class is an abstract class that extends the EventAction class.
	% It represents a process of a component that (periodically) performs some
	% action (sample/actuation) on that component.
	
    properties(SetAccess = protected)
        Component; % The component for which the process is instantiated.
    end
    
    methods
        function obj = Process(component, nextOccurence)
		% Constructs the Process instance. Associates the given component
		% with the new instance. The nextOccurence parameter specifies the
		% period of the process (-1 for no period).
            obj@EventAction(nextOccurence); % Invoke the super constructor
            obj.Component = component;
        end
    end
end