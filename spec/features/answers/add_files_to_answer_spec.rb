require_relative '../feature_helper'
#Capybara.ignore_hidden_elements = true

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an author of answer
  I want to attache files
} do
  
  given(:user) { create :user }
  given(:question) { create(:question) }

  background do
    Capybara.current_driver = :webkit
    sign_in(user)
    visit question_path(question)
  end

  scenario 'user adds answer with attached files', js: true do
    
    within '#new_answer' do
      fill_in 'Сообщение', with: 'answer body'
      click_on 'добавить файл'
      click_on 'добавить файл'

      file_inputs = all('input[type=file]')
      file_inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
      file_inputs[1].set("#{Rails.root}/spec/rails_helper.rb")

      click_button 'Ответить'
    end

    within '.answers' do
      expect(page).to have_text 'answer body'
      #expect(page).to have_link 'spec_helper.rb', href: /\/uploads\/attachment\/file\/\d+\/spec_helper\.rb/
      expect(page).to have_link 'spec_helper.rb'#, href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'#, href: '/uploads/attachment/file/2/rails_helper.rb'
    end

    Capybara.use_default_driver
  end
  
end