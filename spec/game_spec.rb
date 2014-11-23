require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/rules'
require_relative '../lib/turn'

describe Game do 
	before do 
		mike  = Player.new('Mike')
		jo    = Player.new('jo')
		arr = []
		arr << jo
		arr << mike
		@game = Game.new(arr)
	end

	it 'keeps track of max score' do 
		mike = @game.find_player("Mike")
		jo = @game.find_player('jo')
		jo.score = 500
		mike.score = 600
		expect(@game.max_player_score).to eq(600)
	end


end
