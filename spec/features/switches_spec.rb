RSpec.describe "Demand::OPTIONS" do

	it "can be read" do
		expect(Demand::OPTIONS[:yield_default]).not_to eq(true)
		expect(Demand::OPTIONS[:return_yield]).not_to eq(true)
	end

	it "can be set" do
		Demand::OPTIONS[:yield_default] = true
		Demand::OPTIONS[:return_yield] = true
		expect(Demand::OPTIONS[:yield_default]).to eq(true)
		expect(Demand::OPTIONS[:return_yield]).to eq(true)
		Demand::OPTIONS[:yield_default] = false
		Demand::OPTIONS[:return_yield] = false
		expect(Demand::OPTIONS[:yield_default]).to eq(false)
		expect(Demand::OPTIONS[:return_yield]).to eq(false)
	end

	describe "Demand::YIELD_DEFAULT" do

		before(:all) { Demand::OPTIONS[:yield_default] = true }
		after(:all) { Demand::OPTIONS[:yield_default] = false }

		context "blank variable" do

			it "runs block, passing default" do
				test = ''
				demand(nil, 'default') do |var|
					test = var
				end
				expect(test).to eq('default')
			end

		end
		
	end

	describe "Demand::RETURN_YIELD" do

		before(:all) { Demand::OPTIONS[:return_yield] = true }
		after(:all) { Demand::OPTIONS[:return_yield] = false }

		context "present variable" do

			it "runs block, returns block result" do
				test = demand(5, 'default') do |var|
					var * 2
				end
				expect(test).to eq(5 * 2)
			end
		
		end

	end

end