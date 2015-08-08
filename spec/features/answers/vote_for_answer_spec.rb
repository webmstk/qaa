require_relative '../feature_helper'

feature 'Vote for answer', %q{
  In order to like/dislike answer
  As an authenticated user
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
        click_link '', href: "/votes/#{answer1.id}/like?votable_type=Answer"

        expect(page).to have_content '1'
        expect(page).to have_css('.like.voted')
      end
    end

    scenario 'cannot like answer twice', js: true do
      within "#answer-#{answer1.id}" do
        like = page.find(:css, 'a[href="/votes/' + answer1.id.to_s + '/like?votable_type=Answer"]')
        like.click
        like.click

        expect(page).to have_content '1'
      end
    end

    scenario 'can revote', js: true do
      within "#answer-#{answer1.id}" do
        like = page.find(:css, 'a[href="/votes/' + answer1.id.to_s + '/like?votable_type=Answer"]')
        dislike = page.find(:css, 'a[href="/votes/' + answer1.id.to_s + '/dislike?votable_type=Answer"]')
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


    scenario 'cannot vote for own answer', js: true do
      within "#answer-#{answer2.id}" do
        click_link '', href: "/votes/#{answer2.id}/like?votable_type=Answer"

        expect(page).to have_content '0'
      end

      expect(page).to have_content('Вы не можете голосовать за свой ответ')
    end
  end

  describe 'unauthenticated user' do
    scenario 'cannot vote for answer', js: true do
      visit question_path(question)

      within "#answer-#{answer1.id}" do
        click_link '', href: "/votes/#{answer1.id}/like?votable_type=Answer"
      end

      expect(page).to have_content('Вам необходимо войти в систему или зарегистрироваться.')
    end
  end

end