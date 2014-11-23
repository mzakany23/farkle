module StatsHelper
	def farkle_odds	
		farkel_odds = {
			1 => 66.67,
			2 => 44.44,
			3 => 27.77,
			4 => 15.74,
			5 => 7.72,
			6 => 2.52
		}
		
		farkel_odds[self.dice_left]

	end

	def div(x,y,times=nil)
		times.nil? ? (x.to_f/y.to_f).round(5) : ((x.to_f/y.to_f)**times).round(5)
	end
	
	def perm(set,how_many)
		validate(set)**how_many
	end

	def fac(num,stop=1)
		num.downto(stop).each.inject(1) {|product, n| product*=n}
	end

	def comb_rep(perm1,perm2)
		perm1/perm2
	end

	def comb_no_rep(set,choices)
		set = validate(set)
		fac((set+(choices-1)))/(fac(choices)*(fac(set-1)))
	end

	private

	def validate(set)
		set.class == Array ? set = set.count : set
	end

end