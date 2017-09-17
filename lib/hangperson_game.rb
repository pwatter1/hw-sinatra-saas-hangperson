class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_accessor :valid
  attr_accessor :word_with_guesses
  attr_accessor :guess_number
  attr_accessor :check_win_or_lose
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @guess_number = 0
    update_word_after_guess
  end

  # validate and add to guess list
  def guess(letter)
    raise ArgumentError, "Argument is not a valid letter" unless letter =~  /^[a-z]$/i
    @check_win_or_lose = :play
    letter = letter.downcase;
    if (letter =~ /^[a-z]$/i)
      @valid = true
    else
      @valid = false
    end
    
   # check if letter has already been guessed
   return false if (@guesses.include?(letter)) || (@wrong_guesses.include?(letter))
   
   # check if in word, if not, add to wrong, else, add to guesses
   if (@word.include?(letter) && @valid == true)
     @guesses << letter
     update_word_after_guess()
     # check if word finished
     if(@word_with_guesses == @word)
       @check_win_or_lose = :win
     end
   else
     @wrong_guesses << letter
     @guess_number += 1
     if(@guess_number == 7)
       @check_win_or_lose = :lose
     end
   end
   
   return true
  end  

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  def update_word_after_guess
    @word_with_guesses = ''
    @word.each_char do |corrLetter|
      if @guesses.include?(corrLetter)
        @word_with_guesses << corrLetter
      else
        @word_with_guesses << '-'
      end
    end
  end
end
