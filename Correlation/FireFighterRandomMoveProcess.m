classdef FireFighterRandomMoveProcess < Process
    % FireFighterRandomMoveProcess class represents a process, that ensures 
    % a random movement of a FireFighter component.
    % This class extends the Process abstract class.
	
    properties (SetAccess = protected)    
        Map; % A matrix representing the area of movement (heat map).
        OriginX; % The X coordinate of the center of the square inside which the components can move.
        OriginY; % The Y coordinate of the center of the square inside which the components can move.
        BoundX; % The width of the square inside which the components can move.
        BoundY; % The height of the square inside which the components can move.
        DestinationX; % The X coordinate where the component needs to move.
        DestinationY; % The Y coordinate where the component needs to move.
    end
    
    properties (Constant)
       RandomMoveProbability = 0.2; % The probability of a random move instead of the move towards the random destination. 
    end
    
    methods
        function obj = FireFighterRandomMoveProcess(component, period, map, boundX, boundY)
		% Construct a FireFighterRandomMoveProcess instance.
		% The instance will associate the given component and map.
		% The given period will be stored into the process.
            obj@Process(component, period); % Invoke the constructor of the superclass
            
            obj.OriginX = component.PositionX;
            obj.OriginY = component.PositionY;
            obj.DestinationX = component.PositionX;
            obj.DestinationY = component.PositionY;
            obj.BoundX = boundX;
            obj.BoundY = boundY;
            obj.Map = map;
        end 
        
        function obj = execute(obj)
		% EXECUTE when called moves the component one random step (in both coordinates).
            if(obj.DestinationX == obj.Component.PositionX && ...
                    obj.DestinationY == obj.Component.PositionY)
				% Generate new random destination if the the current one is reached
                obj.DestinationX = obj.OriginX - obj.BoundX + round(rand * 2*obj.BoundX);
                obj.DestinationY = obj.OriginY - obj.BoundY + round(rand * 2*obj.BoundY);
            end
            
            if rand < obj.RandomMoveProbability % Move randomly
                obj.Component.FutureX = obj.Component.PositionX + obj.randomChange();
            else % Move towards the destination
                if(obj.Component.PositionX < obj.DestinationX)
                    obj.Component.FutureX = obj.Component.PositionX + 1;
                else if(obj.Component.PositionX > obj.DestinationX)
                        obj.Component.FutureX = obj.Component.PositionX - 1;
                    end
                end
            end
            
            if rand < obj.RandomMoveProbability % Move randomly
                obj.Component.FutureY = obj.Component.PositionY + obj.randomChange();
            else % Move towards the destination
                if(obj.Component.PositionY < obj.DestinationY)
                    obj.Component.FutureY = obj.Component.PositionY + 1;
                else if(obj.Component.PositionY > obj.DestinationY)
                        obj.Component.FutureY = obj.Component.PositionY - 1;
                    end
                end
            end
        end
        
        function changeValue = randomChange(obj)
        % Returns one of the value from the following: {-1, 0, 1} with a
        % probability with the normal distribution.
            switch floor(rand*3) % make three possible cases (0, 1, 2)
                case 0
                    changeValue = -1;
                case 1
                    changeValue = 1;
                otherwise
                    changeValue = 0;
            end
        end
    end
end