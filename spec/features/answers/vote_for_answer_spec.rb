require_relative '../feature_helper'

feature 'Vote for answer', %q{
  In order to like/dislike answer
  As an authnticated user
  I want to vote for answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer1) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question, user: user) }


  describe 'authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'likes answer', js: true do
      within "#answer-#{answer1.id}" do
        click_on '+'

        expect(page).to have_content '1'
        expect(page).to have_css('.like.voted')
      end
    end

    scenario 'cannot like answer twice', js: true do
      within "#answer-#{answer1.id}" do
        click_on '+'
        click_on '+'

        expect(page).to have_content '1'
      end
    end

    scenario 'can revote', js: true do
      within "#answer-#{answer1.id}" do
        click_on '+'
        click_on '-'
        expect(page).to have_content '0'

        click_on '-'
        expect(page).to have_content '-1'
        expect(page).to have_css('.dislike.voted')
        expect(page).not_to have_css('.like.voted')
      end
    end


    scenario 'cannot vote for own answer', js: true do
      within "#answer-#{answer2.id}" do
        expect(page).not_to have_content('+')
      end
    end
  end

  describe 'unauthenticated user' do
    scenario 'cannot vote for answer', js: true do
      visit question_path(question)

      within "#answer-#{answer1.id}" do
        click_on '+'
      end

      expect(page).to have_content('Только зарегистрированные пользователи могут голосовать')
    end
  end

end