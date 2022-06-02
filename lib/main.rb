# frozen_string_literal: true

require_relative 'game_class'

replay_game = true

while replay_game
  system 'clear' # clears console whenever a new game starts

  # game instance initialization
  game = Game.new
  game.play_game

  replay_game = false unless game.replay_game?
end

puts 'Thanks for playing!'
puts "Run the command #{'ruby lib/main.rb'.yellow} if you want to replay!"
