require 'set'

class WordGuesserGame
  attr_reader :word, :guesses, :wrong_guesses
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @indices_guesses_hash = Hash.new
  end

  def guesses_hash letter
    indices = Set.new
    @word.each_char.with_index do |char, i|
      indices << i if char == letter
    end
    @indices_guesses_hash[letter] = indices
  end


  def guess letter
    unless !letter.nil? && !letter.empty? && letter.scan(/[^A-Za-z]/).empty?
      raise ArgumentError, 'Guess must be a letter.'
    end
    letter = letter.downcase

    if @guesses.include?(letter) or @wrong_guesses.include?(letter)
      return false
    end

    unless @word.include?(letter)
      @wrong_guesses = letter
      return 'Letter not in word. Try again.'
    end
    @guesses = @guesses + letter
    self.guesses_hash letter
  end


  def word_with_guesses
    display_string = '-' * @word.length
    @indices_guesses_hash.each do |letter, index_set |
      index_set.each do |i|
        display_string[i] = letter
      end
    end
    display_string
  end


  # Get a word from remote "random word" service


  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end




glorp = WordGuesserGame.new('glorp')
puts glorp.word


game = WordGuesserGame.new('banana')
valid = game.guess('a')
guess = game.guesses
wrong_guess = game.wrong_guesses
# test = game.guess(nil)   ## this should error if working properly
game.guess('b')
game.guess('y')
game.word_with_guesses
1