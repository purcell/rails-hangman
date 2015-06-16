module GamesHelper
  def new_game_button
    button_to "New game", games_url, method: :post, class: 'btn btn-primary'
  end

  def create_guess_button(game, letter, html_options={})
    default_opts = {method: :post, disabled: game.already_guessed?(letter), data: {'disable-with' => letter}}
    button_to(letter, game_guesses_url(game, letter: letter), html_options.merge(default_opts))
  end
end
