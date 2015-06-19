require_relative '../feature_helper'

feature 'Edit question', %q{
  In order to fix mistake
  As an author of question
  I want to edit my question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:another_user_question) { create(:question, user: another_user) }

  scenario 'Non-authenticated user tries to edit question (questions_path)' do
    visit questions_path

    expect(page).not_to have_link 'редактировать'
  end

  scenario 'Non-authenticated user tries to edit question (question_path)' do
    visit question_path(question)

    expect(page).not_to have_link 'редактировать'
  end

  describe 'authenticated user' do
    before { sign_in user }

    describe 'visit questions path' do
      before { visit questions_path }

      scenario 'sees edit link' do
        within '.questions' do
          expect(page).to have_link 'редактировать'
        end
      end

      scenario 'redirects to edit question' do
        click_on 'редактировать'

        expect(current_path).to eq question_path(question)
      end

      scenario 'does not see another user edit link' do
        within "#question-id-#{another_user_question.id}" do
          expect(page).not_to have_link 'редактировать'
        end
      end
    end


    describe 'visits question path' do
      before { visit question_path(question) }

      scenario 'sees edit link' do
        within '.question' do
          expect(page).to have_link 'редактировать'
        end
      end

      scenario 'edits own question with valid attributes', js: true do
        click_on 'редактировать'

        expect(current_path).to eq question_path(question)

        within ".edit-question" do
          #expect(page).to have_content question.title # Почему rspec периодически не может найти этот текст?
          #expect(page).to have_content question.body # И этот?

          fill_in 'Заголовок', with: 'edited title'
          fill_in 'Сообщение', with: 'edited body'
          click_on 'Сохранить'

          expect(current_path).to eq question_path(question)
        end

        within '.question' do
          expect(page).to have_content 'edited title'
          expect(page).to have_content 'edited body'
        end
      end

      scenario 'edits own question with invalid attributes', js: true do
        click_on 'редактировать'

        expect(current_path).to eq question_path(question)

        within ".edit-question" do
          fill_in 'Заголовок', with: nil
          fill_in 'Сообщение', with: nil
          click_on 'Сохранить'

          expect(current_path).to eq question_path(question)
          expect(page).to have_content 'Не удалось сохранить вопрос'
        end
      end

      scenario 'edits own question and press cancel', js: true do
        click_on 'редактировать'

        expect(current_path).to eq question_path(question)

        within ".edit-question" do
          fill_in 'Заголовок', with: 'edited title'
          fill_in 'Сообщение', with: 'edited body'
          click_on 'Отмена'

          expect(current_path).to eq question_path(question)
        end

        within '.question' do
          expect(page).to have_content question.title
          expect(page).to have_content question.body
        end
      end
    end

    describe 'visits another user question path' do
      before { visit question_path(another_user_question) }

      scenario "tries to edit other user's question" do
        within ".question" do
          expect(page).not_to have_content 'редактировать'
        end
      end
    end
  end

end
