require_relative '../feature_helper'

feature 'User can choose the best answer', %q{
  In order to mark the best answer
  As an author of question
  I want to choose and rechoose best answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question) }
  given(:another_question) { create(:question) }
  given!(:another_answer) { create(:answer, question: another_question) }

  scenario 'Non-authenticated user tries to choose best answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_content('лучший ответ')
    end
  end

  scenario 'Authenticated user does not see the best answer link to other\'s question' do
    sign_in(user)
    visit question_path(another_question)

    within '.answers' do
      expect(page).not_to have_content('лучший ответ');
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees the best answer link to his answer' do
      within '.answers' do
        expect(page).to have_content('лучший ответ');
      end
    end

    scenario 'chooses the best answer to his question', js: true do
      expect(page).not_to have_css('.best_answer')

      within "#answer-#{answer1.id}" do
        click_on 'лучший ответ'

        expect(current_path).to eq question_path(question)
        expect(page).to have_content 'не лучший ответ'
      end

      expect(page).to have_css('.best_answer')
    end

    scenario 'rechooses the best answer to his question', js: true do
      within "#answer-#{answer1.id}" do
        click_on 'лучший ответ'
      end

      within "#answer-#{answer2.id}" do
        click_on 'лучший ответ'
        expect(page).to have_content 'не лучший ответ'
      end

      within "#answer-#{answer1.id}" do
        expect(page).to have_content 'лучший ответ'
      end

      expect(page).not_to have_css("#answer-#{answer1.id}.best_answer")
      expect(page).to have_css("#answer-#{answer2.id}.best_answer")
    end

    scenario 'cancels best answer choice', js: true do
      within "#answer-#{answer1.id}" do
        click_on 'лучший ответ'
        click_on 'не лучший ответ'

        expect(page).to have_content 'лучший ответ'
      end

      expect(page).not_to have_css('.best_answer')
    end
  end

=begin
  describe 'best answer is always top' do
    given!(:best_answer) { create(:best_answer, question: question) }

    scenario 'after reloading page' do
      sign_in(user)
      visit question_path(question)

      first_answer = find('.answer:first')

      expect(first_answer).to have_content 'не лучший ответ'
    end

    scenario 'choosing another best answer', js: true do
      sign_in(user)
      visit question_path(question)

      within "#answer-#{answer1.id}" do
        click_on 'лучший ответ'
      end

      find("#answer-#{answer1.id}.best_answer")
    end
  end
=end

end