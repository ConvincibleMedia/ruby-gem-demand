require 'boolean'

module Demand
	OPTIONS = {
		# If true, a passed block will still run if the presence check on your variable fails. The default value will be yielded to the block instead.
		yield_default: false,
		# If true, the return value of the passed block (if run) will be the return value for the main method itself.
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

	if (type != nil)
		# If type specified, must either be a class or module
		if (type.is_a?(Class) || type.is_a?(Module))
			t = type
		else
			# Otherwise, get the class of whatever was passed
			t = type.class
		end

		# Is this an anonymous class (e.g. anonymous struct)? - not much use
		if t.name.to_s == '' && type.superclass != nil
			# Lets use the class it's a type of, instead (e.g. Struct)
			t = type.superclass
		end
	end

	# Check the var
	result = var; check = true # has the check passed?
	begin
		# Is the variable nil?
		if var == nil
			# Do you want the variable to be nil? (edge case)
			unless t == NilClass
				# No - so the check fails
				result = default; check = false
			end
		# Is the variable blank? - not including false
		elsif (
			( var.respond_to?(:nil?) && !!var.nil? )     || # responds to nil truthily
			( var.is_a?(NilClass) )                      || # is a kind of nil
			( var.respond_to?(:empty?) && !!var.empty? ) || # is empty/empty string
			( var.is_a?(String) && var.strip.empty? )       # is just whitespace
		)
			# Variable is blank
			result = default; check = false
		# Variable is not blank
		# Has a class been specified that the variable must be a type of?
		elsif (t != nil)
			unless var.is_a?(t)
				# Variable is not of correct type
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