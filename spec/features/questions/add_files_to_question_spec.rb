require_relative '../feature_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an author of question
  I want to attache files
} do

  given(:user) { create :user }
  given(:question) { build(:question, user: user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'user adds question with attached files', js: true do
    fill_in 'Заголовок', with: question.title
    fill_in 'Сообщение', with: question.body
    click_on 'добавить файл'
    click_on 'добавить файл'

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")

    click_button 'Задать вопрос'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end

end