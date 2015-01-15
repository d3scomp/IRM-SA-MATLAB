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
            obj.OriginX = component.PositionX;
            obj.OriginY = component.PositionY;
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
            
            % Check whether the component is too far from the group an
            % if so, move closer towards the group    
            if obj.Component.PositionX < centroidX - obj.GroupBound
                obj.Component.FutureX = obj.Component.PositionX + 2;
            end
            if obj.Component.PositionX > centroidX + obj.GroupBound
                obj.Component.FutureX = obj.Component.PositionX - 2;
            end
            if obj.Component.PositionY < centroidY - obj.GroupBound
                obj.Component.FutureY = obj.Component.PositionY + 2;
            end
            if obj.Component.PositionY > centroidY + obj.GroupBound
                obj.Component.FutureY = obj.Component.PositionY - 2;
            end
        
            switch floor(rand*3) % make three possible cases (0, 1, 2)
                case 0 % Move right if in bounds
                    if obj.Component.PositionX < obj.OriginX + obj.BoundX
                        obj.Component.FutureX = obj.Component.PositionX + 1;
                    end
                case 1 % Move left if in bounds
                    if obj.Component.PositionX > obj.OriginX - obj.BoundX
                        obj.Component.FutureX = obj.Component.PositionX - 1;
                    end
                % otherwise don't move in the X coordinate
            end
            
            switch floor(rand*3) % make three possible cases (0, 1, 2)
                case 0 % Move down if in bounds
                    if obj.Component.PositionY < obj.OriginY + obj.BoundY
                        obj.Component.FutureY = obj.Component.PositionY + 1;
                    end
                case 1 % Move up if in bounds
                    if obj.Component.PositionY > obj.OriginY - obj.BoundY
                        obj.Component.FutureY = obj.Component.PositionY - 1;
                    end
                % otherwise don't move in the Y coordinate
            end
        end
    end
end