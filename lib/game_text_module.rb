# frozen-string-literal: true

require_relative 'string_class'

# Includes methods that get used as commentary throughout the game
module GameText
  def welcome_text
    'Welcome to Hangman!'
  end

  def enter_letter_text
    "Enter a letter #{'or type'.italic} #{'save'.yellow.italic} #{'to save your game'.italic}:"
  end

  def enter_another_letter_text
    'Please enter another letter:'.red
  end

  def good_guess_text
    "\nGood guess :D".green
  end

  def bad_guess_text
    "\nBad guess :(".red
  end

  def guesses_remaining_text(guesses_remaining)
    if guesses_remaining > 3
      "\nYou have #{guesses_remaining} guesses remaining.".yellow
    else
      "\nAAAH SHIT YOU ONLY HAVE #{guesses_remaining} GUESSES REMAINING".red
    end
  end

  def letters_guessed_text(guessed_letters)
    "Guessed letters: #{guessed_letters}."
  end

  def already_guessed_that_letter_text
    "\nYou've already guessed that letter!".red
  end

  def invalid_guess_length_text
    "\s\s >>Make sure to enter a single letter.".red
  end

  def game_won_text(game_word)
    "Congrats, you guessed the letter #{game_word.yellow}."
  end

  def game_lost_text(game_word)
    "You're out of guesses!\nThe word was #{game_word.yellow}."
  end

  def replay_game_text
    'Would you like to play again? Y/N'
  end

  def invalid_replay_game_input_text
    "\s\s >>Invalid input! Enter #{'Y'.yellow} or #{'N'.yellow}."
  end

  def save_file_input_text
    'What do you want to name your save file?'
  end

  def save_file_already_exists_text
    "\s\s>>A save file with that name already exists!\n\s\s>>Enter another name.".red
  end

  def select_game_mode_text
    question = 'What do you want to do?'
    "What do you want to do?\n#{"#{'[1]'.yellow} new game"}\n#{"#{'[2]'.yellow} load game"}"
  end
end
