require 'rails_helper'

feature 'All games are listed on the page' do
  scenario 'successfully' do
    create(:game, name: 'TEST GAME - FEATURE TEST')
    visit root_path
    click_link 'Show me all games'

    expect(page).to have_css('.game')
  end

  scenario 'after clicking an individual game, user is on game page' do
    game = create(:game, name: 'TEST GAME - FEATURE TEST')
    visit root_path
    click_link 'Show me all games'
    click_link('TEST GAME - FEATURE TEST')
    expect(current_path).to eq game_path(game)
  end
end
