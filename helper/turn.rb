module TurnHelper
	def players_total_score
		begin
			game.find_player(turn.player).score
		rescue
			game.find_player(turn.player)[0].score
		end
	end

	def set_to_last_turn
		@dice_left    			 = 6
		@point_tally  			 = 0
		@player_roll_count   = 1
		@scored_selections   = []
		@farkle_count				 = 0
		@max_farkle_count		 = 0
		@still_players_turn  = true
	end

	def over_farkle_count?
		@farkle_count >= @max_farkle_count
	end

	def cash_in(points)
		player_score = @game.find_player(@turn.player).score
		player_score += points
		game.find_player(@turn.player).score = player_score
	end
end