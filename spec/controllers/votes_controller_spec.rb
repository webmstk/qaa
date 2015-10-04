require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:question) { create :question }

  describe 'POST :like' do
    sign_in_user

    describe 'question' do

      context 'user never voted before' do
        it 'should create new vote' do
          expect do
            post :like, question_id: question.id, format: :json
          end.to change(Vote, :count).by(+1)
        end

        it 'should set vote value to +1' do
          post :like, question_id: question.id, format: :json

          expect(Vote.last.value).to eq 1
        end

        it 'should set question rating to +1' do
          post :like, question_id: question.id, format: :json

          question.reload
          expect(question.rating).to eq 1
        end

        it "should render json with success status, question's id and question's rating" do
          post :like, question_id: question.id, format: :json

          question.reload
          response_json = JSON.parse(response.body)
          expect(response_json['status']).to eq 'success'
          expect(response_json['id']).to eq question.id
          expect(response_json['rating']).to eq question.rating
        end
      end


      context 'user liked question before' do
        before do
          post :like, question_id: question.id, format: :json
        end

        it 'should not create new vote' do
          expect do
            post :like, question_id: question.id, format: :json
          end.not_to change(Vote, :count)
        end

        it 'should not change question\'s rating' do
          post :like, question_id: question.id, format: :json

          question.reload
          expect(question.rating).to eq 1
        end

        it 'should render json with voted_before status' do
          post :like, question_id: question.id, format: :json

          response_json = JSON.parse(response.body)
          expect(response_json['status']).to eq 'voted_before'
        end
      end


      context 'user disliked question before' do
        before { post :dislike, question_id: question.id, format: :json }

        it 'should delete vote' do
          expect do
            post :like, question_id: question.id, format: :json
          end.to change(Vote, :count).by(-1)
        end

        it 'should change question\'s rating to 0' do
          post :like, question_id: question.id, format: :json

          question.reload
          expect(question.rating).to eq 0
        end

        it "should render json with success status, question's id and question's rating" do
          post :like, question_id: question.id, format: :json

          response_json = JSON.parse(response.body)
          expect(response_json['status']).to eq 'vote_canceled'
          expect(response_json['id']).to eq question.id
          expect(response_json['rating']).to eq question.rating
        end
      end


      context 'rate own question' do
        before do
          question.update_attribute(:user, @user)
        end

        it 'should not create vote' do
          expect do
            post :like, question_id: question.id, format: :json
          end.not_to change(Vote, :count)
        end

        it 'should not change question\'s rating' do
          post :like, question_id: question.id, format: :json

          question.reload
          expect(question.rating).to eq 0
        end

        it 'should render json with forbidden status' do
          post :like, question_id: question.id, format: :json

          response_json = JSON.parse(response.body)
          expect(response_json['status']).to eq 'forbidden'
        end
      end

    end
  end


  describe 'POST :dislike' do
    sign_in_user

    describe 'question' do

      context 'user never voted before' do
        it 'should create new vote' do
          expect do
            post :dislike, question_id: question.id, format: :json
          end.to change(Vote, :count).by(+1)
        end

        it 'should set vote value to -1' do
          post :dislike, question_id: question.id, format: :json

          expect(Vote.last.value).to eq -1
        end

        it 'should set question rating to -1' do
          post :dislike, question_id: question.id, format: :json

          question.reload
          expect(question.rating).to eq -1
        end

        it "should render json with success status, question's id and question's rating" do
          post :dislike, question_id: question.id, format: :json

          question.reload
          response_json = JSON.parse(response.body)
          expect(response_json['status']).to eq 'success'
          expect(response_json['id']).to eq question.id
          expect(response_json['rating']).to eq question.rating
        end
      end


      context 'user disliked question before' do
        before do
          post :dislike, question_id: question.id, format: :json
        end

        it 'should not create new vote' do
          expect do
            post :dislike, question_id: question.id, format: :json
          end.not_to change(Vote, :count)
        end

        it 'should not change question\'s rating' do
          post :dislike, question_id: question.id, format: :json

          question.reload
          expect(question.rating).to eq -1
        end

        it 'should render json with voted_before status' do
          post :dislike, question_id: question.id, format: :json

          response_json = JSON.parse(response.body)
          expect(response_json['status']).to eq 'voted_before'
        end
      end


      context 'user liked question before' do
        before { post :like, question_id: question.id, format: :json }

        it 'should delete vote' do
          expect do
            post :dislike, question_id: question.id, format: :json
          end.to change(Vote, :count).by(-1)
        end

        it 'should change question\'s rating to 0' do
          post :dislike, question_id: question.id, format: :json

          question.reload
          expect(question.rating).to eq 0
        end

        it "should render json with success status, question's id and question's rating" do
          post :dislike, question_id: question.id, format: :json

          response_json = JSON.parse(response.body)
          expect(response_json['status']).to eq 'vote_canceled'
          expect(response_json['id']).to eq question.id
          expect(response_json['rating']).to eq question.rating
        end
      end


      context 'rate own question' do
        before do
          question.update_attribute(:user, @user)
        end

        it 'should not create vote' do
          expect do
            post :dislike, question_id: question.id, format: :json
          end.not_to change(Vote, :count)
        end

        it 'should not change question\'s rating' do
          post :dislike, question_id: question.id, format: :json

          question.reload
          expect(question.rating).to eq 0
        end

        it 'should render json with forbidden status' do
          post :dislike, question_id: question.id, format: :json

          response_json = JSON.parse(response.body)
          expect(response_json['status']).to eq 'forbidden'
        end
      end

    end
  end
end