classdef FireFighterMoveProcess < Process
    % FireFighterMoveProcess class represents a process, that ensures the movement
	% of a FireFighter component. This class extends the Process abstract class.
	
    properties (SetAccess = protected)    
        Map; % A matrix representing the area of movement (heat map).
        DestinationX; % The X coordinate where the component needs to move.
        DestinationY; % The Y coordinate where the component needs to move.
    end
    
    methods
        function obj = FireFighterMoveProcess(component, period, map, ...
                destination)
		% Construct a FireFighterMoveProcess instance.
		% The instance will associate the given component and map.
		% The given destination [x, y] and period will be stored in the process.
            obj@Process(component, period); % Invoke the constructor of the superclass
            
            obj.Map = map;
            obj.DestinationX = destination(1);
            obj.DestinationY = destination(2);
        end 
        
        function obj = execute(obj)
		% EXECUTE when called moves the component one step closer (in both coordinates)
		% to the destination.
            if(obj.DestinationX == obj.Component.PositionX && ...
                    obj.DestinationY == obj.Component.PositionY)
				% Disable the process if the destination position is reached
                obj.NextOccurrence = -1;
                fprintf('\n%s position [%d,%d] reached\n', obj.Component.Name, ...
                    obj.DestinationX, obj.DestinationY);
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