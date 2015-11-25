require 'rails_helper'

RSpec.feature 'User moves piece', type: :feature do
  scenario 'successfully' do
    game = create(:game)
    visit game_path(game)

    pawn = game.chess_pieces.find_by(position_x: 1, position_y: 2)
    click_link('', href: piece_path(pawn))

    expect(page).to eq piece_path(pawn)
  end
end
