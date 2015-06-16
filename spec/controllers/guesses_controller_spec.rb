require 'rails_helper'

RSpec.describe GuessesController, type: :controller do
  context "when responding to requests" do
    describe "POST #create" do
      it "stores a valid guess" do
        game = Game.create!
        post :create, game_id: game.id, letter: 'b'
        expect(response).to redirect_to(game_url(game))
        game.reload
        expect(game.guesses.size).to eql(1)
        expect(game.guesses.first.letter).to eql('b')
      end
    end
  end
end
