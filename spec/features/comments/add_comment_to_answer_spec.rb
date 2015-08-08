require_relative '../feature_helper'

feature 'Add comment to answer', %q{
  In order to create comment to answer
  As an authenticated user
  I want to comment answer
} do
  
  let(:user) { create :user }
  let(:question) { create :question }
  let!(:answer) { create :answer, question: question }

  scenario 'authenticated user adds valid comment to answer', js: true do
    sign_in(user)
    visit question_path(question)

    within('.answer') do
      click_on 'комментировать'
      fill_in 'Комментарий', with: 'Комментарий к ответу'
      click_on 'сохранить'
      
      expect(page).not_to have_css('.new_comment');
      expect(page).to have_content('Комментарий к ответу')
    end
  end

  scenario 'authenticated user adds invalid comment to answer', js: true do
    sign_in(user)
    visit question_path(question)

    within('.answer') do
      click_on 'комментировать'
      
      fill_in 'Комментарий', with: ''
      click_on 'сохранить'

      expect(page).to have_css('.add_comment .error')
    end
  end

  scenario 'authenticated user cancels adding comment', js: true do
    sign_in(user)
    visit question_path(question)

    within('.answer') do
      click_on 'комментировать'

      fill_in 'Комментарий', with: 'Комментарий'
      click_on 'отмена'

      expect(page).not_to have_content('Комментарий')
      expect(page).not_to have_css('.new_comment')
    end
  end

  scenario 'unauthenticated user tries to add comment to answer' do
    visit question_path(question)

    expect(page).not_to have_content('комментировать')
  end

end
