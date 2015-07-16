require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many :questions }
  it { should have_many :answers }

  describe '#vote_for' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:another_question) { create(:question) }
    let(:another_vote) { create(:positive_vote, votable: question) }

    it 'should not return vote' do
      expect(user.vote_for(question)).to eq nil
      expect(user.vote_for(another_question)).to eq nil
    end

    it 'should return vote' do
      vote = create(:positive_vote, votable: question, user: user)
      expect(user.vote_for(question)).to eq vote
    end
  end

  describe '#voted_for?' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:another_question) { create(:question) }
    let(:another_vote) { create(:positive_vote, votable: question) }

    it 'should not return vote' do
      expect(user.voted_for?(question)).to eq false
      expect(user.voted_for?(another_question)).to eq false
    end

    it 'should return vote' do
      vote = create(:positive_vote, votable: question, user: user)
      expect(user.voted_for?(question)).to eq true
    end
  end
end
