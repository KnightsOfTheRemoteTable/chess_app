require 'rails_helper'

feature 'User joins an existing game' do
  scenario 'successfully' do
    black_player = create(:user)
    white_player = create(:user)
    create(:game, black_player: black_player, white_player: nil)

    sign_in_as(white_player)
    visit games_path
    click_link 'Join'
    expect(page).to have_content('You are the white player.')
  end
end
