classdef FireFighterGroupRandomMoveProcess < Process
    % FireFighterGroupRandomMoveProcess class represents a process, that ensures 
    % a random movement of a FireFighter component within an associated group
    % of components. This class extends the Process abstract class.
	
    properties (SetAccess = protected)    
        Map; % A matrix representing the area of movement (heat map).
        GroupComponents; % Other components in the group.
        GroupBound; % Distance boundary within the group.
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
        function obj = FireFighterGroupRandomMoveProcess(component, compGroup, ...
                period, map, groupBound, boundX, boundY)
		% Construct a FireFighterGroupRandomMoveProcess instance.
		% The instance will associate the given component and map.
		% The given period will be stored into the process.
            obj@Process(component, period); % Invoke the constructor of the superclass
            
            obj.GroupComponents =  compGroup;
            obj.GroupBound = groupBound;
            obj.OriginX = 256;
            obj.OriginY = 256;
            obj.DestinationX = component.PositionX;
            obj.DestinationY = component.PositionY;
            obj.BoundX = boundX;
            obj.BoundY = boundY;
            obj.Map = map;
        end 
        
        function obj = execute(obj)
		% EXECUTE when called moves the component one random step (in both coordinates).
        % Whenever the component gets too far from the centroid of its
        % group, it moves towards it.
            centroidX = 0;
            centroidY = 0;
            for gComp = obj.GroupComponents
                centroidX = centroidX + gComp.PositionX;
                centroidY = centroidY + gComp.PositionY;
            end
            centroidX = centroidX / size(obj.GroupComponents, 2);
            centroidY = centroidY / size(obj.GroupComponents, 2);
            
            futureX = obj.Component.PositionX;
            futureY = obj.Component.PositionY;
            
            % Check whether the component is too far from the group an
            % if so, move closer towards the group    
            if obj.Component.PositionX < centroidX - obj.GroupBound
                futureX = futureX + 2;
            end
            if obj.Component.PositionX > centroidX + obj.GroupBound
                futureX = futureX - 2;
            end
            if obj.Component.PositionY < centroidY - obj.GroupBound
                futureY = futureY + 2;
            end
            if obj.Component.PositionY > centroidY + obj.GroupBound
                futureY = futureY - 2;
            end
            
            if(obj.DestinationX == obj.Component.PositionX && ...
                    obj.DestinationY == obj.Component.PositionY)
				% Generate new random destination if the the current one is reached
                obj.DestinationX = obj.OriginX - obj.BoundX + round(rand * 2*obj.BoundX);
                obj.DestinationY = obj.OriginY - obj.BoundY + round(rand * 2*obj.BoundY);
            end
            
            if rand < obj.RandomMoveProbability % Move randomly
                futureX = futureX + obj.randomChange();
            else % Move towards the destination
                if(obj.Component.PositionX < obj.DestinationX)
                    futureX = futureX + 1;
                else if(obj.Component.PositionX > obj.DestinationX)
                        futureX = futureX - 1;
                    end
                end
            end
            
            if rand < obj.RandomMoveProbability % Move randomly
                futureY = futureY + obj.randomChange();
            else % Move towards the destination
                if(obj.Component.PositionY < obj.DestinationY)
                    futureY = futureY + 1;
                else if(obj.Component.PositionY > obj.DestinationY)
                        futureY = futureY - 1;
                    end
                end
            end
            
            obj.Component.FutureX = futureX;
            obj.Component.FutureY = futureY;
            
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