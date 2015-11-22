require 'rails_helper'

RSpec.feature 'UserVisitsGamepages', type: :feature do
  scenario 'successfully' do
    game = create(:game)
    visit game_path(game)

    within('.chessboard') { expect(page).to have_css 'img', count: 32 }
  end
end
