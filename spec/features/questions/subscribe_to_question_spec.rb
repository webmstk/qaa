require_relative '../feature_helper'

feature 'user subscribes to question' do
  given(:user) { create :user }
  given(:question) { create :question }

  describe 'authenticated user can see links' do
    context 'user has no subscription' do
      scenario 'user see subscribe link' do
        sign_in(user)
        visit question_path(question)

        within('.question .controls') do
          expect(page).to have_content('подписаться')
        end
      end
    end

    context 'user has subscription' do
      scenario 'user see unsubscribe link' do
        sign_in(user)
        create :subscription, question: question, user: user
        visit question_path(question)

        within('.question .controls') do
          expect(page).to have_content('отписаться')
        end
      end
    end
  end

  scenario 'authenticated user can subscribe to question', js: true do
    sign_in(user)
    visit question_path(question)

    within('.question .controls') do
      click_on 'подписаться'

      expect(page).to have_css('.subscribed')
      expect(page).to have_link('отписаться', question_unsubscribe_path(question))
      # expect(page).to have_content('отписаться')
    end

    expect(current_path).to eq question_path(question)
  end

  scenario 'authenticated user can unsubscribe from question', js: true do
    sign_in(user)
    visit question_path(question)

    within('.question .controls') do
      click_on 'подписаться'
      click_on 'отписаться'

      expect(page).not_to have_css('.subscribed')
      expect(page).to have_content('подписаться')
    end

    expect(current_path).to eq question_path(question)
  end

  scenario 'non-authenticated user cannot subscribe to question' do
    visit question_path(question)

    within('.question .controls') do
      expect(page).not_to have_content('подписаться')
    end
  end
end