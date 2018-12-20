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

    # Basic fallbacks

    it "returns nil for a variable that = nil" do
        expect(Demand::demand(a_nil)).to eq(nil)
    end

    it "returns default instead if provided" do
        expect(Demand::demand(a_nil, 'default')).to eq('default')
    end

    it "returns default for empty array" do
        expect(Demand::demand([], 'default')).to eq('default')
    end

    it "returns default for empty hash" do
        expect(Demand::demand({}, 'default')).to eq('default')
    end

    it "returns default for empty string" do
        expect(Demand::demand("", 'default')).to eq('default')
    end

    it "returns default for whitespace string" do
        expect(Demand::demand(" \n ", 'default')).to eq('default')
    end

    # Basic retrieval

    it "gets a variable that = false" do
        expect(Demand::demand(a_false, 'test')).to eq(a_false)
    end

    it "gets a variable that = true" do
        expect(Demand::demand(a_true, 'test')).to eq(a_true)
    end

    it "gets a string" do
        expect(Demand::demand(a_string, 'default')).to eq(a_string)
    end

    it "gets a number" do
        expect(Demand::demand(a_number, 'default')).to eq(a_number)
    end

    it "gets a array" do
        expect(Demand::demand(a_array, 'default')).to eq(a_array)
    end

    it "gets a hash" do
        expect(Demand::demand(a_hash, 'default')).to eq(a_hash)
    end

    # Typed fallbacks

    it "returns default for number when expecting Boolean" do
        expect(Demand::demand(a_number, 'default', Boolean)).to eq('default')
    end

    it "returns default for true when expecting FalseClass" do
        expect(Demand::demand(a_true, 'default', FalseClass)).to eq('default')
    end

    it "returns default for false when expecting TrueClass" do
        expect(Demand::demand(a_false, 'default', TrueClass)).to eq('default')
    end

    it "returns default for string when expecting Numeric" do
        expect(Demand::demand(a_string, 'default', Numeric)).to eq('default')
    end

    it "returns default for 0.5 when expecting Integer" do
        expect(Demand::demand(0.5, 'default', Integer)).to eq('default')
    end

    it "returns default for number when expecting String" do
        expect(Demand::demand(a_number, 'default', String)).to eq('default')
    end

    it "returns default for array when expecting Hash" do
        expect(Demand::demand(a_array, 'default', Hash)).to eq('default')
    end

    it "returns default for hash when expecting Array" do
        expect(Demand::demand(a_hash, 'default', Array)).to eq('default')
    end

    # Typed retrieval

    it "gets true when expecting Boolean" do
        expect(Demand::demand(a_true, 'default', Boolean)).to eq(a_true)
    end

    it "gets false when expecting Boolean" do
        expect(Demand::demand(a_false, 'default', Boolean)).to eq(a_false)
    end

    it "gets true when expecting TrueClass" do
        expect(Demand::demand(a_true, 'default', TrueClass)).to eq(a_true)
    end

    it "gets false when expecting FalseClass" do
        expect(Demand::demand(a_false, 'default', FalseClass)).to eq(a_false)
    end

    it "gets string when expecting String" do
        expect(Demand::demand(a_string, 'default', String)).to eq(a_string)
    end

    it "gets number when expecting Numeric" do
        expect(Demand::demand(a_number, 'default', Numeric)).to eq(a_number)
    end

    it "gets 0.5 when expecting Numeric" do
        expect(Demand::demand(0.5, 'default', Numeric)).to eq(0.5)
    end

    it "gets 0 when expecting Integer" do
        expect(Demand::demand(0, 'default', Integer)).to eq(0)
    end

    it "gets 0 when expecting Numeric" do
        expect(Demand::demand(0, 'default', Numeric)).to eq(0)
    end

    it "gets array when expecting Array" do
        expect(Demand::demand(a_array, 'default', Array)).to eq(a_array)
    end

    it "gets hash when expecting Hash" do
        expect(Demand::demand(a_hash, 'default', Hash)).to eq(a_hash)
    end

    # Yielding

    it "yields string when expecting String and returns block result" do
        expect(Demand::demand(a_string, 'default', String) {|s| s * 2}).to eq(a_string * 2)
    end

    # Use cases

    it "replaces `if !a.nil? then x = a end` when a is a String" do
        x = ""
        Demand::demand(a_string) {|a| x = a }
        expect(x).to eq(a_string)
    end

    it "replaces `if !a.nil? then x = a end` when a is nil" do
        x = "".freeze
        Demand::demand(a_nil) {|a| x = a }
        expect(x).to eq("")
    end

end
