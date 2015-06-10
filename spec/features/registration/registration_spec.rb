require 'rails_helper'

feature 'User registers', %q{
  In order to be able to ask question
  As an User
  I want to register
} do

  given(:user) { create(:user) }

  scenario 'Unregistered user tries to register with valid attributes' do
    visit new_user_session_path
    click_on 'Зарегистрироваться'
    fill_in 'Email', with: 'test@mail.ru'
    fill_in 'Пароль', with: '12345678'
    fill_in 'Подтверждение пароля', with: '12345678'
    click_on 'Зарегистрироваться'
    
    expect(page).to have_content 'Добро пожаловать! Вы успешно
                                  зарегистрировались.'
    expect(current_path).to eq root_path
  end

  scenario 'Unregistered user tries to register with invalid attributes' do
    visit new_user_session_path
    click_on 'Зарегистрироваться'
    fill_in 'Email', with: 'test@mail'
    fill_in 'Пароль', with: '111'
    fill_in 'Подтверждение пароля', with: '222'
    click_on 'Зарегистрироваться'
    
    expect(page).to have_content 'сохранение не удалось'
    expect(current_path).to eq user_registration_path
  end
  
  scenario 'Unregistered user tries to register with blank attributes' do
    visit new_user_session_path
    click_on 'Зарегистрироваться'
    fill_in 'Email', with: ''
    fill_in 'Пароль', with: ''
    fill_in 'Подтверждение пароля', with: ''
    click_on 'Зарегистрироваться'
    
    expect(page).to have_content 'сохранение не удалось'
    expect(current_path).to eq user_registration_path
  end
  
  scenario 'Registered user tries to register' do
    sign_in(user)
    visit new_user_session_path
    
    expect(page).to have_content 'Вы уже вошли в систему.'
    expect(current_path).to eq root_path
  end

end
