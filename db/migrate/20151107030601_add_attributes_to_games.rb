# Add foreign keys for players to games table
class AddAttributesToGames < ActiveRecord::Migration
  def change
    add_reference :games, :white_player, index: true
    add_reference :games, :black_player, index: true
  end
end
