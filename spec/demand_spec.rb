RSpec.describe Demand do
	it "has a version number" do
		expect(Demand::VERSION).not_to be nil
	end

	a_string = 'test'.freeze
	a_number = 0.freeze
	a_nil = nil.freeze
	a_false = false.freeze
	a_true = true.freeze
	a_array = [1, 2, 3].freeze
	a_hash = {a: 1, b: 2, c: 3}.freeze

	# Top level

	it "defined demand() at the top level" do
		expect(defined?(demand)).not_to eq(nil)
	end

	it "defined the Demand module" do
		expect(defined?(Demand)).not_to eq(nil)
	end

	# Switches

	it "lets you read options switches for how the function works" do
		expect(Demand::OPTIONS[:yield_default]).not_to eq(true)
		expect(Demand::OPTIONS[:return_yield]).not_to eq(true)
	end

	it "lets you set options switches for how the function works" do
		Demand::OPTIONS[:yield_default] = true
		Demand::OPTIONS[:return_yield] = true
		expect(Demand::OPTIONS[:yield_default]).to eq(true)
		expect(Demand::OPTIONS[:return_yield]).to eq(true)
		Demand::OPTIONS[:yield_default] = false
		Demand::OPTIONS[:return_yield] = false
		expect(Demand::OPTIONS[:yield_default]).to eq(false)
		expect(Demand::OPTIONS[:return_yield]).to eq(false)
	end

	# Basic fallbacks

	it "returns nil for a variable that = nil" do
		expect(demand(a_nil)).to eq(nil)
	end

	it "returns default instead if provided" do
		expect(demand(a_nil, 'default')).to eq('default')
	end

	it "returns default for empty array" do
		expect(demand([], 'default')).to eq('default')
	end

	it "returns default for empty hash" do
		expect(demand({}, 'default')).to eq('default')
	end

	it "returns default for empty string" do
		expect(demand("", 'default')).to eq('default')
	end

	it "returns default for whitespace string" do
		expect(demand(" \n ", 'default')).to eq('default')
	end

	# Basic retrieval

	it "gets a variable that = false" do
		expect(demand(a_false, 'test')).to eq(a_false)
	end

	it "gets a variable that = true" do
		expect(demand(a_true, 'test')).to eq(a_true)
	end

	it "gets a string" do
		expect(demand(a_string, 'default')).to eq(a_string)
	end

	it "gets a number" do
		expect(demand(a_number, 'default')).to eq(a_number)
	end

	it "gets a array" do
		expect(demand(a_array, 'default')).to eq(a_array)
	end

	it "gets a hash" do
		expect(demand(a_hash, 'default')).to eq(a_hash)
	end

	# Typed fallbacks

	it "returns default for number when expecting Boolean" do
		expect(demand(a_number, 'default', Boolean)).to eq('default')
	end

	it "returns default for true when expecting FalseClass" do
		expect(demand(a_true, 'default', FalseClass)).to eq('default')
	end

	it "returns default for false when expecting TrueClass" do
		expect(demand(a_false, 'default', TrueClass)).to eq('default')
	end

	it "returns default for string when expecting Numeric" do
		expect(demand(a_string, 'default', Numeric)).to eq('default')
	end

	it "returns default for 0.5 when expecting Integer" do
		expect(demand(0.5, 'default', Integer)).to eq('default')
	end

	it "returns default for number when expecting String" do
		expect(demand(a_number, 'default', String)).to eq('default')
	end

	it "returns default for array when expecting Hash" do
		expect(demand(a_array, 'default', Hash)).to eq('default')
	end

	it "returns default for hash when expecting Array" do
		expect(demand(a_hash, 'default', Array)).to eq('default')
	end

	# Typed retrieval

	it "gets true when expecting Boolean" do
		expect(demand(a_true, 'default', Boolean)).to eq(a_true)
	end

	it "gets false when expecting Boolean" do
		expect(demand(a_false, 'default', Boolean)).to eq(a_false)
	end

	it "gets true when expecting TrueClass" do
		expect(demand(a_true, 'default', TrueClass)).to eq(a_true)
	end

	it "gets false when expecting FalseClass" do
		expect(demand(a_false, 'default', FalseClass)).to eq(a_false)
	end

	it "gets string when expecting String" do
		expect(demand(a_string, 'default', String)).to eq(a_string)
	end

	it "gets number when expecting Numeric" do
		expect(demand(a_number, 'default', Numeric)).to eq(a_number)
	end

	it "gets 0.5 when expecting Numeric" do
		expect(demand(0.5, 'default', Numeric)).to eq(0.5)
	end

	it "gets 0 when expecting Integer" do
		expect(demand(0, 'default', Integer)).to eq(0)
	end

	it "gets (3.0 / 2.0) = 1.5 when expecting Float" do
		expect(demand(3.0 / 2.0, 'default', Float)).to eq(1.5)
	end

	it "gets 1 when expecting Numeric" do
		expect(demand(1, 'default', Numeric)).to eq(1)
	end

	it "gets array when expecting Array" do
		expect(demand(a_array, 'default', Array)).to eq(a_array)
	end

	it "gets hash when expecting Hash" do
		expect(demand(a_hash, 'default', Hash)).to eq(a_hash)
	end

	# Yielding

	it "yields string when expecting String and returns variable, not block result" do
		x = 'test'
		expect(demand(a_string, 'default', String) {|s| x += s}).to eq(a_string)
		expect(x).to eq('test' + a_string)
	end

	# Use cases

	it "replaces `if !a.nil? then x = a end` when a is a String" do
		x = ""
		demand(a_string) {|a| x = a }
		expect(x).to eq(a_string)
	end

	it "replaces `if !a.nil? then x = a end` when a is nil" do
		x = "".freeze
		demand(a_nil) {|a| x = a }
		expect(x).to eq("")
	end

	# Switches work

	it "yields default when Demand::YIELD_DEFAULT turned on" do
		Demand::OPTIONS[:yield_default] = true
		x = 'test'
		expect(demand(a_nil, a_string) {|s| x += s}).to eq(a_string)
		expect(x).to eq('test' + a_string)
		Demand::OPTIONS[:yield_default] = false
	end

	it "returns the yield result when Demand::RETURN_YIELD turned on" do
		Demand::OPTIONS[:return_yield] = true
		expect(demand(a_string) {|s| s + 'test'}).to eq(a_string + 'test')
		Demand::OPTIONS[:return_yield] = false
	end

end
