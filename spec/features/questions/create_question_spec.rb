require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }
  given(:question) { build(:question) }

  scenario 'Authenticated user creates valid question' do
    sign_in(user)

    visit questions_path
    click_on 'Задать вопрос'
    fill_in 'Заголовок', with: question.title
    fill_in 'Сообщение', with: question.body
    click_button 'Задать вопрос'

    expect(current_path).to eq question_path(Question.last)
    expect(page).to have_content 'Ваш вопрос успешно создан.'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'Authenticated user creates invalid question' do
    sign_in(user)

    visit questions_path
    click_on 'Задать вопрос'
    fill_in 'Заголовок', with: '123'
    fill_in 'Сообщение', with: ''
    click_button 'Задать вопрос'

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Не удалось сохранить вопрос'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Задать вопрос'

    expect(page).to have_content 'Вам необходимо войти в систему
                                  или зарегистрироваться'
  end
end
