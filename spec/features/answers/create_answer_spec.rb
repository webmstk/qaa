require_relative '../feature_helper'

feature 'create answer to question', %q{
  In order to answer to a question
  As an user
  I want to answer question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:answer) { build(:answer) }

  scenario 'authenticated user creates valid answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '#new_answer' do
      fill_in 'Сообщение', with: answer.body
      click_on 'Ответить'
    end

    expect(current_path).to eq question_path(question)

    within '.answers' do
      expect(page).to have_content answer.body
      expect(page).not_to have_content('На этот вопрос пока нет ответов')
    end

    answer_body = find_field('answer_body').value
    expect(answer_body).to eq ''
  end

  scenario 'authenticated user creates invalid answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '#new_answer' do
      fill_in 'Сообщение', with: ''
      click_on 'Ответить'
    end

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Не удалось сохранить ответ'
    expect(page).not_to have_content answer.body
  end

  scenario 'non-authenticated user tries to create answer', js: true do
    visit question_path(question)
    within '#new_answer' do
      fill_in 'Сообщение', with: answer.body
      click_on 'Ответить'
    end

    expect(page).to have_content 'Только зарегистрированные пользователи могут отвечать'

    visit question_path(question)
    expect(page).not_to have_content answer.body
  end

end
