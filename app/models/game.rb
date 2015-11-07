# Chess game model
class Game < ActiveRecord::Base
  belongs_to :white_player, class_name: 'User'
  belongs_to :black_player, class_name: 'User'
  has_many :chess_pieces

  validates :name, presence: true
end
