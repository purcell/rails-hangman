class CreateGuesses < ActiveRecord::Migration
  def change
    create_table :guesses do |t|
      t.references :game, null: false
      t.string :letter, limit: 1, null: false
      t.timestamps null: false
    end
  end
end
