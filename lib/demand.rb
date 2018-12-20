require 'demand/version'
require 'facets/kernel/blank'
require 'boolean'
require 'pry'

module Demand

    def self.demand(var, default = nil, t = nil, constraints = nil)

        # If type specified, must either be a class or module
        # Otherwise, get the class of whatever was passed

        if (t != nil)
            if (t.is_a?(Class) || t.is_a?(Module))
                type = t
            else
                type = type.class
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
                if var.is_a?(type)
                    # Var is the right type
                    # Do we need to check constraints?
                    if constraints.is_a?(Hash) && constraints.size > 0
                        # If any constraint fails, return default
                        constraints.each { |method, arg|
                            if !arg.is_a?(Array) then arg = [arg] end
                            if !method.is_a?(Symbol) then method = method.to_s.to_sym end

                            unless var.respond_to?(method) && var.send(method, *arg)
                                return default
                            end
                        }
                    end
                else
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
