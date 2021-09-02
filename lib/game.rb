require 'pry-byebug'
require 'json'
require_relative 'hangman'

class Game
  attr_accessor :hangman
  attr_reader :round

  def initialize
    @hangman = Hangman.new
    @round = 0
  end

  def play_game
    while hangman.word_guessed == false && hangman.lives.positive?
      # binding.pry
      load_game if round.zero?
      puts hangman.word
      puts "#{hangman.print_board} \n"
      choice = guess_letter
      if choice == 'save'
        save_game
        return
      end
    end
    win_or_lose
  end

  def win_or_lose
    if hangman.lives.zero?
      puts "You lose. \n"
      puts "The word was #{hangman.word}"
    else
      puts 'You win.'
    end
  end

  def guess_letter
    puts "Please guess a letter from A-Z. Or type 'save' if you would like to continue later.\n"
    guess = gets.chomp.downcase
    while check_validity(guess)
      puts "Invalid guess. Please guess a letter from A to Z, or type 'save' if you'd like to continue later.\n"
      guess = gets.chomp.downcase
    end
    if guess == 'save'
      puts "Game Saved\n"
      return guess
    end

    hangman.check_guess(guess)
  end

  def check_validity(input)
    # unless input.match('save')
    #   unless input.match(/^[a-z]$/)
    #     puts "Invalid guess. Please input a letter from A to Z. \n"
    #     return false
    #   end

    #   if hangman.dashes.include?(input)
    #     puts "Already guessed, please try again with a letter from A to Z. \n"
    #     return false
    #   end

    #   if hangman.incorrect_letters.include?(input)
    #     puts "Already guessed, please try again with a letter from A to Z. \n"
    #     return false
    #   end
    #   puts "Input = #{input}"
    #   puts "Invalid input. Please make a guess or type 'save'. \n"
    #   return false
    # end
    # true
    (!input.match?(/\bsave\b/) && !input.match?(/^[a-z]$/)) ||
      (hangman.dashes.include?(input) || hangman.incorrect_letters.include?(input))
  end

  def save_game
    File.open('save.json', 'w') do |file|
      file.puts(hangman_to_json)
    end
  end

  def hangman_to_json
    JSON.dump({
                word: hangman.word,
                lives: hangman.lives,
                incorrect_letters: hangman.incorrect_letters,
                dashes: hangman.dashes,
                word_guessed: hangman.word_guessed
              })
  end

  def hangman_from_json(file)
    hangman_data = JSON.parse(File.read(file))
    self.hangman = Hangman.new(
      hangman_data['word'],
      hangman_data['lives'],
      hangman_data['incorrect_letters'],
      hangman_data['dashes'],
      hangman_data['word_guessed']
    )
  end

  def load_game
    return unless File.exist?('save.json')

    puts 'Would you like to load a previous game? (Y/N)'
    choice = gets.chomp.downcase
    while choice != 'y' && choice != 'n'
      puts 'Please input Y/N'
      choice = gets.chomp.downcase
    end
    return unless choice == 'y'

    File.open('save.json', 'r') do |file|
      hangman_from_json(file)
    end
    File.delete('save.json')
  end
end


Game.new.play_game
# puts game.word
# puts game.guess_letter
# game.print_board
