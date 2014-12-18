classdef FireFighterMoveProcess < Process
    
    properties (SetAccess = protected)
        
        Map;
        DestinationX;
        DestinationY;
        
    end
    
    methods
       
        % Constructor
        function obj = FireFighterMoveProcess(component, period, map, ...
                destination)
            % Invoke the constructor of the superclass
            obj@Process(component, period);
            
            obj.Map = map;
            obj.DestinationX = destination(1);
            obj.DestinationY = destination(2);
        end 
        
        function obj = execute(obj)
%            fprintf('M');
            % Disable the process if the destinaiton position is reached
            if(obj.DestinationX == obj.Component.PositionX && ...
                    obj.DestinationY == obj.Component.PositionY)
                obj.NextOccurrence = -1;
            else
                if(obj.Component.PositionX < obj.DestinationX)
                    obj.Component.FutureX = obj.Component.PositionX + 1;
                else if(obj.Component.PositionX > obj.DestinationX)
                        obj.Component.FutureX = obj.Component.PositionX - 1;
                    end
                end
                if(obj.Component.PositionY < obj.DestinationY)
                    obj.Component.FutureY = obj.Component.PositionY + 1;
                else if(obj.Component.PositionY > obj.DestinationY)
                        obj.Component.FutureY = obj.Component.PositionY - 1;
                    end
                end
                    
            end
            
        end
        
    end
end