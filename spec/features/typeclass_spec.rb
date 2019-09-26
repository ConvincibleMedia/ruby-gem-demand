RSpec.describe "demand(var, default, type)" do

	describe "type == NilClass" do

		context "nil" do
			
			it "returns nil, not default" do
				expect(demand(nil, 'default', NilClass)).to eq(nil)
			end

		end
			
		context "not nil" do

			it "returns default for non-nil" do
				expect(demand(false, 'default', NilClass)).to eq('default')
			end
			
		end

	end

	context "type == Class" do

		context "blank variable" do

			example_set(:blank, [NilClass]) do |val, type, super_type|
				test(
					val, type, :blank, # Blank var
					'default',
					type # Correct type, but as blank, should still return default
				)
			end

		end

		context "present variable" do

			describe "type match: return the variable" do

				example_set(:present) do |val, type, super_type|
					# Test the subtype
					test(
						val, type, :present, # Present var
						'default',
						type # Correct type, so should return the var
					)
					
					# Test again if the subtype matches its supertype
					test(
						val, type, :present, # Present var
						'default',
						super_type # Correct type, so should return the var
					) if super_type != nil && super_type != type
				end

			end

			describe "type mismatch: return the default" do

				example_set(:present) do |val, type, super_type|

					context "type == #{type.to_s}" do

						example_set(:present, [type]) do |val_other, type_other, super_type_other|

							test(
								val_other, type_other, :present, # For each other type of variable
								'default',
								type # Check it isn't this kind of variable
							) unless super_type != nil && type_other.superclass == super_type

						end

					end
					
				end

			end

		end

	end

end