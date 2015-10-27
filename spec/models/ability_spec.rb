require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end


  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end


  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create :question, user: user }
    let(:question_other) { create :question, user: other }
    let(:answer) { create :answer, question: question, user: user }
    let(:answer_other) { create :answer, question: question_other, user: other }
    let(:attachment) { create :attachment, attachable: answer }
    let(:attachment_other) { create :attachment, attachable: answer_other }
    let(:comment) { create :comment, commentable: question, user: user }
    let(:comment_other) { create :comment, commentable: question_other, user: other }
    let(:vote) { create :positive_vote, votable: answer_other }
    let(:vote_other) { create :positive_vote, votable: answer }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, question_other }
    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, answer_other }

    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, answer_other }
    it { should be_able_to :destroy, attachment }
    it { should_not be_able_to :destroy, attachment_other }
    it { should be_able_to :destroy, comment }
    it { should_not be_able_to :destroy, comment_other }
    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, question_other }

    it { should be_able_to :best, answer }
    it { should_not be_able_to :best, answer_other }

    it { should be_able_to :like, vote }
    it { should_not be_able_to :like, vote_other }

    it { should be_able_to :dislike, vote }
    it { should_not be_able_to :dislike, vote_other }

    it { should be_able_to :me, User }
    it { should be_able_to :index, User }
  end
end
