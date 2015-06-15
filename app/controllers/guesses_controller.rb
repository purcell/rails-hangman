class GuessesController < ApplicationController
  def create
    game = Game.find_by_id!(params[:game_id])
    game.guesses.create!(params.require(:guess).permit(:letter))
    redirect_to game
  end
end
