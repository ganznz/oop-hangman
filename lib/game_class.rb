# frozen-string-literal: true

require_relative 'game_text_module'
require_relative 'string_class'
require_relative 'hangman_ascii_class'

# class including game methods
class Game
  include GameText

  attr_accessor :game_word

  def initialize
    @game_word = generate_word
    @guess_progression = '_' * @game_word.length
    @guessed_letters = []
    @guessed_letters_coloured = []
    @guesses_remaining = 10
  end

  def play_game
    until @guesses_remaining.zero?
      puts
      puts guesses_remaining_text(@guesses_remaining)
      puts @guess_progression
      letter = guess_letter
      system 'clear'

      if already_guessed?(letter)
        puts "\n\n#{hangman_ascii(@guesses_remaining)}"
        puts
        already_guessed_letter
        next
      end

      if good_guess?(letter)
        puts "\n\n#{hangman_ascii(@guesses_remaining)}"
        puts
        correct_guess(letter)
      else
        @guesses_remaining -= 1
        puts "\n\n#{hangman_ascii(@guesses_remsaining)}\n"
        puts
        incorrect_guess
      end

      update_guessed_letter_arrays(letter)
      puts "Letters guessed: #{@guessed_letters_coloured.join(' ')}"

      if @guess_progression == @game_word
        puts game_won_text
        break
      elsif @guess_progression != @game_word && @guesses_remaining.zero?
        puts game_lost_text(@game_word)
        break
      end
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
    letter
  end

  def update_guessed_letter_arrays(letter)
    good_guess?(letter) ? @guessed_letters_coloured << letter.green : @guessed_letters_coloured << letter.red
    @guessed_letters << letter
  end

  def already_guessed?(letter)
    @guessed_letters.include?(letter)
  end

  def good_guess?(letter)
    @game_word.include?(letter)
  end

  def correct_guess(letter)
    puts good_guess_text
    update_letter_progression(letter)
  end

  def incorrect_guess
    puts bad_guess_text
  end

  def already_guessed_letter
    puts already_guessed_that_letter_text
  end
end
