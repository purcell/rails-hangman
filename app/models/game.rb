class Game < ActiveRecord::Base
  has_many :guesses, dependent: :destroy

  before_validation :choose_a_word, on: :create

  def masked_word_letters
    word.chars.map do |c|
      if c =~ /[a-z]/i && !already_guessed?(c)
        nil
      else
        c
      end
    end
  end

  def initial_lives
    8
  end

  def lives_remaining
    initial_lives - wrong_guesses.size
  end

  def already_guessed?(letter)
    guessed_letters.include?(letter.downcase)
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
