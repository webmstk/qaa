require 'rails_helper'

feature 'Read question and answers to it' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer1) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question) }

  scenario 'authenticated user visits question page' do
    sign_in(user)
    visit question_path(question)
    
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer1.body
    expect(page).to have_content answer2.body
  end
  
  scenario 'non-authenticated user visits question page' do
    visit question_path(question)
    
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer1.body
    expect(page).to have_content answer2.body
  end

end
