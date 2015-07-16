require_relative '../feature_helper'

feature 'Vote for question', %q{
  In order to like/dislike question
  As an authnticated user
  I want to vote for question
} do

  given(:user) { create(:user) }
  given!(:question1) { create(:question) }
  given!(:question2) { create(:question, user: user) }


  describe 'visits questions path' do
    describe 'authenticated user' do
      before do
        sign_in(user)
        visit questions_path
      end

      scenario 'authenticated user likes question', js: true do
        within "#question-id-#{question1.id}" do
          click_on '+'

          expect(page).to have_content '1'
          expect(page).to have_css('.like.voted')
        end
      end

      scenario 'authenticated user cannot like question twice', js: true do
        within "#question-id-#{question1.id}" do
          click_on '+'
          click_on '+'

          expect(page).to have_content '1'
        end
      end

      scenario 'authenticated user can revote', js: true do
        within "#question-id-#{question1.id}" do
          click_on '+'
          click_on '-'
          expect(page).to have_content '0'

          click_on '-'
          expect(page).to have_content '-1'
          expect(page).to have_css('.dislike.voted')
          expect(page).not_to have_css('.like.voted')
        end
      end


      scenario 'user cannot vote for own question', js: true do
        within "#question-id-#{question2.id}" do
          expect(page).not_to have_content('+')
        end
      end
    end

    describe 'unauthenticated user' do
      scenario 'unauthenticated user cannot vote for question', js: true do
        visit questions_path

        within "#question-id-#{question1.id}" do
          click_on '+'
        end

        expect(page).to have_content('Только зарегистрированные пользователи могут голосовать')
      end
    end
  end


  describe 'visits question path' do
    describe 'authenticated user' do
      before do
        sign_in(user)
        visit question_path(question1)
      end

      scenario 'authenticated user likes question', js: true do
        within "#question-id-#{question1.id}" do
          click_on '+'

          expect(page).to have_content '1'
          expect(page).to have_css('.like.voted')
        end
      end

      scenario 'authenticated user cannot like question twice', js: true do
        within "#question-id-#{question1.id}" do
          click_on '+'
          click_on '+'

          expect(page).to have_content '1'
        end
      end

      scenario 'authenticated user can revote', js: true do
        within "#question-id-#{question1.id}" do
          click_on '+'
          click_on '-'
          expect(page).to have_content '0'

          click_on '-'
          expect(page).to have_content '-1'
          expect(page).to have_css('.dislike.voted')
          expect(page).not_to have_css('.like.voted')
        end
      end

      scenario 'user cannot vote for own question', js: true do
        visit question_path(question2)

        within "#question-id-#{question2.id}" do
          expect(page).not_to have_content('+')
        end
      end
    end

    describe 'unauthenticated user' do
      scenario 'unauthenticated user cannot vote for question', js: true do
        visit questions_path(question1)

        within "#question-id-#{question1.id}" do
          click_on '+'
        end

        expect(page).to have_content('Только зарегистрированные пользователи могут голосовать')
      end
    end
  end
end