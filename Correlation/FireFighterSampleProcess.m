classdef FireFighterSampleProcess < Process
    % FireFighterSampleProcess class represents a process, that ensures the sampling
	% of a FireFighter component's sensors. This class extends the Process abstract class.
	
    properties (SetAccess = protected)
        Map; % A matrix representing the area of movement (heat map).
        OxygenConsumption; % The amount of oxygen that is consumed at each sample time.
        BatteryConsumption; % The amount of energy that is consumed at each sample time.
    end
    
    methods
        function obj = FireFighterSampleProcess(component, period, map)
        % Constructs an instance of the FireFighterSampleProcess class.
		% The instance will associate the given component and map.
		% The given period will be stored in the process.
            obj@Process(component, period); % Invoke the constructor of the superclass
            
            obj.Map = map;
            obj.OxygenConsumption = 0.002;
            obj.BatteryConsumption = rand/300;
        end
        
        function obj = execute(obj)
		% EXECUTE when called samples the component and adjusts its state.
            obj.Component.BatteryLevel = ...
                obj.Component.BatteryLevel ...
                - obj.BatteryConsumption;
            
            oxygenMultiplier = 1;
            if obj.Component.PositionX ~= obj.Component.FutureX
                oxygenMultiplier = oxygenMultiplier + 50;
            end
            if obj.Component.PositionY ~= obj.Component.FutureY
                oxygenMultiplier = oxygenMultiplier + 50;
            end
            obj.Component.OxygenLevel = ...
                obj.Component.OxygenLevel ...
                - obj.OxygenConsumption * oxygenMultiplier;
            
            obj.Component.PositionX = ...
                obj.Component.FutureX;
            
            obj.Component.PositionY = ...
                obj.Component.FutureY;
            
            obj.Component.Temperature = ...
                obj.Map(obj.Component.PositionX, ...
                        obj.Component.PositionY);
            
        end
        
    end
end