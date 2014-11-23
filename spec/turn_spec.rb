require_relative '../lib/turn'
require_relative '../lib/rules'
require_relative '../helper/interface'
require_relative '../lib/game'

describe Turn do 
	include InterfaceHelper

	before do 
		@turn = Turn.new(1)
	end

	it 'can roll' do 
		expect(@turn.roll).to be_an_instance_of Rules
	end

	# it 'can re-roll' do 
	# 	@turn.roll
	# 	@turn.dice_left -=1
	# 	expect(@turn.re_roll.list.count).to eq(5)
	# end
	
	it 'can be scorable or not' do 
		expect(Rules.new([1,1,1,2,3,2]).scorable?).to be(true)
	end

	it 'can be farkled' do 
		arr = [3,2,2,3,4,4]
		turn = Turn.new(1)
		turn.point_tally = 100
		expect(Rules.new(arr).scorable?).to be(false)
		turn.farkled
		p turn
		expect(turn.point_tally).to be(0)
	end

	
	
end