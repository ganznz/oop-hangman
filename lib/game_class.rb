# frozen-string-literal: true

require_relative 'game_text_module'
require_relative 'string_class'

# class including game methods
class Game
  include GameText

  attr_accessor :game_word

  def initialize
    @game_word = generate_word
    @guess_progression = '_' * @game_word.length
    @guessed_letters = []
    @guesses_remaining = 10
  end

  def play_game
    until @guesses_remaining.zero?
      puts guesses_remaining_text(@guesses_remaining)
      puts @guess_progression
      letter = guess_letter
    end
  end

  private

  def generate_word
    ten_thousand_words_file = 'google-10000-english-no-swears.txt' if File.exist?('google-10000-english-no-swears.txt')
    ten_thousand_words_array = File.open(ten_thousand_words_file, 'r').read.split("\n")

    words_between_5_and_12_characters = ten_thousand_words_array.select do |word|
      word.length >= 5 && word.length <= 12
    end
    words_between_5_and_12_characters[rand(0..words_between_5_and_12_characters.length - 1)]
  end

  def update_letter_progression(letter)
    guess_progression_array = @guess_progression.split('')
    word_to_guess_array = @game_word.split('')

    word_to_guess_array.each_with_index do |element, i|
      guess_progression_array[i] = element if element == letter
    end

    @guess_progression = guess_progression_array.join
  end

  def guess_letter
    puts enter_letter_text
    letter = gets.chomp.downcase

    until !letter.nil? && letter.length == 1 && (letter.ord >= 97 && letter.ord <= 122)
      puts invalid_guess_length_text
      letter = gets.chomp.downcase
    end
    @guessed_letters << letter
    letter
  end

  def already_guessed?(letter)
    @guessed_letters.include(letter)
  end

  def correct_guess?(letter)
    @game_word.include?(letter)
  end

  def if_correct_guess(letter)
    puts good_guess_text
    update_letter_progression(letter)
    puts @guess_progression
  end

  def if_incorrect_guess(letter)
    puts bad_guess_text
    @guesses_remaining -= 1
  end

  def already_guessed_letter
    puts already_guessed_that_letter_text
  end

  def game_won?
    
  end
end