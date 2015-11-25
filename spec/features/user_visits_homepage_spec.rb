require 'rails_helper'

feature 'user visits the homepage of the application' do
  scenario 'successfully' do
    visit root_path
    expect(page).to have_css 'h1', text: 'best chess game ever'
  end

  scenario 'all games listed on homepage' do
    FactoryGirl.create(:game)
    visit root_path
    expect(page).to have_css('.game')
  end

  scenario 'new games appear on homepage' do
    create(:game, name: 'fancy test game')
    visit root_path
    expect(page).to have_link('fancy test game')
  end

  scenario 'after clicking game, user is on game page' do
    game = create(:game, name: 'click me test game')
    visit root_path
    click_link('click me test game')
    expect(current_path).to eq game_path(game.id)
  end
end
