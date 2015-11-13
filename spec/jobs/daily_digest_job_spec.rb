require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:users) { create_list(:user, 2) }

  context 'questions exits' do
    let(:yesterday_questions) { create_list(:yesterday_question, 2, user: users.first) }

    it 'sends daily digest' do
      users.each do |user|
        expect(DailyMailer).to receive(:digest).with(user, yesterday_questions).and_call_original
      end

      DailyDigestJob.perform_now
    end
  end

  context 'questions do not exist' do
    it 'does not send daily digest' do
      users.each do |user|
        expect(DailyMailer).to_not receive(:digest).with(user, nil).and_call_original
      end

      DailyDigestJob.perform_now
    end
  end

end
