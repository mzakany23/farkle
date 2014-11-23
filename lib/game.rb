class Game
	attr_reader   :players_arr, :winner
	attr_accessor :max_score
	
	def initialize(players)
		@players_arr = []
		@max_score   = 10000
		@winner 		 = nil
		num 				 = 1		
		
		players.each do |player|
			player.id  = num 
			@players_arr << player
			num += 1
		end
	end

	def add_to_player_score(player_id,score)
		@players_arr.each {|d| d.score += score if player_id == d.id}
	end

	def find_player(id)
		@players_arr.each {|d| return d if id == d.id}
	end


	def set_winner(player)
		@winner = player
	end

	def score
		@players_arr.each {|player| p  player.score}
	end

	def max_player_score
		greatest_score = 0
		@players_arr.each {|player| greatest_score = player.score if player.score > greatest_score}
		greatest_score
	end

	def runner_up_even_close?
		@winner.nil? ? false : @winner
		min_second_place_score = @winner.score - 2500
		@players_arr.delete(find_player(@winner.id))
		@players_arr.each do |p|
		
			if p.score >= min_second_place_score.to_i
				return true
				break
			else
				return false
			end
		end
	end

end