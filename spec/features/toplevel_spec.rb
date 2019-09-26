RSpec.describe "Top Level Method" do

	it "defines demand() at the top level" do
		expect(defined?(demand)).not_to eq(nil)
		expect { method(:demand) }.not_to raise_error
	end

	it "defines the Demand module" do
		expect(defined?(Demand)).not_to eq(nil)
	end

end