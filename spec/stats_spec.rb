require_relative '../helper/stats'
require_relative '../lib/rules'
require_relative '../lib/turn'

describe "Stats" do 
	before do 
		@roll = [2,3,4,2,1,5]
		@arr  = [1,2,3,4,5,6,7,8,9,10]
		@turn = Turn.new(1)
		@turn.roll
	end

	it 's' do
		turn = Turn.new(1)
		turn.current_roll = @roll.sort
		turn.dice_left -= 2
		turn.re_roll
		expect(turn.farkle_odds).to eq(15.74)
	end

	#order does matter
	context 'Permutations' do 
		it 'order does not matter' do 
			expect(@turn.perm(@arr,3)).to eq(1000)
		end

		it 'order matters' do 
			expect(@turn.fac(16,14)).to eq(3360)
		end

		it '10 people, first and second place probabilities' do 
			expect(@turn.fac(10,9)).to eq(90)
		end
	end

	#order does not matter
	context 'Combinations' do 
		it 'no repitition i.e. lotteries' do 
			perm1 = @turn.fac(16,14)
			perm2 = @turn.fac(3)
			expect(@turn.comb_rep(perm1,perm2)).to eq(560)
		end

		it 'repitition' do 
			set = [1,2,3,4,5]
			variations_of = 3
			expect(@turn.comb_no_rep(set,variations_of)).to eq(35)
		end

	end

	context 'Examples' do 
		#order matters
		it 'perm 3 unique digits 0-9 inclusive' do 
			expect(@turn.fac(10,8)).to eq(720)
		end

		#order doesn't matter
		it 'committees of 5 people from group of 10' do 
			perm1 = @turn.fac(10,6)
			perm2 = @turn.fac(5)
			expect(@turn.comb_rep(perm1,perm2)).to eq(252)
		end

		#order doesn't matter
		it 'number of combinations of 4 people from 9' do 
			perm1 = @turn.fac(9,6)
			perm2 = @turn.fac(4)
			expect(@turn.comb_rep(perm1,perm2)).to eq(126)
		end

		it '4 diff letters out of 26' do 
			expect(set = @turn.fac(26,23)).to eq(358800)
		end

		it 'two letters of alph and three numbers [0-9]' do 
			expect(@turn.perm(26,2)*@turn.perm(10,3)).to eq(676000)
		end

		it 'roll 6 dice' do 
			#non farkles
			triples = [2,3,4,6].count
			dice    = 6
			grab    = 3

			p @turn.div(1,6,3)

			p 6**6
			p (6**6)/13680.to_f
			


		end
	end






	
end