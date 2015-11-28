require 'rails_helper'

feature 'UserForfeitsGames', type: :feature do
  scenario 'successfully' do
    user = create(:user)
    game = create(:game, black_player: user)

    visit game_path(game)
    click_link('Forfeit Game')

    expect(page).to have_content 'You have forfeited the game'
  end
end
