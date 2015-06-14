require 'rails_helper'

RSpec.describe Game, type: :model do

  let(:dictionary) { File.read(Rails.root + "config/words.txt").split(/\n/) }

  context "when creating a game" do
    it "chooses a random word" do
      srand(5150)
      g1 = Game.create
      expect(dictionary).to include(g1.word)
      srand(812)
      g2 = Game.create
      expect(dictionary).to include(g2.word)
      expect(g2.word).not_to eql(g1.word)
    end
  end
end
