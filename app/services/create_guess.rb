class CreateGuess
  def initialize(game, letter)
    @game = game
    @letter = letter
  end

  def call
    @game.with_lock do
      @game.lives_remaining > 0 && @game.guesses.build(letter: @letter).save
    end
  end
end
