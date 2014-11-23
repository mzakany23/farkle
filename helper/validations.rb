module Validations
	def input_validated?(input,range)
		range.include?(input) ? true : false
	end

	def make_valid_name
		p "Enter Name"
		input = gets.chomp.capitalize
		if input.empty? || input.length < 2 
			p 'Enter a valid name (at least 2 letters): '
			make_valid_name		
		else
			input
		end
	end
end