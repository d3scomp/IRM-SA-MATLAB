classdef FireFighter < Component
    
    properties
        
        FutureX; % Changed by the "Move" process
        FutureY; % Changed by the "Move" process
        PositionX; % Changed by the "Sample" process
        PositionY; % Changed by the "Sample" process
        PositionNoise;
        Temperature;
        TemperatureNoise;
        OxygenLevel;
        OxygenNoise;
        BatteryLevel;
        BatteryNoise;
        
        HasMoved;
    end
    
    methods
        
        % Constructor
        function obj = FireFighter(name)
            
            obj = obj@Component(name);
            
            obj.PositionNoise = RandomNoise(5);
            obj.TemperatureNoise = RandomNoise(5);
            obj.OxygenNoise = RandomNoise(1);
            obj.BatteryNoise = RandomNoise(2);
            
            obj.FutureX = 1;
            obj.FutureY = 350;
            obj.PositionX = 1;
            obj.PositionY = 350;
            obj.OxygenLevel = 100;
            obj.BatteryLevel = 100;
            
            obj.HasMoved = 1;
        end
        
        function set.FutureX(obj, futureX)
            obj.FutureX = futureX;
        end
        
        function futureX = get.FutureX(obj)
            futureX = obj.FutureX;
        end
        
        function set.FutureY(obj, futureY)
            obj.FutureY = futureY;
        end
        
        function futureY = get.FutureY(obj)
            futureY = obj.FutureY;
        end
        
        function set.PositionX(obj, positionX)
%            fprintf('X %d -> %d', obj.PositionX, positionX);
            obj.PositionX = positionX;
            obj.setDataField('positionX', ...
                obj.PositionNoise.filter(positionX));
            obj.HasMoved = obj.HasMoved + 1;
        end
        
        function positionX = get.PositionX(obj)
            positionX = obj.PositionX;
        end
        
        function set.PositionY(obj, positionY)
            obj.PositionY = positionY;
            obj.setDataField('positionY', ...
                obj.PositionNoise.filter(positionY));
            obj.HasMoved = obj.HasMoved + 1;
        end
        
        function positionY = get.PositionY(obj)
            positionY = obj.PositionY;
        end
        
        function set.Temperature(obj, temperature)
            obj.Temperature = temperature;
            obj.setDataField('temperature', ...
                obj.TemperatureNoise.filter(temperature));
        end
        
        function temperature = get.Temperature(obj)
            temperature = obj.Temperature;
        end
        
        function set.OxygenLevel(obj, oxygenLevel)
            obj.OxygenLevel = oxygenLevel;
            obj.setDataField('oxygenLevel', ...
                obj.OxygenNoise.filter(oxygenLevel));
        end
        
        function oxygenLevel = get.OxygenLevel(obj)
            oxygenLevel = obj.OxygenLevel;
        end
        
        function set.BatteryLevel(obj, batteryLevel)
            obj.BatteryLevel = batteryLevel;
            obj.setDataField('batteryLevel', ...
                obj.BatteryNoise.filter(batteryLevel));
        end
        
        function batteryLevel = get.BatteryLevel(obj)
            batteryLevel = obj.BatteryLevel;
        end
        
        function hasMoved = get.HasMoved(obj)
            hasMoved = obj.HasMoved;
        end
        
        function set.HasMoved(obj, value)
            obj.HasMoved = value;
        end
        
    end
    
end

