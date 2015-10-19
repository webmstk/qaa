require_relative '../feature_helper'

feature 'User signs in', %q{
  In order to be able to ask question
  As an User
  I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user tries to sign in' do
    sign_in(user)

    expect(page).to have_content 'Вход в систему выполнен.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user tries to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'invalid_user@test.ru'
    fill_in 'Пароль', with: '12345678'
    click_on 'Войти'

    expect(page).to have_content 'Неверный email или пароль.'
    expect(current_path).to eq new_user_session_path
  end

end


feature 'User signs out', %q{
  In order to be able to sign out
  As an User
  I want to sign out
} do

  given(:user) { create(:user) }

  scenario 'Registered user tries to sign out' do
    sign_in(user)
    click_on 'Выйти'
    
    expect(page).to have_content 'Выход из системы выполнен.'
    expect(current_path).to eq root_path
  end

end
