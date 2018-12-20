require 'demand/version'
require 'facets/kernel/blank'
require 'boolean'
#require 'pry'

module Demand
    extend self

    def demand(var, default = nil, _type = nil)

        # If type specified, must either be a class or module
        # Otherwise, get the class of whatever was passed

        if (_type != nil)
            if (_type.is_a?(Class) || _type.is_a?(Module))
                type = _type
            else
                type = _type.class
            end
        end

        begin
            # Edge case - you want the variable to be of type NilClass
            if var == nil
                unless type == NilClass
                    return default
                end
            # Is the variable blank? - not including false
            elsif !(var.present? || var == false) # Override false = blank
                return default
            # Variable is not blank
            # Do we need to check its class too?
            elsif (type != nil)
                unless var.is_a?(type)
                    return default
                end
            end
        rescue
            return default
        end

        if block_given?
            return yield(var)
        else
            return var
        end

    end

end

extend Demand
