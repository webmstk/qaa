require_relative '../feature_helper'

feature 'Add comment to question', %q{
  In order to create comment to question
  As an authenticated user
  I want to comment question
} do
  
  let(:user) { create :user }
  let(:question) { create :question }

  scenario 'authenticated user adds valid comment to question', js: true do
    sign_in(user)
    visit question_path(question)

    within('.question') do
      click_on 'комментировать'
      fill_in 'Комментарий', with: 'Комментарий к вопросу'
      click_on 'сохранить'
      
      expect(page).not_to have_css('.new_comment');
      expect(page).to have_content('Комментарий к вопросу')
    end
  end

  scenario 'authenticated user adds invalid comment to question', js: true do
    sign_in(user)
    visit question_path(question)

    within('.question') do
      click_on 'комментировать'
      
      fill_in 'Комментарий', with: ''
      click_on 'сохранить'

      expect(page).to have_css('.add_comment .error')
    end
  end

  scenario 'authenticated user cancels adding comment', js: true do
    sign_in(user)
    visit question_path(question)

    within('.question') do
      click_on 'комментировать'

      fill_in 'Комментарий', with: 'Комментарий'
      click_on 'отмена'

      expect(page).not_to have_content('Комментарий')
      expect(page).not_to have_css('.new_comment')
    end
  end

  scenario 'unauthenticated user tries to add comment to question' do
    visit question_path(question)

    expect(page).not_to have_content('комментировать')
  end

end
