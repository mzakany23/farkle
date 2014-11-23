class Player
	attr_reader :name
	attr_accessor :score, :id

	def initialize(name)
		@name  = name
		@score = 0
	end
end