class AddCurrentPlayerToGame < ActiveRecord::Migration
  def change
    add_column :games, :current_player, :integer
  end
end
