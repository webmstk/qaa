require_relative '../feature_helper'
require 'capybara/email/rspec'

feature 'User logs in with provider', %{
  In order to be able to ask a question
  I want to log in with provider
  As a authenticated user
} do
  
  before { OmniAuth.config.test_mode = true }

  describe 'facebook' do
    before { OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({ provider: 'facebook',
                                                                             uid: '123456',
                                                                             info: { email: 'test@mail.ru' } }) }

    scenario 'user logs in' do
      visit new_user_session_path
      click_on 'Авторизоваться через Facebook'
      
      expect(page).to have_content('Вход в систему выполнен с учётной записью из Facebook.')
      expect(current_path).to eq root_path
    end
  end


  describe 'twitter' do
    before { OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({ provider: 'twitter',
                                                                            uid: '123456',
                                                                            info: { email: nil } }) }

    scenario 'user logs in' do
      clear_emails
      visit new_user_session_path
      click_on 'Авторизоваться через Twitter'

      expect(current_path).to eq '/users/email'
      expect(page).to have_content('Требуется email')

      fill_in 'Email', with: 'test@mail.ru'
      click_on 'Отправить'

      expect(current_path).to eq '/users/email'
      expect(page).to have_content('На ваше письмо была отправлена ссылка с подтверждением аккаунта.')

      open_email('test@mail.ru')
      current_email.click_link ''

      expect(current_path).to eq root_path
      expect(page).to have_content('Вход в систему выполнен с учётной записью из Twitter.')
      # expect(page).to have_content('Вход в систему выполнен с учётной записью из Twitter.')
      # translation missing: ru.devise.sessions.user.success

    end
  end

end