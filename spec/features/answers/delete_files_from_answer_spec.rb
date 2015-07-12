require_relative '../feature_helper'

feature 'Delete files from answer', %q{
  In order to delete attached file from my answer
  As an author of answer
  I want to delete files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  scenario 'user removes file from answer', js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_link(attachment.file.filename)

    within '.answer-files' do
      click_link 'удалить'

      expect(page).not_to have_link(attachment.file.filename)
    end
  end

  scenario 'user tries to remove other user\'s question' do
    sign_in( create :user )
    visit question_path(question)

    within '.answer-files' do
      expect(page).not_to have_link 'удалить'
    end
  end

  scenario 'non-authenticated user tries to remove other user\'s question' do
    visit question_path(question)

    within '.answer-files' do
      expect(page).not_to have_link 'удалить'
    end
  end

end