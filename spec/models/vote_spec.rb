require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }
  it { should validate_presence_of :votable_type }

  describe '#rating_up' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    it "should increment question's rating" do
      expect { create(:positive_vote, votable: question, user: user) }.to change { question.rating }.by(1)
    end
  end

  describe '#rating_down' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:vote) { create(:positive_vote, votable: question, user: user) }

    it "should decrement question's rating" do
      expect { vote.destroy }.to change { question.rating }.by(-1)
    end
  end
end