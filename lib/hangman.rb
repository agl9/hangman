# frozen_string_literal: true

# class for Hangman gameplay
class Hangman
  attr_reader :blank
  def initialize(name, max)
    @name = name
    @word = set_word.downcase.split('')
    @blank = Array.new(@word.length, '_')
    @reject = Array.new(0)
    @count = 0
    @maxcount = max
    @guess = ''
    @break = 0
  end

  def play
    while @count <= @maxcount - 1
      puts 'Enter your Guess'
      guess_input
      guess_check
      win_check
      status
    end
    puts "You lose #{@name}. The word was #{@word.join('')}" if @count >= @maxcount
  end

  def guess_input
    loop do
      @guess = gets.chomp.to_s.downcase
      save_game if @guess == '%'

      if @guess.length > 1 || @guess.match(/[^a-z]/)
        puts 'Enter only 1 alphabet'
      elsif @reject.include?(@guess) || @blank.include?(@guess)
        puts 'You have already guessed this letter'
      else break
      end
    end
  end

  def guess_check
    if @word.include?(@guess)
      @word.each_with_index do |w, i|
        @blank[i] = @guess if w == @guess
      end
    else
      @reject.push(@guess)
      @count += 1
    end
  end

  def win_check
    return unless @blank == @word

    puts "You win #{@name}. The word is: #{@blank.join('')}"
    exit
  end

  def status
    puts "Your word status: #{@blank}"
    puts "Rejected letters: #{@reject.join(',')}"
    puts "#{@count} of #{@maxcount} incorrect guesses done"
  end

  def save_game
    Dir.mkdir('saved_games') unless Dir.exist? 'saved_games'
    loop do
      puts 'Enter file name to be saved'
      @file = gets.chomp.to_s.downcase
      break unless File.exist? "saved_games/#{@file}.txt"

      puts 'File already exists. try another name'
    end
    create_file
    exit
  end

  def create_file
    file_name = "saved_games/#{@file}.txt"
    File.open(file_name, 'w') do |file|
      file.puts @name.to_s
      file.puts @word.join('')
      file.puts @blank.join('')
      file.puts @reject.join('')
      file.puts @count.to_s
      file.puts @maxcount.to_s
    end
  end

  def load_game(file_name)
    return true unless File.exist? "saved_games/#{file_name}.txt"

    file = File.open("saved_games/#{file_name}.txt")
    line = file.readlines.map(&:chomp)
    load_file(line)
  end

  def load_file(line)
    @name = line[0]
    @word = line[1].split('')
    @blank = line[2].split('')
    @reject = line[3].split('')
    @count = line[4].to_i
    @maxcount = line[5].to_i
    status
    play
  end

  private

  def set_word
    wordlist = File.read('wordlist.txt').split
    wordlist[rand(wordlist.length)]
  end
end
