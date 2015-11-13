require_relative '../feature_helper'
require 'capybara/email/rspec'

feature 'send email notifications when answer added' do
  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let(:answer) { build :answer, question: question }

  background do
    Sidekiq::Testing.inline!

    clear_emails
    answer.save
    open_email(user.email)
  end

  after { Sidekiq::Testing.fake! }

  scenario 'contains question title' do
    expect(current_email).to have_content(question.title)
  end

  scenario 'follows link' do
    current_email.click_link question.title
    expect(current_path).to eq question_path(question)
  end
end

