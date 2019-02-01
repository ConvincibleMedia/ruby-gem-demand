require 'active_support/core_ext/object/blank'
require 'boolean'
# require 'pry'

module Demand
    OPTIONS = {
        yield_default: false,
        return_yield: false
    }
    attr_accessor :OPTIONS
end

# Checks if a passed variable is present and as expected. If so, returns and optionally yields it. Otherwise, a default is returned. The check will fail for empty arrays, hashes and strings (including whitespace strings). If you want the check to pass just if the variable is nil, specify type = NilClass
#
# @param var The variable you wish to check.
# @param default The return value you want if the check fails.
# @param type [Class, Module] Variable must be of this class or include this module for the check to pass. The module 'Boolean' can be used, to mean the value must be true or false.
#
# @return The original variable if the check passes. Otherwise, the default value is returned.
# @yield [var] If a block is given and the check passes, the original variable is also yielded to the block.
#
# @note This is added as a top level method to the global scope when requiring this gem.
#
def demand(var, default = nil, type = nil)

    # If type specified, must either be a class or module
    # Otherwise, get the class of whatever was passed
    if (type != nil)
        if (type.is_a?(Class) || type.is_a?(Module))
            t = type
        else
            t = type.class
        end
    end

    # Check the var
    result = var; check = true
    begin
        # Edge case - you want the variable to be of type NilClass
        if var == nil
            unless t == NilClass
                result = default; check = false
            end
        # Is the variable blank? - not including false
        elsif !(var.present? || var == false) # Override false == blank
            result = default; check = false
        # Variable is not blank
        # Do we need to check its class too?
        elsif (t != nil)
            unless var.is_a?(t)
               result = default; check = false
            end
        end
    rescue
        result = default; check = false
    end

    # All checks have passed by this point
    if block_given? && (check || Demand::OPTIONS[:yield_default])
        if Demand::OPTIONS[:return_yield]
            return yield(result)
        else
            yield(result)
        end
    end
    return result

end
