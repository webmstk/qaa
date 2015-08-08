require_relative '../feature_helper'

feature 'Delete answer comment', %q{
  In order to delete answer's comment
  As an authenticated user
  I want to delete answer's comment
} do

  let(:user) { create :user }
  let(:another_user) { create :user }
  let(:question) { create :question }
  let(:answer) { create :answer, question: question }
  let!(:comment) { create(:comment, commentable: answer, user: user) }

  scenario 'authenticated user deletes own comment', js: true do
    sign_in(user)
    visit question_path(question)

    within('.answer .comment') do
      click_on('удалить')
    end
    
    expect(page).to_not have_content(comment.body)
  end

  scenario 'authenticated user tries to delete someone\'s comment', js: true do
    sign_in(another_user)
    visit question_path(question)

    within('.answer .comment') do
      expect(page).not_to have_content('удалить')
    end
  end

  scenario 'non-authenticated user tries to delete comment', js: true do
    visit question_path(question)

    within('.answer .comment') do
      expect(page).not_to have_content('удалить')
    end
  end

end