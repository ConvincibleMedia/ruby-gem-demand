RSpec.describe "demand(var, [default])" do

	context "present variable" do

		describe "return the variable" do

			example_set(:present) do |val, type, super_type|
				test(val, type, :present)
				test(val, type, :present, 'default')
			end
			
		end

	end

	context "blank variable" do

		describe "return nil" do

			example_set(:blank) do |val, type, super_type|
				test(val, type, :blank)
			end
			
		end

		describe "return the default" do

			example_set(:blank) do |val, type, super_type|
				test(val, type, :blank, 'default')
			end

		end

	end

end