require 'active_support/core_ext/object/blank'
require 'boolean'
# require 'pry'

module Demand
    YIELD_DEFAULT = false
    RETURN_YIELD = false
    attr_accessor :YIELD_DEFAULT
    attr_accessor :RETURN_YIELD
end

# Checks if a passed variable is present and as expected. If so, returns and optionally yields it. Otherwise, a default is returned. The check will fail for empty arrays, hashes and strings (including whitespace strings).
#
# @param var The variable you wish to check.
# @param default The return value you want if the check fails.
# @param type [Class, Module] Variable must be of this class or include this module for the check to pass. The module 'Boolean' can be used, to mean the value must be true or false.
#
# @return The original variable if the check passes. Otherwise, the default value is returned.
# @yield [var] If a block is given and the check passes, the original variable is also yielded to the block.
#
# @note If you want the check to pass just if the variable is nil, specify type = NilClass
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
    begin
        # Edge case - you want the variable to be of type NilClass
        if var == nil
            unless t == NilClass
                return default
            end
        # Is the variable blank? - not including false
        elsif !(var.present? || var == false) # Override false == blank
            return default
        # Variable is not blank
        # Do we need to check its class too?
        elsif (t != nil)
            unless var.is_a?(t)
                return default
            end
        end
    rescue
        return default
    end

    # All checks have passed by this point
    yield(var) if block_given?

    # Original variable returned
    return var

end
