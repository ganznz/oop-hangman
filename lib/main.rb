# frozen_string_literal: true

require_relative 'game_class'

system 'clear' # clears console when program runs

# game instance initialization
game = Game.new
game.play_game

puts "\n\nThanks for playing!"
puts "Run the command #{'ruby lib/main.rb'.yellow} if you want to replay!"
