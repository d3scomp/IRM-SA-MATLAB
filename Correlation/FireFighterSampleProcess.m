classdef FireFighterSampleProcess < Process
    
    properties (SetAccess = protected)
        
        Map;
        OxygenConsumption;
        BatteryConsumption;
        
    end
    
    methods
       
        % Constructor
        function obj = FireFighterSampleProcess(component, period, map)
            % Invoke the constructor of the superclass
            obj@Process(component, period);
            
            obj.Map = map;
            obj.OxygenConsumption = 0.002;
            obj.BatteryConsumption = rand/300;
        end
        
        function obj = execute(obj)
%            fprintf('S');
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