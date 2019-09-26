require "bundler/setup"
require "demand"

require 'ice_nine'
require 'ice_nine/core_ext/object'
require "active_support/core_ext/hash/except"

Struct.new('Test', :a, :b, :c)

EXAMPLES = {
	present: {
		String => ['nil'],
		Numeric => {
			Integer => [0],
			Float => [3.0 / 2.0]
		},
		Boolean => {
			TrueClass => [true],
			FalseClass => [false],
		},
		Array => [[nil, nil]],
		Hash => [{nil => nil}],
		Struct => {
			Struct => [Struct.new(:a, :b, :c).new(nil, nil, nil)], # Anonymous Struct
			Struct::Test => [Struct::Test.new(nil, nil, nil)]
		}
	},
	blank: {
		NilClass => [nil],
		String => [" \n "],
		Array => [[]],
		Hash => [{}]
	}
}.deep_freeze

def example_set(set, except = [])
	EXAMPLES[set].each do |type, contents|
		if contents.is_a?(Array)
			contents.each { |val|
				yield(val, type, nil) unless except.include?(type)
			}
		elsif contents.is_a?(Hash)
			contents.each { |sub_type, values|
				values.each { |val|
					yield(val, sub_type, type) unless except.include?(sub_type)
				}
			}
		end
	end
end

def type_of(var)
	type = var.class
	type = type.superclass if type.name.to_s == '' && type.superclass != nil
	return type
end

def test(val, val_type, blank, default = nil, type = nil)
	# Expected return value
	if blank == :blank
		test_return = default == nil ? 'nil' : 'default'
	else
		if type == nil
			test_return = 'variable'
		else
			if val_type == type || val.is_a?(type)
				test_return = 'variable'
			else
				test_return = default == nil ? 'nil' : 'default'
			end
		end
	end
	test_match = val if test_return == 'variable'
	test_match = default if test_return == 'default'
	test_match = nil if test_return == 'nil'
	
	# Are we testing a blank value?
	test_state = blank == :blank ? 'blank' : 'present'

	# Arguments
	test_args = [val]
	test_args << default if default || type
	test_args << type if type
	test_arg_string = test_args.map{ |arg| arg.inspect }.join(', ')

	test_code = "demand(#{test_arg_string})"

	it "#{test_state} #{val_type.to_s} [ #{test_code} ] returns #{test_return} [ #{test_match.inspect} ]" do
		expect(demand(*test_args)).to eq(test_match)
	end
end

require 'ice_nine'
require 'ice_nine/core_ext/object'
require "active_support/core_ext/hash/except"

Struct.new('Test', :a, :b, :c)

EXAMPLES = {
	present: {
		String => ['nil'],
		Numeric => {
			Integer => [0],
			Float => [3.0 / 2.0]
		},
		Boolean => {
			TrueClass => [true],
			FalseClass => [false],
		},
		Array => [[nil, nil]],
		Hash => [{nil => nil}],
		Struct => {
			Struct => [Struct.new(:a, :b, :c).new(nil, nil, nil)], # Anonymous Struct
			Struct::Test => [Struct::Test.new(nil, nil, nil)]
		}
	},
	blank: {
		NilClass => [nil],
		String => [" \n "],
		Array => [[]],
		Hash => [{}]
	}
}.deep_freeze

def example_set(set, except = [])
	EXAMPLES[set].each do |type, contents|
		if contents.is_a?(Array)
			contents.each { |val|
				yield(val, type, nil) unless except.include?(type)
			}
		elsif contents.is_a?(Hash)
			contents.each { |sub_type, values|
				values.each { |val|
					yield(val, sub_type, type) unless except.include?(sub_type)
				}
			}
		end
	end
end

def type_of(var)
	type = var.class
	type = type.superclass if type.name.to_s == '' && type.superclass != nil
	return type
end

def test(val, val_type, blank, default = nil, type = nil)
	# Expected return value
	if blank == :blank
		test_return = default == nil ? 'nil' : 'default'
	else
		if type == nil
			test_return = 'variable'
		else
			if val_type == type || val.is_a?(type)
				test_return = 'variable'
			else
				test_return = default == nil ? 'nil' : 'default'
			end
		end
	end
	test_match = val if test_return == 'variable'
	test_match = default if test_return == 'default'
	test_match = nil if test_return == 'nil'
	
	# Are we testing a blank value?
	test_state = blank == :blank ? 'blank' : 'present'

	# Arguments
	test_args = [val]
	test_args << default if default || type
	test_args << type if type
	test_arg_string = test_args.map{ |arg| arg.inspect }.join(', ')

	test_code = "demand(#{test_arg_string})"

	it "#{test_state} #{val_type.to_s} [ #{test_code} ] returns #{test_return} [ #{test_match.inspect} ]" do
		expect(demand(*test_args)).to eq(test_match)
	end
end

RSpec.configure do |config|
	# Enable flags like --only-failures and --next-failure
	#config.example_status_persistence_file_path = ".rspec_status"

	# Disable RSpec exposing methods globally on `Module` and `main`
	#config.disable_monkey_patching!

	config.expect_with :rspec do |c|
		c.syntax = :expect
	end
end
