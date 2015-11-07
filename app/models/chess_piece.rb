# Chess piece model
class ChessPiece < ActiveRecord::Base
  belongs_to :player, class_name: 'User'
  belongs_to :game

  validates :piece_name,
            :position_x,
            :position_y,
            :color,
            presence: true
  enum color: [:black, :white]
end
