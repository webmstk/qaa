require_relative '../feature_helper'
require 'capybara/email/rspec'


feature 'questions digest' do
  given!(:user) { create :user }
  given!(:questions) { create_list(:yesterday_question, 2) }

  background do
    Sidekiq::Testing.inline!

    clear_emails
    DailyDigestJob.perform_now
    open_email(user.email)
  end

  after { Sidekiq::Testing.fake! }

  scenario 'contains digest list' do
    questions.each do |question|
      expect(current_email).to have_content(question.title)
    end
  end

  scenario 'following link' do
    current_email.click_link questions.first.title
    expect(current_path).to eq question_path(questions.first)
  end
end

