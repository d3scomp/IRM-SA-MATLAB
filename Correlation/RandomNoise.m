classdef RandomNoise
	% RandomNoise class provides a filter that can be applied on a value
	% to which it add or subtracts a random value within the specified range.
	
    properties
        NoiseLevel; % The bound for the noise values.
    end
    
    methods
        function obj = RandomNoise(noiseLevel)
		% Constructs an instance of the RandomNoise class. The noiseLevel
		% delimits the bound for the noise produces by the instance.
            obj.NoiseLevel = noiseLevel;
        end
        
        function filtered = filter(obj, value)
		% FILTER applies the random noise to the given value.
		% The returned value is changed by the noise that is limited
		% by the RandomNoise.NoiseLevel.
            if(round(rand))
                filtered = value + (obj.NoiseLevel * rand);
            else
                filtered = value - (obj.NoiseLevel * rand);
            end
        end     
    end
end