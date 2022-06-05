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

  def self.choose_mode
    puts 'Welcome to Hangman!'
    puts "\n#{'What do you want to do?'.italic}\n#{"#{'[1]'.yellow} new game"}\n#{"#{'[2]'.yellow} load game"}"
    plr_input = gets.chomp.downcase

    until !plr_input.nil? && %w[1 2].include?(plr_input)
      puts "\s\s#{'Invalid input. Enter'.red} #{'1'.yellow} #{'or'.red} #{'2'.yellow}"
      plr_input = gets.chomp.downcase
    end
    puts
    plr_input
  end

  def self.save_files
    files_full_names = Dir.glob('save_files/*.yaml')
    file_shortened_names = files_full_names.map { |file| file[file.index('/') + 1..-6] }
    file_shortened_names.each_with_index { |file, i| puts "#{"[#{i + 1}]".green} #{file}" }
    file_shortened_names
  end

  def self.load_save_file
    save_files_array = save_files
    file_num_arr = []
    save_files_array.each_with_index { |_, i| file_num_arr << (i + 1).to_s }

    if !save_files_array.empty? # if there are existing save files
      puts 'Choose a save file:'.italic
      plr_input = gets.chomp.strip
      until !plr_input.nil? && file_num_arr.include?(plr_input)
        puts "\s\s>>That file index doesn't exist! Input another file number".red
        plr_input = gets.chomp.strip
      end
      file_name = save_files_array[plr_input.to_i - 1]
      file_data = File.read("save_files/#{file_name}.yaml")
      puts 'Game loading...'.italic
      sleep(2)
      YAML.load(file_data)
    else # if there are NO existing save files
      puts "It's pretty empty in here... there are no existing save files."
      puts 'Initiating new game...'.italic
      sleep(3)
      new
    end
  end

  def play_game
    play_round
    save_game(self) if @last_input == 'save'
  end

  def replay_game?
    puts replay_game_text
    plr_input = gets.chomp.downcase
    until !plr_input.nil? && %w[y n].include?(plr_input)
      puts invalid_replay_game_input_text
      plr_input = gets.chomp.downcase
    end
    plr_input == 'y'
  end

  private

  def play_round
    until @guesses_remaining.zero?
      puts guesses_remaining_text(@guesses_remaining)
      puts @guess_progression
      letter = @last_input = guess_letter
      system 'clear'

      break if letter == 'save'

      if already_guessed?(letter)
        already_guessed_letter
        puts "Letters guessed: #{@guessed_letters_coloured.join(' ')}"
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
    serialized_obj = YAML.dump(game_obj)
    file_name = save_file_name
    output_dir = 'save_files'
    Dir.mkdir(output_dir) unless File.exist?(output_dir)

    while File.exist?("#{output_dir}/#{file_name}.yaml")
      puts save_file_already_exists_text
      file_name = gets.chomp.strip
    end
    create_file(output_dir, file_name, serialized_obj)
  end

  def save_file_name
    puts save_file_input_text
    gets.chomp.strip
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
