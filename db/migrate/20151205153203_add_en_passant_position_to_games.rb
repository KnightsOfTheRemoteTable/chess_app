class AddEnPassantPositionToGames < ActiveRecord::Migration
  def change
    add_column :games, :en_passant_position, :string
  end
end
