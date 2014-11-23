require_relative "../helper/validations"

include Validations

describe Validations do 
	it 'input validated?' do 
		input = 12
		expect(input_validated?(input,[1,2])).to be(false)
	end
	
end