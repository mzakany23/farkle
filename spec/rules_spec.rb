require_relative '../lib/turn'
require_relative '../lib/rules'

describe Rules do 

	let(:t) {Turn.new(1)}

	before do 
		def return_turn(arr)
			turn = Rules.new(arr.sort)
		end
	end

	it 'should grab triple count' do 
		arr=[2, 2, 4, 4, 5, 2]
		turn = return_turn(arr)
		expect(turn.count_pairs[:triples][0]).to eq(2)
	end

	it 'score triples' do 
		arr = [1,1,1,2,3,4,]
		turn = return_turn(arr)
		t.current_roll = turn
		expect(turn.grabbed_triple_score(t)).to eq(1000)
	end


end