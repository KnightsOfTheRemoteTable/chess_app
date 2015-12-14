require 'rails_helper'

feature 'user visits the homepage of the application' do
  scenario 'successfully' do
    visit root_path
    expect(page).to have_css 'h1', text: 'Online Chess'
  end
end
