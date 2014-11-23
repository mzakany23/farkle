require_relative 'player'
require_relative 'game'
require_relative 'rules'
require_relative 'turn'
require_relative '../helper/validations'
require_relative '../helper/interface'
require_relative '../helper/rules'
require_relative '../helper/turn'


module FarkleInterface 
	class Run
		include Validations, InterfaceHelper, RulesHelper, TurnHelper

		attr_accessor :game, :turn

		def make_players(players) #players should be integer
			play_arr = []
			for i in 1..players
				name = make_valid_name
				play_arr << Player.new(name)
			end
			@game = Game.new(play_arr)
		end

		def run_game #keeps looping
			p 'Starting Game: '
			# sleep(2)
			while game.max_player_score < game.max_score
				game.players_arr.each do |player| #player turns
					
					@turn = Turn.new(player.id)	

					while turn.still_players_turn && game.max_player_score < game.max_score
						
						@turn.roll

						lets_roll

						p  '-------------------------------------------'
						p "#{players_name}, you rolled: #{turn.current_roll.list}"

						#----------------------------------------------------------------------------------
						# dealing with farkling
						#----------------------------------------------------------------------------------
						if turn.point_tally > 0 && turn.current_roll.scorable? == false
							p "Farkle...lost point tally #{turn.point_tally}"
							turn.farkled
							turn.dice_left = 6
							turn.farkle_count += 1
							turn.scored_selections = []
							p "Unfortunately, your new point tally is #{turn.point_tally}"
						elsif turn.over_farkle_count? 
							turn.still_players_turn = false
						else
							options  = roll_board(has?(:singles),has?(:triples),has?(:straight))
							
							case options
						#----------------------------------------------------------------------------------
						# singles, triples, and straights
						#----------------------------------------------------------------------------------
							when 1
								p "Your selections are: #{@turn.current_roll.count_pairs[:singles]}"								
								turn.scored_selections = grab_singles
								cash_in_single_options
							when 2
								#blank on purpose
							when 3
								t = turn.current_roll.count_pairs[:triples][0]
								3.times {turn.scored_selections << 1}
								p "Triples are: #{@turn.current_roll.count_pairs[:triples]}"
								cash_in_triple_options(grab_triples)
							when 4 
								cash_in_straight
							end 
						end
						#----------------------------------------------------------------------------------
						# winner
						#----------------------------------------------------------------------------------
					end #end while	
					
					game.set_winner(game.find_player(turn.player))

					break
				end #end while
			end 
			# turn.set_to_last_turn
			one_last_throw
		end #run_game method





		




		private

		#----------------------------------------------------------------------------------
		# Single helper
		#----------------------------------------------------------------------------------

		def cash_in_single_options
			p  '-------------------------------------------'
			p 'Do you want to cash in, or re-roll?'
			p "Note, if you re-roll you are at #{turn.farkle_odds}% risk of farkling"
			p '1: cash in: '
			p '2: tally points and re-roll: '
			p '3: re-roll without tallying points'
			p  '-------------------------------------------'
			
			input = gets.chomp.to_i
			
			input_validated?(input,[1,2,3]) ? input : cash_in_single_options
			
			case input
			
			when 1
				last_ones  = 0
				last_fives = 0
				cashed_in_points = 0

				points = turn.scored_selections

				show_flow_over(:singles)

				points.count(1).nil? ? 0 : last_ones  += (points.count(1) * 100)
				points.count(5).nil? ? 0 : last_fives += (points.count(5) * 50)
				begin
					player_score = @game.find_player(turn.player).score
				rescue
					player_score = @game.find_player(turn.player)[0].score
				end
				player_score += last_ones 
				player_score += last_fives
				player_score += turn.point_tally if turn.point_tally > 0
				
				last_point_tally = turn.point_tally + last_ones + last_fives
	
				last_point_tally == players_total_score ? cashed_in_points = players_total_score : cashed_in_points = last_point_tally
				
				begin
					game.find_player(turn.player).score = player_score
				rescue
					game.find_player(turn.player)[0].score = player_score
				end

				turn.dice_left -= points.count

				p "#{players_name} cashed in #{cashed_in_points} points"	
				p "#{players_name}'s total score is: #{players_total_score}"
				
				if turn.hot_dice?
					show_hot_dice_message
				else
					@turn.still_players_turn = false		
				end
	
			when 2
				points = turn.scored_selections
				turn.point_tally += (points.count(1) * 100) if points.count(1)
				turn.point_tally += (points.count(5) * 50) if points.count(5)
				turn.dice_left -= points.count
				turn.player_roll_count += 1
				p "Tallying #{turn.point_tally}, re-rolling #{turn.dice_left} dice..."
				turn.re_roll
			when 3 
				p "Didn't tally any points, re-rolling #{turn.dice_left} dice..."
				turn.re_roll
			end
		end

		#----------------------------------------------------------------------------------
		# triple
		#----------------------------------------------------------------------------------


		def cash_in_triple_options(triple_dup)
			p  '-------------------------------------------'
			p "You have the option to cash in triple #{triple_dup.current_roll.count_pairs[:triples][0]}'s"
			p "Do you want to cash in, or re-roll?"
			p "Note, if you re-roll you are at #{turn.farkle_odds}% risk of farkling"
			p  '-------------------------------------------'
			p '1: cash in: '
			p '2: tally points and re-roll: '
			p '3: re-roll without tallying points'
			p  '-------------------------------------------'

			option = gets.chomp.to_i

			input_validated?(option,[1,2,3]) ? option : cash_in_triple_options
			
			@triple_score = grabbed_triple_score(triple_dup)

			case option
			
			when 1
				show_flow_over(:triples)
				p  '-------------------------------------------'
				p "Cashing in #{@triple_score}..."
				begin
			 		player_score = @game.find_player(@turn.player).score
				rescue
					player_score = @game.find_player(@turn.player)[0].score
				end
					player_score += triple_dup.point_tally if triple_dup.point_tally > 0
					player_score += @triple_score
				begin
					@game.find_player(triple_dup.player).score = player_score
				rescue
					@game.find_player(triple_dup.player)[0].score = player_score
				end
				
				p "#{players_name} cashed in a point tally of #{triple_dup.point_tally}" if triple_dup.point_tally > 0
				p "#{players_name}'s total points are #{players_total_score}"
				p "#{players_name}'s Score is: #{players_total_score}"

				turn.dice_left -= 3
				
				if turn.hot_dice?
					show_hot_dice_message
				else
					turn.still_players_turn = false	
				end
				
			when 2
				new_point_tally = turn.point_tally + @triple_score
				turn.point_tally = new_point_tally
				turn.dice_left -= 3
				turn.player_roll_count +=1
				p "Tallying #{turn.point_tally}, re-rolling #{turn.dice_left} dice..."
				turn.re_roll
			when 3
				p "Didn't tally any points, re-rolling #{turn.dice_left} dice..."
				turn.re_roll
			end
		end

		#----------------------------------------------------------------------------------
		# straight
		#----------------------------------------------------------------------------------

		def cash_in_straight
			p  '------------------------------------------------------------------------'
			p "You have the option to cash in and re-roll"
			p "Because you scored a S-T-R-A-I-G-H-T !!!"
			p '1: cash in and re-roll (automatic hot-dice)'
			p  '------------------------------------------------------------------------'

			option = gets.chomp.to_i
			input_validated?(option,[1,2,3]) ? option : cash_in_straight

			case option
			when 1
				p "cashing in #{scored_straight} to #{players_name}"
				game.find_player(turn.player).score += scored_straight
				p "#{players_name}'s new score' is #{players_total_score}"
				p "You get to roll again..."
				turn.scored_selections = []
				turn.point_tally = 0
				turn.dice_left = 6
			end
		end


		def show_flow_over(symbol)
			unless turn.current_roll.flow_over(turn.scored_selections) == {ones: [0], fives: [0]}
				
				p  '-------------------------------------------'
				p "You still have leftovers!"
				p "Take a look #{turn.current_roll.flow_over(turn.scored_selections)}"
			  p "1: cash in"
				p "2: tally"
				p  '-------------------------------------------'
				input = gets.chomp.to_i
				
				if symbol == :singles

					input_validated?(input,[1,2]) ? input : show_flow_over(symbol)

					case input
					when 1
						#blank on purpose
					when 2
						p  '-------------------------------------------'
						p "Again, #{turn.current_roll.flow_over(turn.scored_selections)}"
						turn.scored_selections.concat(grab_singles)
						p  '-------------------------------------------'
						show_flow_over(symbol)
					end
				elsif symbol == :triples
					input_validated?(input,[1,2]) ? input : show_flow_over

					case input
					when 1
						#blank on purpose
					when 2
						p  '-------------------------------------------'
						p "Again, #{turn.current_roll.flow_over(turn.scored_selections)}"
	
						input = grab_singles
						turn.scored_selections.concat(input)
						ones = (input.count(1) * 100) unless input.count(1).nil?
						fives = (input.count(5) * 50) unless input.count(5).nil?
						@triple_score += ones += fives
						show_flow_over(symbol)
					end
				end
			end
		end


		def one_last_throw # something is wrong with this re write it
			show_farkle_winner if game.runner_up_even_close? == true
			last_turn_arr = []
			one_more_turn = 0
		
			if game.runner_up_even_close? # this may be the culprit?
				
				while one_more_turn < 1
					
					@game.players_arr.each do |player|			
						turn.set_to_last_turn
						
						@turn = Turn.new(player.id)

						while turn.still_players_turn

							p  '-------------------------------------------'
							p "#{player.name} here's your one last turn,"
							p "and farkling means you lose."

						@turn.roll
						
						p  '-------------------------------------------'
						p "#{player.name}, you rolled: #{turn.current_roll.list}"
						if turn.point_tally > 0 && turn.current_roll.scorable? == false
							p "#{player.name} you farkled, so you lose."
						else
							options  = roll_board(has?(:singles),has?(:triples),has?(:straight))

							case options
								
							when 1
								p "Your selections are: #{@turn.current_roll.count_pairs[:singles]}"								
								turn.scored_selections = grab_singles
								cash_in_single_options
							when 2
								#blank on purpose
							when 3
								cash_in_triple_options(@turn)
							when 4 

							end 
							
							last_turn_arr << turn
							one_more_turn += 1
						end
						end
					end #end while
					show_result_of_one_last_turn(last_turn_arr)
				end #end player turn
			else
				p "#{game.winner.name} is the defacto winner!"
				p "No need for any other player to roll because"
				p "The min score needed is #{game.winner.score - 2500}"
				p "which no body has."
				p "Congrats to #{game.winner.name}!"
				p  '-------------------------------------------'
			end
		end #end one_last_turn method
		
	end #end class
end #end module

