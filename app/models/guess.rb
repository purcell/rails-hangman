class Guess < ActiveRecord::Base
  validates :letter, uniqueness: {scope: :game_id}
end
