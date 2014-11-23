Dir["../helper/*.rb"].each {|file| load file }
Dir["../lib/*.rb"].each {|file| load file }


inter = FarkleInterface::Run.new
game = inter.make_game
inter.game = game
inter.set_max_score
inter.run_game