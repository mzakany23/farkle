Farkle
==========

'''
Built with ruby 1.9.3- with no dependencies.
'''

'''
Build:
==========
> cd inside the farkle main folder
> ruby start_farkle.rb
'''

'''
The program is made to account for:
> adding players (max 10)
> setting score (min score 2500, max 10000)
> hot dice
> farkling
> winning
> one last turn for the rest of players
> keeping track of player scores, turn point tallys ect.
'''
 
 Delving deeper:
 ==========
 '''
 Most of the logic is held in the Turn and Rules classes:
 Turns:
 > rolling/re-rolling
 > tallying turn points
 > knowing when to quit
 > knowing when to farkle
 > knowing when to allow another turn (hot dice)
 
 Rules (scoing rules):
 > knowing how to calculate triples/singles/straight
 > knowing when there's flow over ([1,1,1,1,2,2] scoring triple, and extra 1)
 
 '''
 Thanks
 Michael C. Zakany
 ==========
 
