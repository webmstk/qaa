require_relative '../feature_helper'

feature 'Delete answer', %q{
  In order to delete answer
  As an user
  I want to delete answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:another_user) { create(:user) }
  given(:another_user_answer) { create(:answer, question: question, user: another_user) }

  scenario 'authenticated user deletes own answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_link "del_answer_#{answer.id}"

    expect(current_path).to eq question_path(question)
    expect(page).not_to have_content answer.body
    expect(page).to have_content('На этот вопрос пока нет ответов')
  end

  scenario 'authenticated user tries to delete somebody\'s answer' do
    sign_in(user)
    visit question_path(question)

    expect(page).not_to have_selector("#del_answer_#{another_user_answer.id}")
  end

  scenario 'non-authenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).not_to have_content('удалить')
  end

end
