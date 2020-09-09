# frozen_string_literal: true

# class to take in details from users and run the program
class Main
  require_relative 'hangman2.rb'
  def initialize
    puts "Press '%' if you want to load a previously saved game. Any other key if you want to play a fresh game"
    if gets.chomp == '%'
      loop do
        player = Hangman.new('', 0)
        puts 'Enter the filename'
        break unless player.load_game(gets.chomp.to_s.downcase)

        puts 'No such file'
      end
    else new_game
    end
  end

  def new_game
    puts 'Welcome to Hangman! Enter your name'
    name = gets.chomp.to_s
    puts 'How many incorrect guesses are allowed?'
    max = gets.chomp.to_i
    puts "Guess the word within #{max} incorrect guesses. Press '%' to save game for later."
    player = Hangman.new(name, max)
    p player.blank
    player.play
  end
end

Main.new
