require 'rails_helper'

feature 'Read questions', %q{
  In order to read questions
  As an any-role user
  I want to see list of all questions
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 2) }

  scenario 'Authenticated user can read questions' do
    sign_in(user)
    visit questions_path
    
    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
  
  scenario 'Non-authenticated user can read questions' do
    visit questions_path
    
    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end

end
