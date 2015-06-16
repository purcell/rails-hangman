class GuessesController < ApplicationController
  def create
    game = Game.find_by_id!(params[:game_id])
    CreateGuess.new(game, params.require(:letter)).call
    redirect_to game
  end
end
