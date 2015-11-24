require 'rails_helper'

RSpec.feature 'UserVisitsGamepages', type: :feature do
  scenario 'successfully' do
    game = create(:game)
    visit game_path(game)

    within('.chessboard') { expect(page).to have_css 'img', count: 32 }
  end

  scenario 'has links for all chess pieces' do
    game = create(:game)
    visit game_path(game)
      game.chess_pieces.each do |piece|
        expect(page).to have_link("", href: piece_path(piece))
    end
  end
end
