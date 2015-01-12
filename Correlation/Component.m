classdef (Abstract = true) Component < handle
    % Component class represents a DEECo component.
    %  It stores a history of all measured data and
    %  provides an access to it. This class is abstract
    %  and all implementations of DEECo components
    %  must be derived from this class.
    
    properties (SetAccess = protected)
        Name; % The name of the component to distinguish the instances.
        DataFields; % The map of data vectors. Each data vector represents a history of the data as it changed in time.
    end
    
    methods (Access = protected)
        function setDataField(obj, label, value)
            % Appends the given value to the data vector identified by the
            % given label.
            if(obj.DataFields.isKey(label))
               history = obj.DataFields(label); % Get the data vector
            else
               history = []; % Initialize the array if not used yet
            end
            history = [history, value]; % Append the value to the data vector
            obj.DataFields(label) = history; % Assign the new data history
        end
    end
    
    methods
        function obj = Component(name)
            % Constructs a new instance of component. Initializes
            % DataFields and assigns the given name to the component.
            obj.DataFields = containers.Map();
            obj.Name = name;
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
                history = obj.DataFields(label);
            else
                history = [];
            end
        end
    end
end