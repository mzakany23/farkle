require_relative '../lib/player'

describe Player do 
	before do 
		@player = Player.new('Robot')
	end

	it 'has score' do 
		@player.score = 5
	end
end