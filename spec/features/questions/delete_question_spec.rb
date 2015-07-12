require_relative '../feature_helper'

feature 'delete question', %q{
  In order to delete question
  As an author
  I want to delete question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:another_user_question) { create(:question, user: another_user) }


  scenario 'authenticated user deletes his own question (question_path)' do
    sign_in(user)
    visit question_path(question)

    within '.question .controls' do
      click_on 'удалить'
    end

    expect(current_path).to eq questions_path
    expect(page).not_to have_content question.title
    expect(page).not_to have_content question.body
  end


  scenario 'authenticated user deletes his own question (questions_path)' do
    sign_in(user)

    visit questions_path
    click_link "del_question_#{question.id}"

    expect(current_path).to eq questions_path
    expect(page).not_to have_content question.title
    expect(page).not_to have_content question.body
  end


  scenario 'non-authenticated user tries to delete question (question_path)' do
    visit question_path(question)

    expect(page).not_to have_content 'Удалить вопрос'
  end


  scenario 'non-authenticated user tries to delete question (questions_path)' do
    visit questions_path

    expect(page).not_to have_content 'удалить вопрос'
  end


  scenario 'authenticated user tries to delete somebody\'s question
            (question_path)' do
    sign_in(user)
    visit question_path(another_user_question)

    expect(page).not_to have_content 'Удалить вопрос'
  end


  scenario 'authenticated user tries to delete somebody\'s question
            (questions_path)' do
    sign_in(user)
    visit questions_path

    expect(page).to have_selector("#del_question_#{question.id}")
    expect(page).not_to \
                 have_selector("#del_question_#{another_user_question.id}")
  end


end
