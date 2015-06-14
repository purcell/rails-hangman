class Game < ActiveRecord::Base
  before_create :choose_a_word

  private

  def choose_a_word
    self.word = "whatever"
  end
end
