require_relative '../feature_helper'

feature 'Delete files from question', %q{
  In order to delete attached file from my question
  As an author of question
  I want to delete files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  scenario 'user removes file from question', js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_link(attachment.file.filename)

    within '.question-files' do
      click_link 'удалить'

      expect(page).not_to have_link(attachment.file.filename)
      # надо ли проверять, что после перезагрузки страницы файла действительно нет?
    end
  end

  scenario 'user tries to remove other user\'s question' do
    sign_in( create :user )
    visit question_path(question)

    within '.question-files' do
      expect(page).not_to have_link 'удалить'
    end
  end

  scenario 'non-authenticated user tries to remove other user\'s question' do
    visit question_path(question)

    within '.question-files' do
      expect(page).not_to have_link 'удалить'
    end
  end

end