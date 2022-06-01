# frozen-string-literal: true

require_relative 'string_class'

# Includes methods that get used as commentary throughout the game
module GameText
  def enter_letter_text
    'Enter a letter:'
  end

  def enter_another_letter_text
    'Please enter another letter:'.red
  end

  def good_guess_text
    "\s\s >>Good guess :D".green
  end

  def bad_guess_text
    "\s\s >>Bad guess :(".red
  end

  def guesses_remaining_text(guesses_remaining)
    if guesses_remaining > 3
      "You have #{guesses_remaining} guesses remaining.".yellow
    else
      "AAAH SHIT YOU ONLY HAVE #{guesses_remaining} GUESSES REMAINING".red
    end
  end

  def letters_guessed_text(guessed_letters)
    "Guessed letters: #{guessed_letters}."
  end

  def already_guessed_that_letter_text
    "\s\s >>Oops! You've already guessed that letter.".red
  end

  def invalid_guess_length_text
    "\s\s >>Make sure to enter a single letter.".red
  end

  def game_won_text
    'Congrats, you won!'
  end

  def game_lost_text(game_word)
    "You're out of guesses!\nThe word was #{game_word}"
  end
end
