class Game < ActiveRecord::Base
  has_many :guesses, dependent: :destroy

  before_validation :choose_a_word, on: :create

  Letter = Struct.new(:char, :"guessed", :"guessable?") do
    def to_s
      char
    end
  end

  def letters
    word.chars.map do |c|
      guessed = already_guessed?(c)
      guessable = (c =~ /[a-z]/i && !already_guessed?(c))
      Letter.new(c, guessed, guessable)
    end
  end

  def initial_lives
    4
  end

  def lives_remaining
    initial_lives - wrong_guesses.size
  end

  def already_guessed?(letter)
    guessed_letters.include?(letter.downcase)
  end

  def lost?
    lives_remaining <= 0
  end

  def won?
    letters.select(&:guessable?).empty?
  end

  private

  def wrong_guesses
    guessed_letters.select { |letter| !word.downcase.include?(letter.downcase) }
  end

  def guessed_letters
    guesses.map(&:letter).map(&:downcase)
  end

  def choose_a_word
    self.word ||= File.read(Rails.root + "config/words.txt").split(/\n/).sample
  end
end
