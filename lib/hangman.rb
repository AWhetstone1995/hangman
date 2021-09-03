# Controls display, game data and letter checking of user input

class Hangman
  attr_accessor :word, :incorrect_letters, :lives, :dashes, :word_guessed

  def initialize(word = choose_word, lives = 8, incorrect_letters = [], dashes = '_' * word.length, word_guessed = false)
    @word = word # word that player must guess
    @incorrect_letters = incorrect_letters # incorrect letters that play has guessed
    @lives = lives # number of guesses player has left
    @dashes = dashes # empty dashes to show the length of word
    @word_guessed = word_guessed
  end

  def choose_word
    word = ''
    pass = false
    while pass == false
      word = File.readlines('5desk.txt').sample.downcase.delete_suffix("\r\n")
      length = word.length
      pass = true unless length < 5 && length > 12;
    end
    word
  end

  def print_board
    puts "\n"
    if word_guessed
      puts 'Final word:'
      puts dashes
      return
    end
    puts "Incorrect Guesses: #{incorrect_letters} \n"
    puts "Guesses left: #{lives} \n"
    puts "\n #{dashes.split('').join(' ')}"
  end

  def check_guess(letter)
    # if full word guess is correct, fill dashes array with word
    if word.match(/^#{letter}$/)
      word.each_char.with_index do |char, i|
        dashes[i] = char
      end
    # fill dashes array with correct guesses in correct spot
    elsif word.include?(letter)
      word.each_char.with_index do |char, i|
        dashes[i] = char if char == letter
      end
    else
      puts "Sorry, the word does not contain that letter. Try again. \n"
      incorrect_letters.push(letter)
      self.lives -= 1
    end
    self.word_guessed = true unless dashes.include?('_')
  end
end
