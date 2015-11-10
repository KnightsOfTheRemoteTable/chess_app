# Change piece_name to type to match Rails convention
class RenamePieceNameToTypeOnChessPieces < ActiveRecord::Migration
  def change
    rename_column :chess_pieces, :piece_name, :type
  end
end
