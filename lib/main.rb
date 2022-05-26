# frozen_string_literal: true

ten_thousand_words_file = 'google-10000-english-no-swears.txt' if File.exist?('google-10000-english-no-swears.txt')
ten_thousand_words_array = File.open(ten_thousand_words_file, 'r').read.split("\n")

words_between_5_and_12_characters = ten_thousand_words_array.select do |word|
  word.length >= 5 && word.length <= 12
end

selected_word = words_between_5_and_12_characters[rand(0..words_between_5_and_12_characters.length - 1)]
