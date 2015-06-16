module GamesHelper
  def new_game_button
    button_to "New game", games_url, method: :post, class: 'btn btn-primary'
  end
end
