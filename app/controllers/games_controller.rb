class GamesController < ApplicationController
  def index
  end

  def create
    redirect_to(Game.create!)
  end

  def show
    @game = Game.find_by_id!(params[:id])
  end
end
