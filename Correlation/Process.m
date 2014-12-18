classdef (Abstract = true) Process < EventAction
   
    properties(SetAccess = protected)
        
        Component;
        
    end
    
    methods
        
        % Constructor
        function obj = Process(component, nextOccurence)
            obj@EventAction(nextOccurence);
            obj.Component = component;
        end
        
    end
    
end