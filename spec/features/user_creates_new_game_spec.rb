require 'rails_helper'

feature 'User creates a new game' do
  scenario 'successfully' do
    user = create(:user)
    create(:game, black_player: user)

    sign_in_as(user)
    visit root_path
    click_link 'Show me all games'
    click_link 'Create a new game'
    fill_in 'Name', with: 'TEST GAME - FEATURE TEST'
    click_on 'Create a new game'

    expect(page).to have_content('TEST GAME - FEATURE TEST')
  end
end
