require 'rails_helper'

feature 'user signs up' do
  scenario 'with valid info' do
    visit root_path
    click_link 'Sign Up'
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'supersecret', match: :prefer_exact
    fill_in 'Password confirmation', with: 'supersecret'
    click_button 'Sign up'

    expect(page).to_not have_link 'Sign Up'
    expect(page).to have_link 'Sign Out'
  end

  scenario 'with invalid info' do
    visit root_path
    click_link 'Sign Up'
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'supersecret', match: :prefer_exact
    fill_in 'Password confirmation', with: 'differentpassword'
    click_button 'Sign up'

    expect(page).to have_link 'Sign Up'
    expect(page).to_not have_link 'Sign Out'
  end
end
