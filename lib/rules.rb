require_relative '../helper/rules'

class Rules
	include RulesHelper
	
	attr_accessor :list

	def initialize(roll)
		@list = roll
	end

	def self.options
		options = {1 => :singles, 3 => :triples, 7 => :straight}
	end
	
	def count_pairs
		matches = {
			1 => @list.select {|a| a == 1},
			2 => @list.select {|a| a == 2},
			3 => @list.select {|a| a == 3},
			4 => @list.select {|a| a == 4},
			5 => @list.select {|a| a == 5},
			6 => @list.select {|a| a == 6}
		}

		set = {
			singles:  [],
			triples:  [],
			straight: []
		}
		
		unless matches[1].empty? 
			matches[1].count.times do 
				set[:singles] << 1
			end
		end

		unless matches[5].empty?
			matches[5].count.times do 
				set[:singles] << 5 
			end
		end
		
		for i in 1..6
			if @list.each.inject("") {|str, val| str += val.to_s } == '123456'
				set[:straight] = [1,2,3,4,5,6]
			elsif matches[i].count >= 3 && matches[i].count <= 5
				set[:triples] << matches[i].last
			elsif matches[i].count == 6
				2.times {set[:triples] << matches[i].last}
			end
		end
		x = 0 
		set.delete(:straight) if set[:straight][0] == false
		set.delete_if {|k,v| v.empty?}
	end

	
end
