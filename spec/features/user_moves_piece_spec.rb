require 'rails_helper'

RSpec.feature 'User moves piece', type: :feature do
  scenario 'successfully' do
    user = create(:user)
    game = create(:game, black_player: user)
    sign_in_as(user)
    visit game_path(game)

    pawn = game.chess_pieces.find_by(position_x: 1, position_y: 2)
    click_link('', href: piece_path(pawn))

    expect(current_path).to eq piece_path(pawn)

    click_link('', href: piece_path(id: pawn, piece: { position_x: 1, position_y: 3 }))

    expect(pawn.reload.position_y).to eq 3
  end
end
