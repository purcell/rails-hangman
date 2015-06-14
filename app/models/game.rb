class Game < ActiveRecord::Base
  before_create :choose_a_word

  def masked_word_letters
    word.chars.map do |c|
      case c
      when /[a-z]/i then nil
      else c
      end
    end
  end

  private

  def choose_a_word
    self.word ||= File.read(Rails.root + "config/words.txt").split(/\n/).sample
  end
end
