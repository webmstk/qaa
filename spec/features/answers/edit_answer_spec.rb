require_relative '../feature_helper'

feature 'Edit answer', %q{
  In order to fix mistake
  As an author of question
  I want to edit my question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question) }

  scenario 'Non-authenticated user tries to edit answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_content('редактировать')
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits own answer with valid attributes', js: true do
      within '.answers' do
        click_on 'редактировать'
        fill_in 'Сообщение', with: 'edited answer'
        click_on 'сохранить'

        expect(page).to have_content('edited answer')
      end
    end

    scenario 'edits own answer with invalid attributes', js: true do
      within '.answers' do
        click_on 'редактировать'
        fill_in 'Сообщение', with: nil
        click_on 'сохранить'

        expect(page).to have_content('Не удалось сохранить ответ')
      end
    end

    scenario 'edits own answer and press cancel', js: true do
      within '.answers' do
        click_on 'редактировать'
        fill_in 'Сообщение', with: 'edited answer'
        click_on 'отмена'

        expect(page).to have_content answer.body
      end
    end

    scenario 'tries to edit another user question' do
      within "#answer-#{answer2.id}" do
        expect(page).not_to have_content 'редактировать'
      end
    end
  end

end
