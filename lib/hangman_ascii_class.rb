def hangman_ascii(guesses_remaining)
  case guesses_remaining
    when 10
      '      |
      |
      |
      |
      |'

    when 9
      '      |
      |
      |
      |
      |'

    when 8
      '   +---+
       |
       |
       |
       |
       |'

    when 7
      '   +---+
   |   |
       |
       |
       |
       |'
    
    when 6
      '   +---+
   |   |
       |
       |
       |
       |'

    when 5
      '   +---+
   |   |
   O   |
       |
       |
       |'

    when 4
      '   +---+
   |   |
   O   |
   |   |
       |
       |'

    when 3
      '   +---+
   |   |
   O   |
  /|   |
       |
       |'

    when 2
      '   +---+
   |   |
   O   |
  /|\  |
       |
       |'

    when 1
      '   +---+
   |   |
   O   |
  /|\  |
  /    |
       |'

    when 0
      '   +---+
   |   | B
   O   | R
  /|\  | U
  / \  | H
       |'
    end
end
