require_relative 'rules'
require_relative 'game'
require_relative 'player'
require_relative '../helper/stats'
require_relative '../helper/turn'

class Turn < Rules
	include StatsHelper, TurnHelper

	attr_accessor :current_roll, :dice_left
	attr_accessor :point_tally, :scored_selections
	attr_accessor :player, :player_roll_count, :still_players_turn, :farkle_count, :max_farkle_count

	def initialize(players_turn)
		@dice_left    			 = 6
		@point_tally  			 = 0
		@player              = players_turn
		@player_roll_count   = 1
		@current_roll				 = nil
		@still_players_turn  = true
		@scored_selections   = []
		@farkle_count				 = 0
		@max_farkle_count		 = 2
	end

	def roll
		rolls = []
		@dice_left.times do 
			rolls << rand(1..6)
		end
	
		@current_roll = Rules.new(rolls.sort)

		#----------------------------------------------------------------------------------
		# test rolls
		#----------------------------------------------------------------------------------
		# @current_roll = Rules.new([4, 5, 6, 6, 6, 6]) 
		# @current_roll = Rules.new([1,1,1,1,5,5])
		# @current_roll = Rules.new([1,2,3,4,5,6])
		#----------------------------------------------------------------------------------
	end
		
	def re_roll
		roll
	end
	
	def farkled
		@point_tally = 0
	end

	def hot_dice?
		@dice_left == 0
	end

end #end class
