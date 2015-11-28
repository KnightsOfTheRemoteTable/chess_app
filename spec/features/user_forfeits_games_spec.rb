require 'rails_helper'

feature 'UserForfeitsGames', type: :feature do
  scenario 'successfully' do
    user = create(:user)
    game = create(:game, black_player: user)

    sign_in_as(user)
    visit game_path(game)
    click_link('Forfeit Game')

    expect(page).to have_content 'You have forfeited the game'
  end

  scenario 'not signed in' do
    user = create(:user)
    game = create(:game, black_player: user)

    visit game_path(game)
    expect(page).to_not have_link 'Forfeit Game'
  end
end
