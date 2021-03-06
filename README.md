# Farkle Command Line Implementation
==========

http://en.wikipedia.org/wiki/Farkle

Built with ruby 1.9.3- with no dependencies.


## Build:

```ruby
ruby start_farkle.rb
```

## The program is made to account for:
```
* adding players (max 10)
* setting score (min score 2500, max 10000)
* hot dice
* farkling
* winning
* selecting flow overs (see below)
* showing player scores/turn point tallies
* one last turn for the rest of players only if close to max score (see below)
* keeping track of player scores, turn point tallys ect.
* set to have multiple winners (tie for first place)
```
 
## Delving-deeper:

### Most of the logic is held in the *Turn* and *Rules* classes:
 
 ```
 Turns:
 * rolling/re-rolling
 * tallying turn points
 * knowing when to quit
 * knowing when to farkle
 * knowing when to allow another turn (hot dice)
 
 Rules (scoing rules):
 * knowing how to calculate triples/singles/straight
 * knowing when there's flow over ([1,1,1,1,2,2] scoring triple, and extra 1)

 Game: 
 * keeps track of game score and games winner
 * decides one last throw (if second place is even able to beat first place with another turn)

 ```

==========
