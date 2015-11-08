# Create chess_pieces table
class CreateChessPieces < ActiveRecord::Migration
  def change
    create_table :chess_pieces do |t|
      t.string :piece_name
      t.integer :position_x
      t.integer :position_y
      t.integer :color
      t.belongs_to :game, index: true
      t.belongs_to :player, index: true

      t.timestamps
    end
  end
end
