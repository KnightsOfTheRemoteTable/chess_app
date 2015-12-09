require 'rails_helper'

feature 'User joins an existing game' do
  scenario 'successfully' do
    black_player = create(:user)
    white_player = create(:user)
    game = create(:game, black_player: black_player)

    sign_in_as(white_player)
    visit games_path
    click_link 'Join'
  end
end
