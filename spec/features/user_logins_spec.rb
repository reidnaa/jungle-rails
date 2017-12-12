require 'rails_helper'

RSpec.feature "User can login", type: :feature, js: true do

  # SETUP
  before :each do
  @user = User.create!(
    name: 'bob',
    email: 'email@email.com',
    password: '12345678',
    password_confirmation: '12345678'
    )
  end


  scenario "A user can fill out the login form and login" do
    # ACT
    visit '/login'

    within 'form' do
      fill_in id:'email', with: @user.email
      fill_in id: 'password', with: @user.password

      click_button 'Submit'
    end
    # DEBUG / VERIFY

    expect(page).to have_content 'Products'
    save_screenshot

  end
end