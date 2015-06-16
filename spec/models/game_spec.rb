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
      g = Game.create!
      expect(g.lives_remaining).to be > 3
      expect(g.initial_lives).to eql(g.lives_remaining)
    end
  end

  def masked_letters(game)
    game.letters.map { |l| l.char unless l.guessable? }
  end

  context "when no guesses have been made" do
    it "doesn't report that the game is done" do
      game = Game.create!(word: 'abc')
      expect(game.won?).to eql(false)
      expect(game.lost?).to eql(false)
    end

    it "provides a masked version of the word's letters" do
      expect(masked_letters(Game.create!(word: "mad props"))).to eql([nil, nil, nil, " ", nil, nil, nil, nil, nil])
      expect(masked_letters(Game.create!(word: "it's good"))).to eql([nil, nil, "'", nil, " ", nil, nil, nil, nil])
    end

    it "allows a wrong guess to be added" do
      g = Game.create!(word: "abc")
      g.guesses.create!(letter: 'd')
      expect(g.lives_remaining).to eql(g.initial_lives - 1)
    end

    it "allows a correct guess to be added" do
      g = Game.create!(word: "abc")
      g.guesses.create!(letter: 'c')
      expect(g.lives_remaining).to eql(g.initial_lives)
      expect(masked_letters(g)).to eql([nil, nil, 'c'])
      expect(g.letters[2].guessed).to eql(true)
    end

    it "allows a correct guess whne the case differs" do
      g = Game.create!(word: "ABC")
      g.guesses.create!(letter: 'c')
      expect(masked_letters(g)).to eql([nil, nil, 'C'])

      g = Game.create!(word: "abc")
      g.guesses.create!(letter: 'C')
      expect(masked_letters(g)).to eql([nil, nil, 'c'])
    end

    it "can tell whether a letter has already been guessed" do
      g = Game.create!(word: "abc")
      expect(g.already_guessed?('c')).to eql(false)
      expect(g.letters[2].guessed).to eql(false)
      g.guesses.create!(letter: 'c')
      expect(g.already_guessed?('c')).to eql(true)
      expect(g.letters[2].guessed).to eql(true)
    end
  end

  context "when all lives have been lost" do
    it "reports that the game is lost" do
      g = Game.create!(word: 'abc')
      ('d'..'z').first(g.lives_remaining).each do |letter|
        g.guesses.create!(letter: letter)
      end
      expect(g.lost?).to eql(true)
      expect(g.won?).to eql(false)
    end
  end

  context "when all letters have been guessed" do
    it "reports that the game is won" do
      g = Game.create!(word: 'abc')
      'abc'.chars.each do |letter|
        g.guesses.create!(letter: letter)
      end
      expect(g.lost?).to eql(false)
      expect(g.won?).to eql(true)
    end
  end
end
