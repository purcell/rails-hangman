class Game < ActiveRecord::Base
  before_create :choose_a_word

  private

  def choose_a_word
    self.word = File.read(Rails.root + "config/words.txt").split(/\n/).sample
  end
end
