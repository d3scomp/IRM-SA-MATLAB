classdef (Abstract = true) Component < handle
    % Component class represents a DEECo component.
    %  It stores a history of all measured data and
    %  provides an access to it. This class is abstract
    %  and all implementations of DEECo components
    %  must be derived from this class.
    
    properties (SetAccess = protected)
        Name; % The name of the component to distinguish the instances.
        DataFields; % The map of data vectors. Each data vector represents a history of the data as it changed in time.
        DataFieldIndices; % Indices pointing to the end of the corresponding DataFields.
        MaxSteps; % Maximum of the simulation steps.
    end
    
    methods (Access = protected)
        function setDataField(obj, label, value)
            % Appends the given value to the data vector identified by the
            % given label.
            if(obj.DataFields.isKey(label))
               history = obj.DataFields(label); % Get the data vector
            else
               history = zeros(1, obj.MaxSteps); % Initialize the array if not used yet
               obj.DataFieldIndices(label) = 1;
            end
            i = obj.DataFieldIndices(label);
            history(i) = value; % Append the value to the data vector
            obj.DataFields(label) = history; % Assign the new data history
            obj.DataFieldIndices(label) = i + 1;
        end
    end
    
    methods
        function obj = Component(name, maxSteps)
            % Constructs a new instance of component. Initializes
            % DataFields and assigns the given name to the component.
            obj.DataFields = containers.Map();
            obj.DataFieldIndices = containers.Map();
            obj.Name = name;
            obj.MaxSteps = maxSteps;
        end
        
        function name = get.Name(obj)
            % Getter of the Name property.
            name = obj.Name;
        end
        
        function labels = getDataFieldLabels(obj)
            % Provides an array of all the labels that are used for the stored
            % data vectors.
           labels = obj.DataFields.keys;
        end
        
        function history = getDataFieldHistory(obj, label)
            % Provides the data vector for the given label.
            % If there are no data stored for the given label an empty
            % array is returned.
            if(obj.DataFields.isKey(label))
                overHistory = obj.DataFields(label);
                history = overHistory(1:obj.DataFieldIndices(label));
            else
                history = [];
            end
        end
        
        function minLength = getMinDataFieldLength(obj)
            % GETMINDATAFIELDLENGTH returns the length of the shortest data
            % field history vector.
            minLength = intmax;
            labels = obj.getDataFieldLabels();
            for label = labels
                minLength = min(minLength, obj.DataFieldIndices(label{1}));
            end
        end
    end
end