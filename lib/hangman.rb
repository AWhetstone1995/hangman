class Hangman
  attr_accessor :word, :incorrect_letters, :lives, :dashes, :word_guessed

  def initialize(word = choose_word, lives = 8, incorrect_letters = [], dashes = '_' * (word.length - 2), word_guessed = false)
    @word = word
    @incorrect_letters = incorrect_letters
    @lives = lives
    @dashes = dashes
    @word_guessed = word_guessed
  end

  def choose_word
    word = ''
    pass = false
    while pass == false
      word = File.readlines('5desk.txt').sample.downcase
      length = word.length
      pass = true unless length < 5 && length > 12
    end
    word
  end

  def print_board
    puts "Incorrect Guesses: #{incorrect_letters} \n"
    puts "Guesses left: #{lives} \n"
    puts "\n #{dashes.split('').join(' ')}"
  end

  def check_guess(letter)
    if word.include?(letter)
      word.each_char.with_index do |char, i|
        dashes[i] = char if char == letter
      end
    else
      incorrect_letters.push(letter.to_s)
      self.lives -= 1
    end
    self.word_guessed = true unless dashes.include?('_')
  end
end
