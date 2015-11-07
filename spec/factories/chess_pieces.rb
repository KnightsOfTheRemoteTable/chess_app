FactoryGirl.define do
  factory :chess_piece do
    piece_name 'King'
    position_x 1
    position_y 1
    color 1
    game
  end
end
