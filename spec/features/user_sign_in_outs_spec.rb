require 'rails_helper'

feature 'user sign in and out' do
  scenario 'with valid info' do
    user = create(:user)
    sign_in_as(user)
    click_link 'Sign Out'
    expect(page).to have_link('Sign In')
  end
  scenario 'with invalid info' do
    user = build(:user)
    sign_in_as(user)
    expect(page).to have_link('Sign In')
    expect(page).to have_content('Invalid email')
  end
end
