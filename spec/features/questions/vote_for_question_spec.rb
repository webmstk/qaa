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

      scenario 'likes question', js: true do
        within "#question-id-#{question1.id}" do
          click_link '', href: "/questions/#{question1.id}/votes/like"

          expect(page).to have_content '1'
          expect(page).to have_css('.like.voted')
        end
      end

      scenario 'cannot like question twice', js: true do
        within "#question-id-#{question1.id}" do
          like = page.find(:css, 'a[href="/questions/' + question1.id.to_s + '/votes/like"]')
          like.click
          like.click

          expect(page).to have_content '1'
        end
      end

      scenario 'can revote', js: true do
        within "#question-id-#{question1.id}" do
          like = page.find(:css, 'a[href="/questions/' + question1.id.to_s + '/votes/like"]')
          dislike = page.find(:css, 'a[href="/questions/' + question1.id.to_s + '/votes/dislike"]')
          like.click
          sleep 1
          dislike.click
          sleep 1
          expect(page).to have_content '0'

          dislike.click
          sleep 1
          expect(page).to have_content '-1'
          expect(page).to have_css('.dislike.voted')
          expect(page).not_to have_css('.like.voted')
        end
      end


      scenario 'cannot vote for own question', js: true do
        within "#question-id-#{question2.id}" do
          click_link '', href: "/questions/#{question2.id}/votes/like"

          expect(page).to have_content '0'
        end

        expect(page).to have_content('Вы не можете голосовать за свой ответ')
      end
    end

    describe 'unauthenticated user' do
      scenario 'cannot vote for question', js: true do
        visit questions_path

        within "#question-id-#{question1.id}" do
          click_link '', href: "/questions/#{question1.id}/votes/like"
        end

        expect(page).to have_content('Вам необходимо войти в систему или зарегистрироваться.')
      end
    end
  end


  describe 'visits question path' do
    describe 'authenticated user' do
      before do
        sign_in(user)
        visit question_path(question1)
      end

      scenario 'likes question', js: true do
        within "#question-id-#{question1.id}" do
          click_link '', href: "/questions/#{question1.id}/votes/like"

          expect(page).to have_content '1'
          expect(page).to have_css('.like.voted')
        end
      end

      scenario 'cannot like question twice', js: true do
        within "#question-id-#{question1.id}" do
          like = page.find(:css, 'a[href="/questions/' + question1.id.to_s + '/votes/like"]')
          like.click
          like.click

          expect(page).to have_content '1'
        end
      end

      scenario 'can revote', js: true do
        within "#question-id-#{question1.id}" do
          like = page.find(:css, 'a[href="/questions/' + question1.id.to_s + '/votes/like"]')
          dislike = page.find(:css, 'a[href="/questions/' + question1.id.to_s + '/votes/dislike"]')
          like.click
          sleep 1
          dislike.click
          sleep 1
          expect(page).to have_content '0'

          dislike.click
          sleep 1
          expect(page).to have_content '-1'
          expect(page).to have_css('.dislike.voted')
          expect(page).not_to have_css('.like.voted')
        end
      end

      scenario 'cannot vote for own question', js: true do
        visit question_path(question2)

        within "#question-id-#{question2.id}" do
          click_link '', href: "/questions/#{question2.id}/votes/like"

          expect(page).to have_content '0'
        end

        expect(page).to have_content('Вы не можете голосовать за свой ответ')
      end
    end

    describe 'unauthenticated user' do
      scenario 'cannot vote for question', js: true do
        visit question_path(question1)

        within "#question-id-#{question1.id}" do
          click_link '', href: "/questions/#{question1.id}/votes/like"
        end

        expect(page).to have_content('Вам необходимо войти в систему или зарегистрироваться.')
      end
    end
  end
end