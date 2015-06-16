require 'rails_helper'

RSpec.describe CreateGuess, type: :service do
  context "when the game is new" do
    it "allows a guess" do
      game = Game.create!(word: "abcd")
      service = CreateGuess.new(game, 'a')
      expect(service.call).to eql(true)
      expect(game.already_guessed?('a')).to eql(true)
    end

    it "disallows duplicate guesses" do
      game = Game.create!(word: "abcd")
      expect(CreateGuess.new(game, 'a').call).to eql(true)
      expect(CreateGuess.new(game, 'a').call).to eql(false)
    end

  end
  
  context "when the game is new" do
    let(:lost_game) do
      Game.create!(word: "abcd").tap do |game|
        ('e'..'z').first(game.initial_lives).map do |wrong|
          game.guesses.create!(letter: wrong)
        end
      end
    end

    it "prevents correct guesses once the game is over" do
      expect(CreateGuess.new(lost_game, 'a').call).to eql(false)
    end

    it "prevents wrong guesses once the game is over" do
      expect(CreateGuess.new(lost_game, 'z').call).to eql(false)
    end
  end
end
