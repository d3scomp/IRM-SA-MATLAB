classdef FireFighter < Component
    % FireFighter class extends the Component class.
    %  It represents a firefighter that carries a number of sensors. The
    %  class contains properties that holds the most recent sampled values.
    %  When a new value is stored into some property it is also stored into
    %  the data history vector.
    
    properties
        FutureX; % The X coordinate where the firefighter will move when the next MoveProcess will be executed.
        FutureY; % The Y coordinate where the firefighter will move when the next MoveProcess will be executed.
        PositionX; % The X coordinate of the firefighter. It is sampled by the SampleProcess.
        PositionY; % The Y coordinate of the firefighter. It is sampled by the SampleProcess.
        PositionNoise; % The random noise filter for the position sensor. Used when storing the data into the history vector.
        Temperature; % The temperature measured by the firefighter. It is sampled by the SampleProcess.
        TemperatureNoise; % The random noise filter for the temperature sensor. Used when storing the data into the history vector.
        OxygenLevel; % The oxygen level of the firefighter oxygen reserve. It is sampled by the SampleProcess.
        OxygenNoise; % The random noise filter for the oxygen level sensor. Used when storing the data into the history vector.
        BatteryLevel; % The battery level of the firefighter. It is sampled by the SampleProcess.
        BatteryNoise; % The random noise filter for the battery level sensor. Used when storing the data into the history vector.
        
        HasMoved; % A simple counter of moves. It is used only for the visualisation of the simulation.
    end
    
    methods
        function obj = FireFighter(name)
            % Constructs new instance of the FireFighter class. Sets the
            % starting position, oxygen level and battery level to the
            % object. Initializes all the noise filters with a predefined
            % noise level.
            obj = obj@Component(name); % Invoke the constructor of the super class
            
            obj.PositionNoise = RandomNoise(5);
            obj.TemperatureNoise = RandomNoise(5);
            obj.OxygenNoise = RandomNoise(1);
            obj.BatteryNoise = RandomNoise(2);
            
            obj.FutureX = 1; % The value of the FutureX and PositionX has to be initially the same.
            obj.FutureY = 350; % The value of the FutureY and PositionY has to be initially the same.
            obj.PositionX = 1;
            obj.PositionY = 350;
            obj.OxygenLevel = 100;
            obj.BatteryLevel = 100;
            
            obj.HasMoved = 1;
        end
        
        function set.FutureX(obj, futureX)
            % Set the given value to the FutureX property.
            obj.FutureX = futureX;
        end
        
        function futureX = get.FutureX(obj)
            % Get the value of the FutureX property.
            futureX = obj.FutureX;
        end
        
        function set.FutureY(obj, futureY)
            % Set the given value to the FutureY property.
            obj.FutureY = futureY;
        end
        
        function futureY = get.FutureY(obj)
            % Get the value of the FutureY property.
            futureY = obj.FutureY;
        end
        
        function set.PositionX(obj, positionX)
            % Set the new value to the PositionX property and store it filtered
            % with the noise into the history data vector with according label.
            obj.PositionX = positionX;
            obj.setDataField('positionX', ...
                obj.PositionNoise.filter(positionX));
            obj.HasMoved = obj.HasMoved + 1;
        end
        
        function positionX = get.PositionX(obj)
            % Get the value of the PositionX property.
            positionX = obj.PositionX;
        end
        
        function set.PositionY(obj, positionY)
            % Set the new value to the PositionY property and store it filtered
            % with the noise into the history data vector with according label.
            obj.PositionY = positionY;
            obj.setDataField('positionY', ...
                obj.PositionNoise.filter(positionY));
            obj.HasMoved = obj.HasMoved + 1;
        end
        
        function positionY = get.PositionY(obj)
            % Get the value of the PositionY property.
            positionY = obj.PositionY;
        end
        
        function set.Temperature(obj, temperature)
            % Set the new value to the Temperature property and store it filtered
            % with the noise into the history data vector with according label.
            obj.Temperature = temperature;
            obj.setDataField('temperature', ...
                obj.TemperatureNoise.filter(temperature));
        end
        
        function temperature = get.Temperature(obj)
            % Get the value of the Temperature property.
            temperature = obj.Temperature;
        end
        
        function set.OxygenLevel(obj, oxygenLevel)
            % Set the new value to the OxygenLevel property and store it filtered
            % with the noise into the history data vector with according label.
            obj.OxygenLevel = oxygenLevel;
            obj.setDataField('oxygenLevel', ...
                obj.OxygenNoise.filter(oxygenLevel));
        end
        
        function oxygenLevel = get.OxygenLevel(obj)
            % Get the value of the OxygenLevel property.
            oxygenLevel = obj.OxygenLevel;
        end
        
        function set.BatteryLevel(obj, batteryLevel)
            % Set the new value to the BatteryLevel property and store it filtered
            % with the noise into the history data vector with according label.
            obj.BatteryLevel = batteryLevel;
            obj.setDataField('batteryLevel', ...
                obj.BatteryNoise.filter(batteryLevel));
        end
        
        function batteryLevel = get.BatteryLevel(obj)
            % Get the value of the BatteryLevel property.
            batteryLevel = obj.BatteryLevel;
        end
        
        function hasMoved = get.HasMoved(obj)
            % Get the value of the HasMoved property.
            hasMoved = obj.HasMoved;
        end
        
        function set.HasMoved(obj, value)
            % Set the value of the HasMoved property.
            obj.HasMoved = value;
        end
    end
end

