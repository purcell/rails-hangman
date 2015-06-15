require 'rails_helper'

RSpec.describe Game, type: :model do

  let(:dictionary) { File.read(Rails.root + "config/words.txt").split(/\n/) }

  context "when creating a game" do
    it "allows a word to be specified" do
      g = Game.create!(word: "hello")
      expect(g.word).to eql("hello")
    end

    it "chooses a random word" do
      srand(5150)
      g1 = Game.create!
      expect(dictionary).to include(g1.word)

      srand(812)
      g2 = Game.create!
      expect(dictionary).to include(g2.word)

      expect(g2.word).not_to eql(g1.word)
    end

    it "reports how many guesses remain" do
      expect(Game.create!.guesses_remaining).to eql(8)
    end
  end

  context "when no guesses have been made" do
    it "provides a masked version of the word's letters" do
      expect(Game.create!(word: "mad props").masked_word_letters).to eql([nil, nil, nil, " ", nil, nil, nil, nil, nil])
      expect(Game.create!(word: "it's good").masked_word_letters).to eql([nil, nil, "'", nil, " ", nil, nil, nil, nil])
    end

    it "allows a wrong guess to be added" do
      g = Game.create!(word: "abc")
      g.guesses.create!(letter: 'd')
      expect(g.guesses_remaining).to eql(7)
    end

    it "allows a correct guess to be added" do
      g = Game.create!(word: "abc")
      g.guesses.create!(letter: 'c')
      expect(g.guesses_remaining).to eql(7)
      expect(g.masked_word_letters).to eql([nil, nil, 'c'])
    end

    it "allows a correct guess whne the case differs" do
      g = Game.create!(word: "ABC")
      g.guesses.create!(letter: 'c')
      expect(g.masked_word_letters).to eql([nil, nil, 'C'])

      g = Game.create!(word: "abc")
      g.guesses.create!(letter: 'C')
      expect(g.masked_word_letters).to eql([nil, nil, 'c'])
    end
  end
end
