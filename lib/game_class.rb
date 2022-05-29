# frozen-string-literal: true

require_relative 'game_text_module'

# class including game methods
class Game
  include GameText

  attr_accessor :game_word

  def initialize
    @game_word = generate_word
    @guesses_remaining = 10
  end

  def generate_word
    ten_thousand_words_file = 'google-10000-english-no-swears.txt' if File.exist?('google-10000-english-no-swears.txt')
    ten_thousand_words_array = File.open(ten_thousand_words_file, 'r').read.split("\n")

    words_between_5_and_12_characters = ten_thousand_words_array.select do |word|
      word.length >= 5 && word.length <= 12
    end
    words_between_5_and_12_characters[rand(0..words_between_5_and_12_characters.length - 1)]
  end

  private

  def letter_guessed
    puts enter_letter_text
    letter = gets.chomp.downcase

    until !letter.nil? && letter.length == 1 && (letter.ord >= 97 && letter.ord <= 122)
      puts invalid_guess_length_text
      letter = gets.chomp.downcase
    end
    letter
  end

  def correct_guess?
    letter = letter_guessed
    @game_word.include?(letter)
  end
end