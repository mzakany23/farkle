module InterfaceHelper
	def has?(symbol)
		turn.current_roll.count_pairs.has_key?(symbol)
	end

	def show_result_of_one_last_turn(last_throws)
		runner_up = last_throw_runner_up(last_throws)
		if runner_up.count > 1 && game.winner.score == runner_up[0].score
			p  '-------------------------------------------'
			p "It's a #{runner_up.count+1} way tie. So that means"
			p  "there's #{runner_up.count+1} farkle winners!"
			p  "#{game.winner.name}'s score: #{game.winner.score}"
			runner_up.each do |player|
				p "#{player.name}'s score: #{player.score}"
			end
			p "All #{runner_up.count+1} are the farkle winners!"
			p  '-------------------------------------------'		
		elsif runner_up[0].score > game.winner.score && runner_up.count >= 2
				p  '-------------------------------------------'
				runner_up.each do |player|
					p "#{player.name}'s score: #{player.score}"
					p "Are the farkle winners!"
				end
				p  '-------------------------------------------'
		elsif game.winner.score > runner_up[0].score
			p  '-------------------------------------------'
			p  "#{game.winner.name} scored: #{game.winner.score}"
			p  "#{runner_up[0].name} came in second with #{runner_up[0].score}"
			p  "Congrats, #{game.winner.name}, you are the farkle winner!"
			p  '-------------------------------------------'
		elsif runner_up[0].score > game.winner.score
			p  '-------------------------------------------'
			p "#{runner_up[0].name} scored: #{runner_up[0].score}"
			p "Which is more than #{game.winner.name}'s #{game.winner.score} score."
			p "#{runner_up[0].name}, you are the farkle winner!"
			p  '-------------------------------------------'
		elsif game.winner.score < runner_up[0].score
			p  '-------------------------------------------'
			p "#{runner_up[0].name}, you scored #{runner_up[0].score}!"
			p "Which is more than #{game.winner.name}'s #{game.winner.score} score."
			p "#{runner_up[0].name}, You are the farkle winner!"
			p  '-------------------------------------------'
		elsif game.winner.score == runner_up[0].score
			p  '-------------------------------------------'
			p "#{runner_up[0].name}, you scored #{runner_up[0].score}."
			p "Which is equal to #{game.winner.name}'s #{game.winner.score} score."
			p "#{game.winner.name} and #{runner_up[0].name}, you are the farkle winners!"
			p  '-------------------------------------------'	
		end

	end

	def last_throw_runner_up(players)
		max_last_turn_score = 0
		runner_up = []

		players.each do |turn|
			player = game.find_player(turn.player)
			new_score = turn.point_tally + player.score
			game.find_player(turn.player).score = new_score

			if new_score >= max_last_turn_score
				max_last_turn_score = new_score
				max_last_turn_score
				runner_up << player
				runner_up.each {|p| runner_up.delete(p) if p.score < player.score}
			end
		end
		runner_up
	end

	def make_game
		players = []
		p "Welcome to the game farkle."
		p "How many players will be playing?"
		input = gets.chomp.to_i
		input_validated?(input,[1,2,3,4,5,6]) ? input : make_game
		input.times do 
			name = make_valid_name
			while players.include? name
				p "Enter a name that has not already been taken"
				name = make_valid_name
			end
			players << Player.new(name)
		end
		Game.new(players)
	end

	def set_max_score
		p "Enter a max score from 2500 to 10000"
		score = gets.chomp.to_i
		if score < 2500 || score > 10000
			p "Enter a proper max score between 2500-10000"
			set_max_score
		end
		game.max_score = score
	end

	def show_farkle_winner
		p  '-------------------------------------------'
		p  "#{game.winner.name}, you have reached the max score of #{game.max_score}"
		p  "You are the preliminary winner, meaning the other players"
		p  "Have another turn to beat you..."
	end
	
	def show_hot_dice_message
		p  '-------------------------------------------'
		p "#{players_name} has Hot Dice!"
		p "#{players_name} gets another roll."
		turn.scored_selections = []
		turn.dice_left = 6
		turn.point_tally = 0
	end

	def lets_roll
		p  '-------------------------------------------'
		p  "#{players_name}'s' Turn:"
		p  "Total dice left: #{turn.dice_left}"
		p  "Point tally: #{turn.point_tally}"
		p  "Total Points: #{players_total_score}"
		p  "Roll: #{turn.player_roll_count}"
		p  'Farkle Options Board:'
		p  '-------------------------------------------'
		if turn.player_roll_count > 1 
			p turn.over_farkle_count? ? "#{players_name}, you lose your turn because you farkled #{turn.max_farkle_count} times" 
																: "point tally is #{turn.point_tally}, re-rolling..."
			p turn.over_farkle_count? ?  "Press 1: for next player turn." : "press 1: when ready to roll: " 
		else
			p 'press 1: when ready to roll: '
		end
		p  '-------------------------------------------'

		select = gets.chomp.to_i

		input_validated?(select,[1]) ? select : lets_roll
	end

	def roll_board(has_singles,has_triples,has_straight)
		selections = []
		p 'What do you want to do?'
		p '1: (score singles): ' if has_singles
		p "2: (score nothing, re-roll #{turn.over_farkle_count? ? 0 : turn.dice_left}) "
		p "3: (score triples): " if has_triples
		p "4: (score straight): " if has_straight
		p  '-------------------------------------------'

		input = gets.chomp.to_i
		one 	= 1 if has_singles
		two 	= 2 if turn.dice_left
		three = 3 if has_triples
		four  = 4 if has_straight

		if turn.dice_left == 1 && has_singles
			begin
				player_score = @game.find_player(turn.player).score
			rescue
				player_score = @game.find_player(turn.player)[0].score
			end
			player_score += turn.point_tally

			begin 
				@game.find_player(turn.player).score = player_score
			rescue
				@game.find_player(turn.player)[0].score = player_score
			end
			
			p "Cashing in #{turn.point_tally} points"
			p "#{players_name}'s new score is: #{player_score}"
			turn.still_players_turn = false
		else
			input_validated?(input,[one,two,three,four]) ? input : roll_board(has_singles,has_triples,has_straight)	
		end
	end


	def grab_singles
		p "Select your single options: (like '115' or '1')"									
		input = gets.chomp
		input_arr = input.each_char.inject([]) {|arr,val| arr << val.to_i}

		if input_arr.count(1) > max_ones_count || input_arr.count(5) > max_fives_count || non_singles?(input_arr) == true
			p 'Nice try, only select what values you can select. (retry)'
			p @turn.current_roll.count_pairs
			grab_singles	
		else
			input_arr
		end
	end
	
	def grab_triples
		turn.dup
	end

	def players_name
		begin
			game.find_player(turn.player).name
		rescue
			game.find_player(turn.player)[0].name
		end
	end


end
