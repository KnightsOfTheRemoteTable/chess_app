class AddWinnerColumnToGames < ActiveRecord::Migration
  def change
    add_reference :games, :winner, index: true
    add_foreign_key :games, :users, column: 'winner_id'
  end
end
