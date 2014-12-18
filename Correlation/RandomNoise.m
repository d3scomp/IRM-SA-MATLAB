classdef RandomNoise
   
    properties
        NoiseLevel;
    end
    
    methods
        function obj = RandomNoise(noiseLevel)
            obj.NoiseLevel = noiseLevel;
        end
        
        function filtered = filter(obj, value)
            if(round(rand))
                filtered = value + (obj.NoiseLevel * rand);
            else
                filtered = value - (obj.NoiseLevel * rand);
            end
        end     
    end
    
end