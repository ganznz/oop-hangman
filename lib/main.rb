# frozen_string_literal: true

require_relative 'game_class'

system 'clear' # clears console when program runs

chosen_mode = Game.choose_mode

# game instance initialization
game = chosen_mode == '1' ? Game.new : Game.load_save_file
system 'clear' 

game.play_game

puts "\n\nThanks for playing!"
puts "Run the command #{'ruby lib/main.rb'.yellow} if you want to play again!"
