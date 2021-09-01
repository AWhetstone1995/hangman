require 'pry-byebug'
class Game
  attr_accessor :word, :correct_letters, :incorrect_letters, :incorrect_guesses

  MAX_GUESSES = 8

  def initialize
    @word = choose_word
    @correct_letters = []
    @incorrect_letters = []
    @incorrect_guesses = 0
  end

  def choose_word
    word = ''
    pass = false
    while pass == false
      word = File.readlines('5desk.txt').sample
      length = word.length
      pass = true unless length < 5 && length > 12
    end
    word
  end

  def guess_letter
    guess = ''
    pass = false
    puts 'Please make a guess.'
    while pass == false
      guess = gets.chomp
      pass = true unless guess.length > 1 || Integer(guess)
      if pass == false then puts 'Invalid guess. Try again.' end
    end
    check_guess(guess)
  end

  def check_guess(letter)
    if word.include?(letter)
      correct_letters.push(letter)
    else
      incorrect_letters.push(letter)
      self.incorrect_guesses += 1
    end
    puts "Incorrect guesses: #{incorrect_guesses}"
    puts "Correct letters: #{correct_letters}"
    puts "Incorrect letters: #{incorrect_letters}"
  end
end


game = Game.new
puts game.word
puts game.guess_letter
