# Chess game model
class Game < ActiveRecord::Base
  belongs_to :white_player, class_name: 'User'
  belongs_to :black_player, class_name: 'User'
  has_many :chess_pieces

  validates :name, presence: true

  after_create :populate_board!

  def populate_board!
    chess_pieces.create(type: 'King', position_x: 4, position_y: 0, color: :black)
  end
end
