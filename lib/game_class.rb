# frozen-string-literal: true

require_relative 'game_text_module'
require_relative 'string_class'
require_relative 'hangman_ascii_class'
require 'yaml'

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
    @last_input = ''
  end

  def play_game
    play_round
    save_game(self) if @last_input == 'save'
  end

  def replay_game?
    puts replay_game_text
    plr_response = gets.chomp.downcase
    valid_responses = %w[y n]
    until !plr_response.nil? && valid_responses.include?(plr_response)
      puts invalid_replay_game_input_text
      plr_response = gets.chomp.downcase
    end
    plr_response == 'y'
  end

  private

  def to_yaml(game_obj)
    serialized_obj = YAML.dump(game_obj)
  end

  def self.from_yaml(string)
    object = YAML.safe_load(string)
  end

  def play_round
    until @guesses_remaining.zero?
      puts guesses_remaining_text(@guesses_remaining)
      puts @guess_progression
      letter = @last_input = guess_letter
      system 'clear'

      break if letter == 'save'

      if already_guessed?(letter)
        already_guessed_letter
        redo
      end

      good_guess?(letter) ? correct_guess(letter) : incorrect_guess

      update_guessed_letter_arrays(letter)
      puts "Letters guessed: #{@guessed_letters_coloured.join(' ')}"

      if @guess_progression == @game_word
        puts game_won_text(@game_word)
        break
      elsif @guesses_remaining.zero?
        puts game_lost_text(@game_word)
        break
      end
    end
  end

  def save_game(game_obj)
    serialized_obj = to_yaml(game_obj)
    file_name = save_file_name
    output_dir = 'save_files'
    Dir.mkdir(output_dir) unless File.exist?(output_dir)

    while File.exist?("#{output_dir}/#{file_name}.yaml")
      puts save_file_already_exists_text
      file_name = gets.chomp
    end
    create_file(output_dir, file_name, serialized_obj)
  end

  def save_file_name
    puts save_file_input_text
    gets.chomp
  end

  def create_file(output_directory, save_name, serialized_obj)
    File.open("#{output_directory}/#{save_name}.yaml", 'w') { |file| file.write(serialized_obj) }
  end

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
      return letter if letter == 'save'

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
    puts "\n\n#{hangman_ascii(@guesses_remaining)}" # prints hangman ascii
    puts good_guess_text
    update_letter_progression(letter)
  end

  def incorrect_guess
    @guesses_remaining -= 1
    puts "\n\n#{hangman_ascii(@guesses_remaining)}" # prints hangman ascii
    puts bad_guess_text
  end

  def already_guessed_letter
    puts "\n\n#{hangman_ascii(@guesses_remaining)}" # prints hangman ascii
    puts already_guessed_that_letter_text
  end
end
