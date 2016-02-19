require 'rails_helper'

feature 'users' do

  background do
    login_as_manager
  end

  scenario 'Creating a level 3 user from scratch' do
    visit management_document_verifications_path
    fill_in 'document_verification_document_number', with: '1234'
    click_button 'Check'

    expect(page).to have_content "Please introduce the email used on the account"

    click_link 'Create a new account'

    fill_in 'user_username', with: 'pepe'
    fill_in 'user_email', with: 'pepe@gmail.com'

    click_button 'Create user'

    expect(page).to have_content "We have sent an email"

    user = User.find_by_email('pepe@gmail.com')

    expect(user).to be_level_three_verified
    expect(user).to be_residence_verified
    expect(user).to_not be_confirmed

    sent_token = /.*confirmation_token=(.*)".*/.match(ActionMailer::Base.deliveries.last.body.to_s)[1]
    visit user_confirmation_path(confirmation_token: sent_token)

    expect(page).to have_content "Confirming the account with email"

    fill_in 'user_password', with: '12345678'
    fill_in 'user_password_confirmation', with: '12345678'

    click_button 'Confirm'

    expect(user.reload).to be_confirmed

    expect(page).to have_content "Your account has been confirmed."
  end

  scenario 'Delete an account' do
    user = create(:user, :level_two)

    visit management_document_verifications_path
    fill_in 'document_verification_document_number', with: user.document_number
    click_button 'Check'
    expect(page).to have_content "Identified as: Username: #{user.username}"

    click_link 'Delete account'
    fill_in 'user_erase_reason', with: 'I am not living in the city anymore'
    click_button 'Delete account'

    expect(page).to have_content "The user account has been deleted"

    visit management_document_verifications_path
    fill_in 'document_verification_document_number', with: user.document_number
    click_button 'Check'

    expect(page).to_not have_content "Identified as: Username: #{user.username}"
    expect(page).to have_content "This document was found in the census, but it has no user account associated to it."
  end

end