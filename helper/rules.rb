module RulesHelper
	def scorable?
		self.count_pairs[:singles] || self.count_pairs[:triples] ? true : false
	end

	def flow_over(points) 
		total_ones  = list.count(1) unless list.count(1).nil?
		total_fives = list.count(5) unless list.count(5).nil?
		ones  = points.count(1)
		fives = points.count(5)
		left_overs = {
			ones: [total_ones >= ones ? total_ones-ones : 0],
			fives: [total_fives >= fives ? total_fives-fives : 0 ]
		}
	end

	def left_overs(options)
		total_ones  = self.list.count(1)
		total_fives = self.list.count(5)
		left_ones  = options[:ones][0]
		left_fives = options[:fives][0]
		o = total_ones - left_ones
		f = total_ones - left_fives
		total = [o,f]
	end

	def max_ones_count
		sing = @turn.current_roll.count_pairs[:singles].count(1)
		sing > left_overs(:ones) ? sing - left_overs(:ones) : 5
	end

	def max_fives_count
		fiv = @turn.current_roll.count_pairs[:singles].count(5)
		fiv > left_overs(:fives) ? fiv - left_overs(:fives) : 5
	end

	def non_singles?(array)
		check_arr = [0,2,3,4,6,7,8,9]
		array.each {|d| return true if check_arr.include?(d)}
	end

	def scoring_options(num) #return symbol
		Rules.options.fetch(num)
	end

	def grabbed_triple_score(triple_roll)
		triple_roll.current_roll.score_triple.nil? ? nil : triple_roll.current_roll.score_triple
	end

	def score_triple
		triple = self.count_pairs[:triples][0]
		count  = self.count_pairs[:triples].count
		case triple
		when 1
			1000*count
		when 2
			200*count
		when 3
			300*count
		when 4
			400*count
		when 5
			500*count
		when 6
			600*count
		end
	end

	def scored_straight
		2500
	end

	private 

	def left_overs(symbol)
		left_overs = 0
		if symbol == :ones
			turn.scored_selections.nil? ? left_overs = 0 : left_overs = turn.scored_selections.count(1)
		elsif symbol == :fives
			turn.scored_selections.nil? ? left_overs = 0 : left_overs = turn.scored_selections.count(5)
		end
	end

end