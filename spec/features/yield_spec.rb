RSpec.describe "demand(...) { ... }" do

	context "present variable" do

		it "runs block" do
			test = false
			demand(true, 'default') do |var|
				test = true
			end
			expect(test).to eq(true)
		end

		it "returns variable" do
			test = demand(5, 'default') do |var|
				var = 10
			end
			expect(test).to eq(5)
		end

		it "passes variable into the block" do
			test = 5
			demand(10, 'default') do |var|
				test = var
			end
			expect(test).to eq(10)
		end

		it "allows variable to be mutated inside the block" do
			outer_var = [0, 1]
			demand(outer_var, 'default') do |inner_var|
				inner_var[1] = 10
			end
			expect(outer_var[1]).to eq(10)
		end

	end

	context "blank variable" do

		it "does not run block" do
			test = false
			demand(nil, 'default') do |var|
				test = true
			end
			expect(test).to eq(false)
		end

		it "returns default" do
			var = nil
			test = demand(var, 'default') do |var|
				var = 10
			end
			expect(test).to eq('default')
		end

	end

end