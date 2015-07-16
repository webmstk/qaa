require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }

  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should accept_nested_attributes_for :attachments }

  it do
    should validate_length_of(:title)
           .is_at_least(5)
           .is_at_most(140)
  end

  describe '#rating_up' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }

    context 'user didn\'t vote before' do
      it 'should create new vote if user didn\'t vote before' do
        expect { question.rating_up(user) }.to change(Vote, :count).by(1)
      end

      it 'should create vote with positive value' do
        question.rating_up(user)
        vote = Vote.last

        expect(vote.value).to eq 1
      end

      it 'should create vote with user' do
        question.rating_up(user)
        vote = Vote.last

        expect(vote.user).to eq user
      end

      it 'should return success status' do
        expect( question.rating_up(user) ).to eq 'success'
      end
    end

    context 'user voted positive before' do
      let!(:positive_vote) { create(:positive_vote, votable: question, user: user) }

      it 'should not create new vote' do
        expect { question.rating_up(user) }.to_not change(Vote, :count)
      end

      it 'should keep vote with positive value' do
        question.rating_up(user)
        expect( Vote.last ).to eq positive_vote
      end

      it 'should return voted_before status' do
        expect( question.rating_up(user) ).to eq 'voted_before'
      end
    end

    context 'user voted negative before' do
      let!(:negative_vote) { create(:negative_vote, votable: question, user: user) }

      it 'should delete previous vote' do
        expect { question.rating_up(user) }.to change(Vote, :count).by(-1)
      end

      it 'should return vote_canceled status' do
        expect( question.rating_up(user) ).to eq 'vote_canceled'
      end
    end

    context 'user voted for own votable' do
      let(:user_question) { create(:question, user: user) }

      it 'should not create new vote' do
        expect { user_question.rating_up(user) }.to_not change(Vote, :count)
      end

      it 'should return forbidden status' do
        expect( user_question.rating_up(user) ).to eq 'forbidden'
      end
    end
  end


  describe '#rating_down' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }

    context 'user didn\'t vote before' do
      it 'should create new vote if user didn\'t vote before' do
        expect { question.rating_down(user) }.to change(Vote, :count).by(1)
      end

      it 'should create vote with negative value' do
        question.rating_down(user)
        vote = Vote.last
        
        expect(vote.value).to eq -1
      end

      it 'should create vote with user' do
        question.rating_down(user)
        vote = Vote.last

        expect(vote.user).to eq user
      end

      it 'should return success status' do
        expect( question.rating_down(user) ).to eq 'success'
      end
    end

    context 'user voted negative before' do
      let!(:negative_vote) { create(:negative_vote, votable: question, user: user) }

      it 'should not create new vote' do
        expect { question.rating_down(user) }.to_not change(Vote, :count)
      end

      it 'should keep vote with negative value' do
        question.rating_down(user)
        expect( Vote.last ).to eq negative_vote
      end

      it 'should return voted_before status' do
        expect( question.rating_down(user) ).to eq 'voted_before'
      end
    end

    context 'user voted positive before' do
      let!(:posititve_vote) { create(:positive_vote, votable: question, user: user) }

      it 'should delete previous vote' do
        expect { question.rating_down(user) }.to change(Vote, :count).by(-1)
      end

      it 'should return vote_canceled status' do
        expect( question.rating_down(user) ).to eq 'vote_canceled'
      end
    end

    context 'user voted for own votable' do
      let(:user_question) { create(:question, user: user) }

      it 'should not create new vote' do
        expect { user_question.rating_down(user) }.to_not change(Vote, :count)
      end

      it 'should return forbidden status' do
        expect( user_question.rating_down(user) ).to eq 'forbidden'
      end
    end
  end

end
