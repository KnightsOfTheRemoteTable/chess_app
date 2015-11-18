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
end
