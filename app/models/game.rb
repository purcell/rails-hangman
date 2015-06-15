class Game < ActiveRecord::Base
  has_many :guesses, dependent: :destroy

  before_validation :choose_a_word, on: :create

  def masked_word_letters
    word.chars.map do |c|
      if c =~ /[a-z]/i && !guessed_letters.include?(c.downcase)
        nil
      else
        c
      end
    end
  end

  def guesses_remaining
    8 - guesses.size
  end

  private

  def guessed_letters
    guesses.map(&:letter).map(&:downcase)
  end

  def choose_a_word
    self.word ||= File.read(Rails.root + "config/words.txt").split(/\n/).sample
  end
end
