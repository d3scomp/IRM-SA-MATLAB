classdef (Abstract = true) Component < handle
    
    properties (SetAccess = protected)
        
        Name;
        DataFields;
        Periods; % TODO: remove
        
    end
    
    methods(Access = protected)
        
        function setDataField(obj, label, value)
            if(obj.DataFields.isKey(label))
               history = obj.DataFields(label); 
            else
               history = [];
            end
            history = [history, value];
            obj.DataFields(label) = history;
        end
        
    end
    
    methods
        
        % Constructor
        function obj = Component(name)
            obj.DataFields = containers.Map();
            
            obj.Name = name;
        end
        
        % Public getter of the Periods field
        function periods = get.Periods(obj)
            periods = obj.Periods;
        end
        
        % Public getter of the Name field
        function name = get.Name(obj)
            name = obj.Name;
        end
        
        function labels = getDataFieldLabels(obj)
           labels = obj.DataFields.keys;
        end
        
        function history = getDataFieldHistory(obj, label)
            if(obj.DataFields.isKey(label))
                history = obj.DataFields(label);
            else
                history = [];
            end
        end
        
        function current = getCurrentDataField(obj, label)
            if(obj.DataFields.isKey(label))
                history = obj.DataFields(label);
                current = history(length(obj.DataFields(label)));
            else
                error(['No such data (' label ').']);
            end
        end
        
    end
    
end