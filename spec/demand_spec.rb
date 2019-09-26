RSpec.describe Demand do
	it "has a version number" do
		expect(Demand::VERSION).not_to be nil
	end

	# Use cases

	it "replaces `if !a.nil? then x = a end` when a is a String" do
		x = ""
		demand('test') {|a| x = a }
		expect(x).to eq('test')
	end

	it "replaces `if !a.nil? then x = a end` when a is nil" do
		x = "".freeze
		demand(nil) {|a| x = a }
		expect(x).to eq("")
	end

end
