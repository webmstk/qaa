require 'rails_helper'

RSpec.describe NotifySubscribersJob, type: :job do
  let(:question) { create :question }
  let!(:subscription) { create :subscription, question: question }
  let(:answer) { create :answer, question: question }

  it 'sends notify emails' do
    subscriptions = answer.question.subscriptions

    subscriptions.each do |subscription|
      expect(NotifyMailer).to receive(:answer_added).with(subscription.user, subscription.question).and_call_original
    end

    NotifySubscribersJob.perform_now(answer)
  end
end
