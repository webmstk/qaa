require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should belong_to :user }
  it { should belong_to :question }

  it { should accept_nested_attributes_for :attachments }

  it { should respond_to :best }
  it { should respond_to :toggle_best }

  it 'should toggle best answer' do
    answer = create(:answer, best: false)

    answer.toggle_best
    answer.reload
    expect(answer.best).to eq true

    answer.toggle_best
    answer.reload
    expect(answer.best).to eq false
  end

  describe '#notify_subscribers' do
    let(:question) { create :question }
    let(:answer) { build :answer, question: question }

    it 'sends email to subscribers' do
      # subscriptions = Subscription.where(question: question)
      expect(answer).to receive(:notify_subscribers).and_call_original
      expect(NotifySubscribersJob).to receive(:perform_later).with(answer)
      answer.save
    end

  end
end
